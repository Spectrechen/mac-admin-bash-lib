# Agent Guidelines (AGENTS.md)

This repository is a **Bash** library for macOS administrators.

## Core rules
- Target shell: **bash** (macOS admin scripting).
- Prefer **small, reviewable commits**.
- Keep functions **pure where possible** (explicit inputs/outputs).
- No copying code from external repos unless license/attribution is verified.

## Safety & correctness
- Default to `set -euo pipefail` in entry scripts; libraries should be safe under it.
- Never use `eval`.
- Quote variables (`"$var"`), avoid word-splitting/globbing bugs.
- Use `mktemp` for temp files/dirs; always clean up.
- Prefer minimal external dependencies; document any required tools.

## Style
- Namespace all public functions as `maclib::...`.
- Run and keep CI green:
  - `shellcheck` clean
  - `shfmt` formatted
  - `bats` tests passing

## Testing
- Add tests for new functions under `tests/` (bats-core).
- If behavior depends on macOS commands, isolate via wrappers and mock in tests.
