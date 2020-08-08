.PHONY: help

help: ## help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

config: ## use docker-for-desktop
	kubectl config use-context docker-for-desktop

status: config ## status
	watch --interval 1 "kubectl get all"

run: config ## run mock
	skaffold dev
