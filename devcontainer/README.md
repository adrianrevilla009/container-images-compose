# devcontainer

A `.devcontainer/devcontainer.json` that gives contributors a Java 21, Maven and Docker toolchain.

## Goal

Replace a setup wiki page with a declared environment. The file uses `mcr.microsoft.com/devcontainers/java:1-21-bookworm`, adds the docker-outside-of-docker feature, forwards port 8080 and installs the Java extension pack in VS Code.

## Run it

```bash
devcontainer up --workspace-folder .
python3 -c "import json;json.load(open('.devcontainer/devcontainer.json'))"
```

Alternatively open the folder in VS Code and choose "Reopen in Container". Expected: after creation, `postCreateCommand` prints the `java -version` and `mvn -v` output; the Python line prints nothing when the JSON parses.

Not run end to end: the container was not started here. Only the JSON parse was checked.

## What it proves

- One JSON file holds the base image, the Docker feature, the forwarded port and the post-create check.
- `postCreateCommand` (`java -version && mvn -v`) fails container setup if the toolchain is missing.
- The docker-outside-of-docker feature lets the other folders' `docker build` commands run from inside the container.

## Trade-offs

- It needs Docker and an editor or CLI that supports devcontainers.
- Bind mounts can be slow on macOS and Windows.
- The `1-21-bookworm` tag floats within Java 21, so builds are not fully reproducible.

## When not to use it

- When the toolchain is one binary already installed everywhere.
- When contributors cannot run containers.
