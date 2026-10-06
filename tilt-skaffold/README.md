# tilt-skaffold

A `Tiltfile`, a `skaffold.yaml` and one `k8s.yaml` that both build and deploy the Orders image.

## Goal

Show the same inner loop (edit, rebuild, redeploy, port-forward) configured once for Tilt and once for Skaffold against a single Deployment. Both build `../multistage-dockerfile` as `orders-multistage` and forward port 8080.

## Run it

```bash
tilt up
skaffold dev
```

Expected: either tool builds the image, applies the `orders` Deployment to the current cluster and forwards `localhost:8080`; `curl localhost:8080/orders` then answers. Run one tool at a time.

Not run end to end: no local cluster was available and neither tool is installed here, so neither command was run.

## What it proves

- `Tiltfile` is 3 lines of Starlark: `docker_build`, `k8s_yaml`, `k8s_resource` with the port forward.
- `skaffold.yaml` declares the same build artifact, `rawYaml` manifest and port forward as YAML.
- `k8s.yaml` is shared, so the two configs can be compared directly.

## Trade-offs

- Tilt gives a live UI and scripting; Skaffold is declarative and also works in CI and deploy pipelines.
- Both need a local cluster such as kind or minikube, and that cluster must be able to use the locally built image.
- The Deployment has no probes or resource limits.

## When not to use it

- When Compose is enough for local development.
- When there is no local Kubernetes.
