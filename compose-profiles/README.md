# compose-profiles

A `compose.yaml` where only the Orders app starts by default and Postgres and Adminer sit behind profiles.

## Goal

Show that `docker compose up` can start just the app, while `--profile db` and `--profile debug` opt into the database and a database UI. `.env.example` holds `POSTGRES_PASSWORD`.

## Run it

```bash
docker compose config --services
docker compose --profile db config --services
docker compose --profile db --profile debug config --services
docker compose --profile db up -d    # needs the orders-multistage image
```

Expected: the first prints `app`; the second prints `app` and `db`; the third adds `adminer`. Copy `.env.example` to `.env` to change the password.

The first two were run and printed that output. The third and the `up` command were not run; `up` needs the image from `multistage-dockerfile`.

## What it proves

- `app` has no profile, so it is always in the service list.
- `db` is only listed with `--profile db`.
- `--profile debug` alone fails with `no such service: db`, because `adminer` depends on `db`.

## Trade-offs

- A profiled service that is a `depends_on` target must be activated together with its dependent.
- The default password `changeme` is for local use only.
- The app uses a local image name, so it must be built first.

## When not to use it

- When the optional parts are really separate stacks; use separate Compose files or overrides.
