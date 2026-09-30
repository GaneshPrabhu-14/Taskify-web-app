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

### Run with Docker

Make sure Docker Desktop is running and `.env` contains a valid MongoDB Atlas URI. From the project root, build the image and start the app:

```powershell
docker build -t taskify .
docker run --name taskify -p 8080:8080 --env-file .env taskify
```

Open `http://localhost:8080/`. Keep the terminal running while using the app; press `Ctrl+C` to stop it. To start the existing container again later, run:

```powershell
docker start -ai taskify
```

If you change `.env`, recreate the container so it receives the updated environment:

```powershell
docker rm -f taskify
docker run --name taskify -p 8080:8080 --env-file .env taskify
```

If you change application source code, rebuild the WAR and image before recreating the container:

```powershell
mvn package
docker build -t taskify .
docker rm -f taskify
docker run --name taskify -p 8080:8080 --env-file .env taskify
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
