# Thanos Docker Compose

Run a basic Thanos setup for local development using Docker and Docker Compose.

## Prerequisites

- You need to have Docker and docker-compose installed on your machine.
- We use GNU Make to run common tasks, you need to have `make` installed on your machine. You can run `make -v` to check if it is already installed.
- Thanos source code. You can clone the Thanos git repository locally using `git clone https://github.com/thanos-io/thanos`.
- Modify the `THANOS_SOURCE` variable in the `Makefile` so that it points to the cloned Thanos repo.

## Usage

### Start the dev environment

- Run `make up`

### Stop the dev environment

- Run `make stop`

### Restarting the env with changes

- We need to build the `thanos` binary again in case of changes
- Run `make build` here to build the binary again, and then run `make up` to restart the containers with new binary.

### Checking status of containers

- You can run `docker-compose ps` to list all containers running.
- Run `docker-compose logs <container-name>` to view logs for a container.

Refer to `docker-compose` documentation for a full overview.

## Credits

The `docker-compose.yml` is based on [PR#2583](https://github.com/thanos-io/thanos/pull/2583) on Thanos GitHub repo by [Darshan Chaudhary](https://github.com/darshanime)
