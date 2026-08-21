# Conventions

## Shell
- Bash-only (macOS admin focus).
- Library code must be safe under `set -euo pipefail`.

## Naming
- Public functions: `maclib::<module>::<name>`
- Internal helpers: `_maclib::<module>::<name>` or `__maclib_*` (pick one and stay consistent)

## Output & errors
- `stdout`: data output
- `stderr`: logs and errors

## Security
- No `eval`
- Always quote
- Use `mktemp` and cleanup
- Validate inputs (paths, URLs) where relevant
