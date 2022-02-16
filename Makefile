SHELL := $(shell which bash)
.SHELLFLAGS := -euco pipefail

VERSION := $(shell cat package.json | jq --raw-output '.version')
NAME := tw5-n3js
AUTHOR := langston-barrett

NPM := npm
NPX := npx
WEBPACK := webpack

SRC := src
DIST := dist
META := $(DIST)/meta.tid
PLUGIN_FILES := \
  README.tid \
  LICENSE.tid \
  $(META) \
  $(SRC)/plugin/LICENSE-n3js.tid \
  $(SRC)/plugin/n3test.js \
  $(SRC)/plugin/plugin.info
EDITION_SRCS := $(shell find $(SRC)/editions -type f)
NODE_MODULES := node_modules
HEADER := $(SRC)/plugin/header.inc
DISTN3 := $(DIST)/n3.js
PLUGIN_DIR := $(DIST)/plugins
THIS_PLUGIN_DIR := $(PLUGIN_DIR)/$(AUTHOR)/N3.js
PLUGN3 := $(THIS_PLUGIN_DIR)/n3.js
OUT := $(DIST)/$(NAME)-$(VERSION).html
DIST_ARCHIVE := $(DIST)/$(NAME)-$(VERSION).tar.gz

$(NODE_MODULES): package.json package-lock.json
	$(NPM) install

$(DISTN3): $(SRCS) $(NODE_MODULES) webpack.config.js
	$(NPX) webpack

$(PLUGIN_DIR):
	mkdir -p "$@"

$(THIS_PLUGIN_DIR): $(PLUGIN_DIR)
	mkdir -p "$@"

$(PLUGN3): $(DISTN3) $(HEADER) $(THIS_PLUGIN_DIR)
	cat $(HEADER) $(DISTN3) > "$@"

$(OUT): $(PLUGN3) $(PLUGIN_FILES) $(EDITION_SRCS)
	cp $(PLUGIN_FILES) $(THIS_PLUGIN_DIR)
	cd $(SRC)/editions/N3.js/; env TIDDLYWIKI_PLUGIN_PATH=$(PWD)/$(PLUGIN_DIR) npx tiddlywiki --build
	mv $(DIST)/dist.html "$@"

$(META): $(OUT)
	printf \
      "created: 20000000000000000\nmodified: 20000000000000000\ntitle: $$:/plugins/langston-barrett/N3.js/meta\n\n<pre>npm: %s\n%s\nn3js: %s\ntw5: %s</pre>" \
	  "$(shell npm --version)" \
	  "$(shell npx webpack --version)" \
	  "$(shell cd N3.js; git rev-parse HEAD)" \
	  "$(shell npx tiddlywiki --version)" \
	  > "$@"

$(DIST_ARCHIVE): $(OUT) $(META) $(README)
	tar cvf "$@" $(OUT) $(META) $(README)

.PHONY: build
build: $(OUT)

.PHONY: dist
dist: $(DIST_ARCHIVE)

.DEFAULT: all
.PHONY: all
all: build dist

.PHONY: clean
clean:
	rm -rf $(DIST)

.PHONY: distclean
distclean: clean
	rm -rf $(NODE_MODULES)
