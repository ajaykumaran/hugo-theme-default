MAKEF_PATH = $(shell pwd)

SHELL := /bin/bash
MAKEFLAGS := --silent
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

TMP_PATH := /tmp/$(shell date +"%Y-%m-%d-%H-%H-%S")
MERMAID_DIST_VERSION = 7.0.0
MERMAID_DIST_SRC_URL = https://github.com/knsv/mermaid/archive/$(MERMAID_DIST_VERSION).tar.gz
MERMAID_DIST_DEST_PATH = ./static/mermaid
JKANBAN_DIST_SRC_URL = https://github.com/riktar/jkanban/raw/master/dist
JKANBAN_DIST_DEST_PATH = ./static/jkanban

# Private target for preparing work area
prepare-work-area: 
	mkdir -p $(TMP_PATH)

.ONESHELL:
## Get the latest distribution of MermaidJS from $(MERMAID_DIST_SRC_URL)
update-mermaidjs: prepare-work-area
	wget -q $(MERMAID_DIST_SRC_URL) -O $(TMP_PATH)/mermaid-dist-$(MERMAID_DIST_VERSION).tar.gz
	cd $(TMP_PATH)
	tar -xzf $(TMP_PATH)/mermaid-dist-$(MERMAID_DIST_VERSION).tar.gz
	echo "Download $(MERMAID_DIST_SRC_URL) into $(TMP_PATH)/mermaid-$(MERMAID_DIST_VERSION)"
	cd $(MAKEF_PATH)
	rm -rf $(MERMAID_DIST_DEST_PATH)
	mkdir -p $(MERMAID_DIST_DEST_PATH)
	cp $(TMP_PATH)/mermaid-$(MERMAID_DIST_VERSION)/dist/mermaid.css $(MERMAID_DIST_DEST_PATH)
	cp $(TMP_PATH)/mermaid-$(MERMAID_DIST_VERSION)/dist/mermaid.dark.css $(MERMAID_DIST_DEST_PATH)
	cp $(TMP_PATH)/mermaid-$(MERMAID_DIST_VERSION)/dist/mermaid.forest.css $(MERMAID_DIST_DEST_PATH)
	cp $(TMP_PATH)/mermaid-$(MERMAID_DIST_VERSION)/dist/mermaid.js $(MERMAID_DIST_DEST_PATH)
	cp $(TMP_PATH)/mermaid-$(MERMAID_DIST_VERSION)/dist/mermaid.min.js $(MERMAID_DIST_DEST_PATH)

## Get the latest distribution of jKanban from $(JKANBAN_DIST_SRC_URL)
update-jkanban:
	rm -rf $(JKANBAN_DIST_DEST_PATH)
	mkdir -p $(JKANBAN_DIST_DEST_PATH)
	wget -q $(JKANBAN_DIST_SRC_URL)/jkanban.js -O $(JKANBAN_DIST_DEST_PATH)/jkanban.js
	wget -q $(JKANBAN_DIST_SRC_URL)/jkanban.css -O $(JKANBAN_DIST_DEST_PATH)/jkanban.css

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
	@echo "  ${YELLOW}MERMAID_DIST_VERSION${RESET}   '${GREEN}$(MERMAID_DIST_VERSION)${RESET}'"
	@echo "  ${YELLOW}MERMAID_DIST_SRC_URL${RESET}   '${GREEN}$(MERMAID_DIST_SRC_URL)${RESET}'"
	@echo "  ${YELLOW}MERMAID_DIST_DEST_PATH${RESET} '${GREEN}$(MERMAID_DIST_DEST_PATH)${RESET}'"
	@echo "  ${YELLOW}JKANBAN_DIST_SRC_URL${RESET}   '${GREEN}$(JKANBAN_DIST_SRC_URL)${RESET}'"
	@echo "  ${YELLOW}JKANBAN_DIST_DEST_PATH${RESET} '${GREEN}$(JKANBAN_DIST_DEST_PATH)${RESET}'"

.PHONY: update-mermaidjs help
