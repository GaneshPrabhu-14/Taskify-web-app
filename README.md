# Taskify

Taskify is a Java 17 / JSP task manager. User accounts and tasks are stored in MongoDB; passwords are hashed with BCrypt and the browser uses an HTTP-only session cookie.

## Configure MongoDB Atlas

1. Create an Atlas cluster and a database user.
2. In Atlas Network Access, allow the IP address of the machine running Taskify. Avoid `0.0.0.0/0` except for temporary testing.
3. Copy `.env.example` to `.env` and replace the URI placeholders with your Atlas connection details. Set `MONGODB_DATABASE` if you want a database name other than `taskify`.
4. If your database password includes reserved URL characters, URL-encode those characters in the connection URI.
5. Keep `.env` private. It is ignored by Git. For hosted deployment, configure `MONGODB_URI` and `MONGODB_DATABASE` as environment variables/secrets in the host; do not upload `.env` or commit credentials.

The app creates the `users` and `tasks` collections as needed and creates a unique index on user email.

## Build and run

Build the deployable WAR:

```powershell
mvn package
```

Deploy `target/Taskify-web-app.war` to a Java 17-compatible Servlet 4 container such as Tomcat 9, then open `http://localhost:8080/Taskify-web-app/`. The environment variables must be available to the Tomcat process, or the project-root `.env` must be readable from its working directory.

## API routes

- `POST /api/auth/register` - create an account
- `POST /api/auth/login` - start a session
- `GET /api/auth/session` - restore the current session
- `POST /api/auth/logout` - end the session
- `GET /api/tasks` - list the signed-in user's tasks
- `POST /api/tasks` - create a task
- `PUT /api/tasks/{id}` - update task completion
- `DELETE /api/tasks/{id}` - delete a task
