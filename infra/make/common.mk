.ONESHELL:
SHELL := /usr/bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
INFO_COLOR := \033[36;1m
ERROR_COLOR := \033[32;1m
WARNING_COLOR := \033[33;1m
RESET_COLOR := \033[m

tf.init: ## --dry-run terraform init
	echo "terraform init"

help: ## shows this help
	@echo -e "\n$(INFO_COLOR)==============MENU======================$(RESTEt8color)"
	@echo -e "\n$(INFO_COLOR)====================le cours si c'est high mon frere===============$(WARNING_COLOR)"
	@grep -hE '^[a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort