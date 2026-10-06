# container-images-compose

Seven ways to package and run one tiny Java 21 Orders HTTP service as a container image, plus Compose profiles, Tilt/Skaffold inner loops and a devcontainer, so the trade-offs can be compared side by side.

## What is inside

| Folder | What it shows | Run |
| --- | --- | --- |
| [`multistage-dockerfile`](./multistage-dockerfile) | Maven build stage, JRE-alpine runtime stage, non-root user | `docker build -t orders-multistage .` |
| [`jib`](./jib) | Image built from Maven with Jib, no Dockerfile | `mvn -q -B package jib:dockerBuild` |
| [`buildpacks`](./buildpacks) | Paketo buildpacks with `pack`, JVM pinned in `project.toml` | `pack build orders-bp --builder paketobuildpacks/builder-jammy-base:0.4.440 --path .` |
| [`distroless`](./distroless) | Same service on a distroless Java 21 nonroot base | `docker build -t orders-distroless .` |
| [`image-size-compare`](./image-size-compare) | Script that builds three variants and prints size and startup | `./compare.sh` |
| [`compose-profiles`](./compose-profiles) | App always on, Postgres and Adminer behind profiles | `docker compose --profile db config --services` |
| [`tilt-skaffold`](./tilt-skaffold) | The same rebuild-and-redeploy loop in Tilt and in Skaffold | `tilt up` or `skaffold dev` |
| [`devcontainer`](./devcontainer) | Java 21, Maven and Docker toolchain as a devcontainer | `devcontainer up --workspace-folder .` |

The service is the shared Orders example: `GET /orders` on port 8080 returns one JSON order.

## Prerequisites

- Docker with Compose v2 (every folder except `jib` buildTar needs a daemon to build or run images)
- Java 21 and Maven 3.9 (for `jib` and `image-size-compare`)
- `pack` CLI (for `buildpacks`)
- `kubectl`, a local cluster such as kind or minikube, and Tilt or Skaffold (for `tilt-skaffold`)
- VS Code with Dev Containers, or `@devcontainers/cli` (for `devcontainer`)

## How to read it

Start with `multistage-dockerfile`, then read `jib`, `buildpacks` and `distroless` as alternatives to it. `image-size-compare` ties the first ones together; the last three folders are about running the image day to day.
