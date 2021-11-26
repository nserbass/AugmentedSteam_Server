current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Display this help message
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deps
deps: composer-install ## Install composer dependencies

# 🐘 Composer
.PHONY: composer-install
composer-install: CMD=install

.PHONY: composer-update
composer-update: CMD=update ## Update composer dependencies

.PHONY: composer-require
composer-require: CMD=require
composer-require: INTERACTIVE=-ti --interactive

.PHONY: composer-require-module
composer-require-module: CMD=require $(module) ## install required module. Use: make composer-require-module module=symfony/console
composer-require-module: INTERACTIVE=-ti --interactive

composer composer-install composer-update composer-require composer-require-module:
	docker run --rm $(INTERACTIVE) --volume $(current-dir)lib/:/app --user 1000:1000 \
		composer:2 $(CMD) \
			--ignore-platform-reqs \
			--no-ansi \
			--no-scripts

.PHONY: db-dump
db-dump: ## Create database structure
	cat docker/database/enhancedsteam.sql | docker exec -i augmented.database mysql -uroot -ppassword enhancedsteam

