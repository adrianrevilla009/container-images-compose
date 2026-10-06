# jib

The Orders service with `jib-maven-plugin` configured in `pom.xml`, so Maven builds the image directly.

## Goal

Build an OCI image from Maven with no Dockerfile. The plugin takes `eclipse-temurin:21-jre-alpine` as base, tags the result `orders-jib:1.0.0` and exposes port 8080.

## Run it

```bash
mvn -q -B package jib:dockerBuild   # needs a local Docker daemon
mvn -q -B package jib:buildTar      # no daemon: writes target/jib-image.tar
```

Expected: no output with `-q`; `docker image ls orders-jib` lists `1.0.0`, or `target/jib-image.tar` exists.

Not run end to end: neither goal was executed here. Maven 3.8.6 on this machine failed to compile the project (its default compiler plugin ignores `maven.compiler.release`), so use Maven 3.9 or newer.

## What it proves

- `pom.xml` is the only image definition: `from`, `to` and `container/ports` under `jib-maven-plugin` 3.4.4.
- Jib puts dependencies, resources and classes in separate layers, so a code change rewrites only the small classes layer.
- `buildTar` produces an image without a Docker daemon.

## Trade-offs

- JVM projects only, and image settings live in the pom.
- No arbitrary `RUN` steps, so OS packages cannot be installed.
- The plugin and base image versions must be bumped by hand.

## When not to use it

- When the image needs OS packages or non-JVM tooling.
- When the project is not built with Maven or Gradle.
