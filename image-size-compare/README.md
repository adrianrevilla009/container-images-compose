# image-size-compare

`compare.sh` builds three Orders images and prints a table of image size and time to first response.

## Goal

Make image size and startup differences concrete for the multi-stage, distroless and Jib variants. The script builds `../multistage-dockerfile`, `../distroless` and `../jib`.

## Run it

```bash
./compare.sh
```

Expected: a table with the header `IMAGE SIZE_MB STARTUP_MS` and one row each for `orders-multistage`, `orders-distroless` and `orders-jib:1.0.0`.

Not run end to end: the script was not executed here, so no numbers are claimed. `bash -n compare.sh` checks only the syntax.

## What it proves

- Size comes from `docker image inspect` in megabytes, so each variant is measured the same way.
- Startup is the time from `docker run -d` until `curl` on port 18080 succeeds, polled every 50 ms.
- Every image serves the same `/orders` response, so differences come from packaging.

## Trade-offs

- Startup includes container creation and the polling loop, and each image runs once, so it is a rough comparison.
- Buildpacks is left out because its first build downloads a large builder.
- Port 18080 must be free, and the script needs Docker and Maven 3.9.

## When not to use it

- When you need a real benchmark: use repeated runs and a proper harness.
- When image size does not matter for your deployment.
