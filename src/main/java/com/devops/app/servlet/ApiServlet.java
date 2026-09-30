package com.devops.app.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

abstract class ApiServlet extends HttpServlet {
    private static final Gson GSON = new Gson();

    protected JsonObject readJson(HttpServletRequest request) throws IOException {
        JsonElement body = JsonParser.parseReader(request.getReader());
        if (body == null || !body.isJsonObject()) {
            throw new IllegalArgumentException("Request body must be a JSON object.");
        }
        return body.getAsJsonObject();
    }

    protected void sendJson(HttpServletResponse response, int status, Object value) throws IOException {
        response.setStatus(status);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setHeader("Cache-Control", "no-store");
        GSON.toJson(value, response.getWriter());
    }

    protected void sendError(HttpServletResponse response, int status, String message) throws IOException {
        sendJson(response, status, Map.of("error", message));
    }

    protected String sessionUserId(HttpServletRequest request) {
        if (request.getSession(false) == null) {
            return null;
        }
        Object userId = request.getSession(false).getAttribute("userId");
        return userId instanceof String ? (String) userId : null;
    }

    protected boolean requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (sessionUserId(request) != null) {
            return true;
        }
        sendError(response, HttpServletResponse.SC_UNAUTHORIZED, "Please log in to continue.");
        return false;
    }

    protected void logDatabaseError(Exception exception) {
        getServletContext().log("Taskify could not complete a database request.", exception);
    }
}
