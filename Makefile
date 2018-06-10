MAKEF_PATH = $(shell pwd)

SHELL := /bin/bash
MAKEFLAGS := --silent
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

MERMAID_DIST_SRC_URL = https://unpkg.com/mermaid/dist
MERMAID_DIST_DEST_PATH = ./static/mermaid
MERMAID_DIST_UPDATE_LOG = $(MERMAID_DIST_DEST_PATH)/mermaid-dist-update.log
JKANBAN_DIST_SRC_URL = https://github.com/riktar/jkanban/raw/master/dist
JKANBAN_DIST_DEST_PATH = ./static/jkanban
JKANBAN_DIST_UPDATE_LOG = $(JKANBAN_DIST_DEST_PATH)/jkanban-dist-update.log

.ONESHELL:
## Get the latest distribution of MermaidJS from $(MERMAID_DIST_SRC_URL)
update-mermaidjs:
	rm -rf $(MERMAID_DIST_DEST_PATH)
	mkdir -p $(MERMAID_DIST_DEST_PATH)
	echo "MermaidJS update from $(MERMAID_DIST_SRC_URL) on `date`" > $(MERMAID_DIST_UPDATE_LOG)
	wget $(MERMAID_DIST_SRC_URL)/mermaid.css -O $(MERMAID_DIST_DEST_PATH)/mermaid.css &>> $(MERMAID_DIST_UPDATE_LOG)
	wget $(MERMAID_DIST_SRC_URL)/mermaid.dark.css -O $(MERMAID_DIST_DEST_PATH)/mermaid.dark.css &>> $(MERMAID_DIST_UPDATE_LOG)
	wget $(MERMAID_DIST_SRC_URL)/mermaid.forest.css -O $(MERMAID_DIST_DEST_PATH)/mermaid.forest.css &>> $(MERMAID_DIST_UPDATE_LOG)
	wget $(MERMAID_DIST_SRC_URL)/mermaid.js -O $(MERMAID_DIST_DEST_PATH)/mermaid.js &>> $(MERMAID_DIST_UPDATE_LOG)
	wget $(MERMAID_DIST_SRC_URL)/mermaid.min.js -O $(MERMAID_DIST_DEST_PATH)/mermaid.min.js &>> $(MERMAID_DIST_UPDATE_LOG)
	echo "Check ${GREEN}$(MERMAID_DIST_UPDATE_LOG)${RESET}."

## Get the latest distribution of jKanban from $(JKANBAN_DIST_SRC_URL)
update-jkanban:
	rm -rf $(JKANBAN_DIST_DEST_PATH)
	mkdir -p $(JKANBAN_DIST_DEST_PATH)
	echo "jKanban update from $(JKANBAN_DIST_SRC_URL) on `date`" > $(JKANBAN_DIST_UPDATE_LOG)
	wget $(JKANBAN_DIST_SRC_URL)/jkanban.js -O $(JKANBAN_DIST_DEST_PATH)/jkanban.js &>> $(JKANBAN_DIST_UPDATE_LOG)
	wget $(JKANBAN_DIST_SRC_URL)/jkanban.css -O $(JKANBAN_DIST_DEST_PATH)/jkanban.css &>> $(JKANBAN_DIST_UPDATE_LOG)
	echo "Check ${GREEN}$(JKANBAN_DIST_UPDATE_LOG)${RESET}."

## Update MermaidJS and jKanban from source distributions
update-dependencies: update-mermaidjs update-jkanban
	git status

TARGET_MAX_CHAR_NUM=20
## All targets should have a ## Help text above the target and they'll be automatically collected
## Show help, using auto generator from https://gist.github.com/prwhite/8168133
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''
	@echo 'Directives:'
	@echo "  ${YELLOW}TMP_PATH${RESET}               '${GREEN}$(TMP_PATH)${RESET}'"
	@echo "  ${YELLOW}MERMAID_DIST_SRC_URL${RESET}   '${GREEN}$(MERMAID_DIST_SRC_URL)${RESET}'"
	@echo "  ${YELLOW}MERMAID_DIST_DEST_PATH${RESET} '${GREEN}$(MERMAID_DIST_DEST_PATH)${RESET}'"
	@echo "  ${YELLOW}JKANBAN_DIST_SRC_URL${RESET}   '${GREEN}$(JKANBAN_DIST_SRC_URL)${RESET}'"
	@echo "  ${YELLOW}JKANBAN_DIST_DEST_PATH${RESET} '${GREEN}$(JKANBAN_DIST_DEST_PATH)${RESET}'"

.PHONY: update-mermaidjs help
