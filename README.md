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

## License
Licensed under the [Apache License, Version 2.0](LICENSE).

Many application modules in `lib/` are derived from
[Installomator](https://github.com/Installomator/Installomator) labels
(© 2020 Armin Briegel, Scripting OS X, and the Installomator contributors,
Apache 2.0). Each such file names its Installomator label in its header;
see [NOTICE](NOTICE) for the attribution.
