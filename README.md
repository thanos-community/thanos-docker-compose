# Thanos Docker Compose

Run a basic Thanos setup for local development using Docker and Docker Compose.

## Prerequisites

- You need to have Docker and docker-compose installed on your machine.
- We use GNU Make to run common tasks, you need to have `make` installed on your machine. You can run `make -v` to check if it is already installed.
- Thanos source code. Easiest way to achieve this is by cloning the Thanos git repository locally using `git clone https://github.com/thanos-io/thanos`.
- You need to have Go installed as it is required to build Thanos.
- Modify the `THANOS_SOURCE` variable in the `Makefile` so that it points to the directory containing Thanos source code. This step is required to build `thanos` binary from this directory.

## Usage

### Start the dev environment

- Run `make up`

> NOTE: If you are using MacOS, run `GOOS=linux make up`. This target tries to build the binary by running `make build` inside the `$THANOS_SOURCE` directory defined in the Makefile, and then gets the `thanos` binary from `$GOPATH/bin/thanos`. You need to set up the `THANOS_SOURCE` variable for this to work.

### Stop the dev environment

- Run `make stop`

### Restarting the env with changes

- We need to build the `thanos` binary again in case of changes in source code, just run `make up` to restart the containers with new changes, it takes care of building the binary for you.
- If you want to skip building the binary, and just restart the docker containers (for example when you are testing different flags), you can run `make restart` to restart the conatiners.

### Checking status of containers

- You can run `docker-compose ps` to list all containers running.
- Run `docker-compose logs <container-name>` to view logs for a container.

Refer to `docker-compose` documentation for a full overview.

### Connecting to minio

After running `make up` you would be able to access `minio` at `http://localhost:9000`. The access key is `myaccesskey` and the secret key is `mysecretkey`.

## What does it starts?

| Service            |                                                                              | Ports |
| ------------------ | ---------------------------------------------------------------------------- | ----- |
| prometheus_one     | The first Prometheus server                                                  | 9001  |
| prometheus_two     | The second Prometheus server                                                 |       |
| minio              | A minio instance serving as Object Storage for store, compactor and sidecars | 9000  |
| thanos_sidecar_one | First Thanos sidecar for prometheus_one                                      |       |
| thanos_sidecar_two | Second Thanos sidecar for prometheus_two                                     |       |
| thanos_querier     | Thanos querier instance connected to both sidecars and Thanos store          | 10902 |
| thanos_compactor   | Thanos compactor running with `--wait` and `--wait-interval=3m`              | 10922 |
| thanos_store       | A Thanos store instance connected to minio                                   | 10912 |

### Optional services

There are some services which are commented out in the `docker-compose.yml`. You can uncomment and use them if needed.

| Service      |                                                                                                          | Ports |
| ------------ | -------------------------------------------------------------------------------------------------------- | ----- |
| grafana      | A Grafana instance with username = admin, and password = admin                                           | 3000  |
| bucket_web   | Thanos Bucket Inspector webUI                                                                            | 8080  |
| debug        | A debug container running on ubuntu with `thanos` binary. You can use this to debug services from inside | 10902 |
| alertmanager | Prometheus Alertmanager to send alerts                                                                   | 9093  |
| thanos_rule  | Thanos Rule instance to create recording and alerting rules                                              | 10932 |

You can start a debug container and/or Thanos Bucket WebUI by uncommenting the corresponding defination in `docker-compose.yml`.

For Alertmanager to work, you need to set the Slack webhook URL in `prometheus/alertmanager.yml`.

## Credits

The `docker-compose.yml` is based on [PR#2583](https://github.com/thanos-io/thanos/pull/2583) on Thanos GitHub repo by [Darshan Chaudhary](https://github.com/darshanime)
