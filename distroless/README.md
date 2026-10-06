# distroless

The Orders service built in a Maven stage and run on `gcr.io/distroless/java21-debian12:nonroot`.

## Goal

Ship the same service with no shell and no package manager, running as non-root. The `Dockerfile` has a Maven 3.9.9 build stage and a distroless runtime stage.

## Run it

```bash
docker build -t orders-distroless .
docker run --rm -p 8080:8080 orders-distroless &
curl -s localhost:8080/orders
docker run --rm --entrypoint sh orders-distroless
```

Expected: the curl prints `[{"id":1,"item":"book","qty":2}]`; the last command fails because there is no `sh`.

Not run end to end: the image was not built here. The only check made was reading the `Dockerfile`.

## What it proves

- The runtime stage has only the JVM and `/app/orders.jar`; overriding the entrypoint with `sh` fails.
- The `:nonroot` tag runs as a non-root user without a `USER` line.
- The service code and `pom.xml` are identical to `multistage-dockerfile`, so only the base image differs.

## Trade-offs

- Debugging is harder: no `docker exec ... sh`; use the `:debug` tag or an ephemeral debug container.
- A `HEALTHCHECK` or entrypoint script that needs a shell does not work.
- Unlike `multistage-dockerfile`, dependencies are not cached in a separate layer.

## When not to use it

- When you need a shell or OS packages at runtime.
- When your security team already scans and accepts a slim distro image.
