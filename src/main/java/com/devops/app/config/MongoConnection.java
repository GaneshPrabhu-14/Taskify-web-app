package com.devops.app.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoClient;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import io.github.cdimascio.dotenv.Dotenv;
import org.bson.Document;

import java.util.concurrent.TimeUnit;

public final class MongoConnection {
    private static final Dotenv DOTENV = Dotenv.configure()
            .directory(System.getProperty("user.dir"))
            .ignoreIfMissing()
            .load();
        private static volatile MongoClient client;
    private static volatile boolean userIndexReady;

    private MongoConnection() {
    }

    public static MongoDatabase database() {
        String databaseName = setting("MONGODB_DATABASE");
        if (databaseName == null || databaseName.isBlank()) {
            databaseName = "taskify";
        }
        return client().getDatabase(databaseName);
    }

    public static MongoCollection<Document> users() {
        MongoCollection<Document> collection = database().getCollection("users");
        if (!userIndexReady) {
            synchronized (MongoConnection.class) {
                if (!userIndexReady) {
                    collection.createIndex(Indexes.ascending("email"), new IndexOptions().unique(true));
                    userIndexReady = true;
                }
            }
        }
        return collection;
    }

    public static MongoCollection<Document> tasks() {
        return database().getCollection("tasks");
    }

    private static String setting(String key) {
        String value = System.getenv(key);
        return value != null ? value : DOTENV.get(key);
    }

    private static MongoClient client() {
        MongoClient current = client;
        if (current != null) {
            return current;
        }
        synchronized (MongoConnection.class) {
            if (client == null) {
                client = createClient();
            }
            return client;
        }
    }

    private static MongoClient createClient() {
        String uri = setting("MONGODB_URI");
        if (uri == null || uri.isBlank() || uri.contains("<") || uri.contains(">")) {
            throw new IllegalStateException("Set MONGODB_URI in the project .env file or the server environment.");
        }

        ConnectionString connectionString = new ConnectionString(uri);
        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(connectionString)
                .applyToClusterSettings(cluster -> cluster.serverSelectionTimeout(5, TimeUnit.SECONDS))
                .build();
        return MongoClients.create(settings);
    }

}
