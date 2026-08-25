SHELL := /bin/bash

LIB_SOURCES := $(shell find lib -name '*.sh')
EXAMPLE_SOURCES := $(wildcard examples/*.sh)

.PHONY: lint fmt test

lint:
	@echo "Running shellcheck..."
	shellcheck $(LIB_SOURCES) $(EXAMPLE_SOURCES)

fmt:
	@echo "Formatting with shfmt..."
	shfmt -w -i 2 -ci -bn $(LIB_SOURCES) tests/*.bats

test:
	@echo "Running bats tests..."
	bats tests
