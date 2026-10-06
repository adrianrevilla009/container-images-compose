# multistage-dockerfile

A two-stage `Dockerfile` that builds the Orders service with Maven and ships it on a JRE-only image.

## Goal

Keep Maven and the JDK in a build stage so the final image holds only a Java 21 JRE and the jar. The service is `src/main/java/orders/App.java`, a JDK `HttpServer` answering `/orders`.

## Run it

```bash
docker build -t orders-multistage .
docker run --rm -p 8080:8080 orders-multistage &
curl -s localhost:8080/orders
```

Expected: `[{"id":1,"item":"book","qty":2}]`.

Not run end to end: the image was not built or started here. `grep -c '^FROM' Dockerfile` gives 2. Building with the local Maven 3.8.6 (outside Docker) failed because its default compiler plugin ignores `maven.compiler.release`; the Dockerfile uses Maven 3.9.9, which was not exercised.

## What it proves

- `Dockerfile` has two `FROM` lines: `maven:3.9.9-eclipse-temurin-21` for the build and `eclipse-temurin:21-jre-alpine` for the runtime.
- `pom.xml` is copied and `dependency:go-offline` runs before `src` is copied, so dependencies sit in their own cached layer.
- The runtime stage creates user `app` and switches to it with `USER app`, so the process is not root.

## Trade-offs

- Two base images to keep patched.
- The alpine JRE image still has a shell and package manager (see `distroless`).
- `dependency:go-offline` does not always fetch every plugin, so the cache layer can be incomplete.

## When not to use it

- When CI already builds the jar and you only need to package it; Jib does that without a Dockerfile.
- When the team has no one to maintain Dockerfiles; Buildpacks removes that need.
