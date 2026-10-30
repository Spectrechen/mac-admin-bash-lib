SHELL := /bin/bash
SH_FILES := $(shell find lib scripts -name '*.sh' 2>/dev/null)

.PHONY: check lint fmt test doctor

check: lint test

lint:
	@if [ -n "$(SH_FILES)" ]; then shellcheck -s bash $(SH_FILES) && shfmt -d -i 0 $(SH_FILES); fi

fmt:
	@if [ -n "$(SH_FILES)" ]; then shfmt -w -i 0 $(SH_FILES); fi

test:
	@bats tests/

doctor:
	@if [ -x scripts/doctor.sh ]; then scripts/doctor.sh; else echo 'no local doctor script'; fi
