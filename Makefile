THANOS_SOURCE ?= ../thanos

GOPATH            ?= $(shell go env GOPATH)
GOBIN             ?= $(firstword $(subst :, ,${GOPATH}))/bin

THANOS_BINARY ?= $(GOBIN)/thanos

.PHONY: help
help: ## Displays help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-z0-9A-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: $(THANOS_BINARY)
$(THANOS_BINARY): ## Builds the Thanos binary from source code
$(THANOS_BINARY):
	@echo ">> building the Thanos binary"
	@make -C "$(THANOS_SOURCE)" build

.PHONY: up
up: ## Bootstraps a docker-compose setup for local development/demo
up: $(THANOS_BINARY)
	@echo ">> copying binaries to development env"
	@rm -f ./thanos/thanos || true
	cp "$(THANOS_BINARY)" ./thanos/
	docker-compose up -d --build

.PHONY: quick
quick: ## Restarts docker-compose to incorporate changes in docker-compose.yml
quick:
	docker-compose up -d

.PHONY: down
down: ## Brings down the docker-compose setup
down:
	docker-compose down
