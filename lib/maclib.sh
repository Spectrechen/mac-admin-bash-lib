#!/usr/bin/env bash
# maclib.sh - entrypoint to source all modules

# shellcheck source=lib/log.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"
# shellcheck source=lib/os.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/os.sh"
