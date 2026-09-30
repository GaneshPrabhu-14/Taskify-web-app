package com.devops.app.servlet;

import com.devops.app.config.MongoConnection;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.mongodb.MongoException;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Sorts.descending;
import static com.mongodb.client.model.Updates.set;

@WebServlet("/api/tasks/*")
public final class TasksServlet extends ApiServlet {
    private static final Set<String> CATEGORIES = Set.of("Work", "Personal", "Study", "Health");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!requireLogin(request, response)) return;
        try {
            String ownerId = sessionUserId(request);
            List<Map<String, Object>> result = new ArrayList<>();
            for (Document task : MongoConnection.tasks().find(eq("ownerId", ownerId)).sort(descending("createdAt"))) {
                result.add(taskSummary(task));
            }
            sendJson(response, HttpServletResponse.SC_OK, Map.of("tasks", result));
        } catch (MongoException | IllegalStateException exception) {
            databaseUnavailable(response, exception);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!requireLogin(request, response)) return;
        try {
            JsonObject body = readJson(request);
            String title = stringValue(body, "title").trim();
            String category = stringValue(body, "category");
            String due = stringValue(body, "due");
            if (title.isEmpty() || title.length() > 120 || !CATEGORIES.contains(category)) {
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Enter a task name and choose a valid category.");
                return;
            }
            if (!due.isEmpty()) {
                try {
                    LocalDate.parse(due);
                } catch (DateTimeParseException exception) {
                    sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Enter a valid due date.");
                    return;
                }
            }
            Document task = new Document("ownerId", sessionUserId(request))
                    .append("title", title)
                    .append("category", category)
                    .append("due", due)
                    .append("done", false)
                    .append("createdAt", System.currentTimeMillis());
            MongoConnection.tasks().insertOne(task);
            sendJson(response, HttpServletResponse.SC_CREATED, Map.of("task", taskSummary(task)));
        } catch (JsonParseException | IllegalArgumentException exception) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Please check the submitted task.");
        } catch (MongoException | IllegalStateException exception) {
            databaseUnavailable(response, exception);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!requireLogin(request, response)) return;
        ObjectId taskId = parseTaskId(request, response);
        if (taskId == null) return;
        try {
            JsonObject body = readJson(request);
            if (!body.has("done") || !body.get("done").isJsonPrimitive() || !body.getAsJsonPrimitive("done").isBoolean()) {
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Task completion must be true or false.");
                return;
            }
            long matched = MongoConnection.tasks().updateOne(
                    and(eq("_id", taskId), eq("ownerId", sessionUserId(request))),
                    set("done", body.get("done").getAsBoolean())).getMatchedCount();
            if (matched == 0) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Task not found.");
                return;
            }
            sendJson(response, HttpServletResponse.SC_OK, Map.of("message", "Task updated."));
        } catch (JsonParseException | IllegalArgumentException exception) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Please check the submitted task.");
        } catch (MongoException | IllegalStateException exception) {
            databaseUnavailable(response, exception);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!requireLogin(request, response)) return;
        ObjectId taskId = parseTaskId(request, response);
        if (taskId == null) return;
        try {
            long deleted = MongoConnection.tasks().deleteOne(
                    and(eq("_id", taskId), eq("ownerId", sessionUserId(request)))).getDeletedCount();
            if (deleted == 0) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Task not found.");
                return;
            }
            sendJson(response, HttpServletResponse.SC_OK, Map.of("message", "Task deleted."));
        } catch (MongoException | IllegalStateException exception) {
            databaseUnavailable(response, exception);
        }
    }

    private ObjectId parseTaskId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo();
        if (path == null || !path.matches("/[a-fA-F0-9]{24}")) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid task id.");
            return null;
        }
        return new ObjectId(path.substring(1));
    }

    private String stringValue(JsonObject body, String key) {
        if (!body.has(key) || !body.get(key).isJsonPrimitive() || !body.getAsJsonPrimitive(key).isString()) {
            return "";
        }
        return body.get(key).getAsString();
    }

    private Map<String, Object> taskSummary(Document task) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("id", task.getObjectId("_id").toHexString());
        result.put("title", task.getString("title"));
        result.put("category", task.getString("category"));
        result.put("due", task.getString("due"));
        result.put("done", Boolean.TRUE.equals(task.getBoolean("done")));
        result.put("createdAt", task.getLong("createdAt"));
        return result;
    }

    private void databaseUnavailable(HttpServletResponse response, Exception exception) throws IOException {
        logDatabaseError(exception);
        sendError(response, HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                "Taskify can't reach MongoDB. Check MONGODB_URI and your Atlas network access list.");
    }
}
