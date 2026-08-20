# mac-admin-bash-lib

A Bash helper library for macOS administrators.

## Goals
- Provide a reusable set of functions commonly reimplemented in admin scripts
- Strong conventions (namespacing, logging, safety)
- CI-backed quality (shellcheck, shfmt, tests)

## Quick start
```bash
# Source the library entrypoint
source ./lib/maclib.sh

maclib::log::info "Hello from maclib"
```

## Development
Prerequisites:
- shellcheck
- shfmt
- bats-core

Commands:
```bash
make lint
make fmt
make test
```

## Status
Initial skeleton created: 2026-02-28
