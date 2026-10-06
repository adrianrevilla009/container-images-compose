# buildpacks

The Orders service plus a `project.toml`, built into an image by Cloud Native Buildpacks with the `pack` CLI.

## Goal

Go from source to image with no Dockerfile. The Paketo builder `paketobuildpacks/builder-jammy-base:0.4.440` is pinned, and `project.toml` sets `BP_JVM_VERSION=21`.

## Run it

```bash
pack build orders-bp --builder paketobuildpacks/builder-jammy-base:0.4.440 --path .
docker run --rm -p 8080:8080 orders-bp &
curl -s localhost:8080/orders
python3 -c "import tomllib;tomllib.load(open('project.toml','rb'))"
```

Expected: the curl prints `[{"id":1,"item":"book","qty":2}]`; the Python line prints nothing when the TOML parses.

Not run end to end: `pack` is not installed here and no image was built. Only the TOML parse is a static check.

## What it proves

- The only inputs are the Maven project and `project.toml`; the builder detects Maven and picks a JRE itself.
- `BP_JVM_VERSION` in `project.toml` selects Java 21 to match `maven.compiler.release` in `pom.xml`.
- Paketo images are layered and carry a software bill of materials.

## Trade-offs

- The first build downloads the large builder image.
- You follow the builder's release cadence and have less control over layers than with a Dockerfile.
- The builder tag has to be bumped manually.

## When not to use it

- When you need exact control over the filesystem.
- When the base image must come from outside the buildpack ecosystem.
