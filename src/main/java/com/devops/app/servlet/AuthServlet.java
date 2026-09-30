package com.devops.app.servlet;

import com.devops.app.config.MongoConnection;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.mongodb.MongoException;
import com.mongodb.MongoWriteException;
import org.bson.Document;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.regex.Pattern;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/api/auth/*")
public final class AuthServlet extends ApiServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!"/session".equals(request.getPathInfo())) {
            sendError(response, HttpServletResponse.SC_NOT_FOUND, "Route not found.");
            return;
        }
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            sendError(response, HttpServletResponse.SC_UNAUTHORIZED, "Please log in.");
            return;
        }
        sendJson(response, HttpServletResponse.SC_OK, Map.of("user", Map.of(
                "name", session.getAttribute("userName"),
                "email", session.getAttribute("userEmail"))));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String route = request.getPathInfo();
        if (route == null) route = "/";
        try {
            switch (route) {
                case "/register" -> register(request, response);
                case "/login" -> login(request, response);
                case "/logout" -> logout(request, response);
                default -> sendError(response, HttpServletResponse.SC_NOT_FOUND, "Route not found.");
            }
        } catch (JsonParseException | IllegalArgumentException exception) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Please check the submitted information.");
        } catch (MongoWriteException exception) {
            if (exception.getError().getCode() == 11000) {
                sendError(response, HttpServletResponse.SC_CONFLICT, "An account with this email already exists.");
            } else {
                databaseUnavailable(response, exception);
            }
        } catch (MongoException | IllegalStateException exception) {
            databaseUnavailable(response, exception);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonObject body = readJson(request);
        String name = stringValue(body, "name").trim();
        String email = stringValue(body, "email").trim().toLowerCase();
        String password = stringValue(body, "password");
        if (name.isEmpty() || name.length() > 50 || !EMAIL_PATTERN.matcher(email).matches()
                || password.length() < 8 || password.length() > 72) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Enter a name, a valid email, and a password between 8 and 72 characters.");
            return;
        }

        Document user = new Document("name", name)
                .append("email", email)
                .append("passwordHash", BCrypt.hashpw(password, BCrypt.gensalt(12)))
                .append("createdAt", System.currentTimeMillis());
        MongoConnection.users().insertOne(user);
        startSession(request, user);
        sendJson(response, HttpServletResponse.SC_CREATED, Map.of("user", userSummary(user)));
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonObject body = readJson(request);
        String email = stringValue(body, "email").trim().toLowerCase();
        String password = stringValue(body, "password");
        Document user = MongoConnection.users().find(eq("email", email)).first();
        if (user == null || !BCrypt.checkpw(password, user.getString("passwordHash"))) {
            sendError(response, HttpServletResponse.SC_UNAUTHORIZED, "Email or password doesn't match.");
            return;
        }
        startSession(request, user);
        sendJson(response, HttpServletResponse.SC_OK, Map.of("user", userSummary(user)));
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        sendJson(response, HttpServletResponse.SC_OK, Map.of("message", "Logged out."));
    }

    private void startSession(HttpServletRequest request, Document user) {
        HttpSession previous = request.getSession(false);
        if (previous != null) {
            previous.invalidate();
        }
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(30 * 60);
        session.setAttribute("userId", user.getObjectId("_id").toHexString());
        session.setAttribute("userName", user.getString("name"));
        session.setAttribute("userEmail", user.getString("email"));
    }

    private Map<String, String> userSummary(Document user) {
        return Map.of("name", user.getString("name"), "email", user.getString("email"));
    }

    private String stringValue(JsonObject body, String key) {
        if (!body.has(key) || !body.get(key).isJsonPrimitive() || !body.getAsJsonPrimitive(key).isString()) {
            return "";
        }
        return body.get(key).getAsString();
    }

    private void databaseUnavailable(HttpServletResponse response, Exception exception) throws IOException {
        logDatabaseError(exception);
        sendError(response, HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                "Taskify can't reach MongoDB. Check MONGODB_URI and your Atlas network access list.");
    }
}
