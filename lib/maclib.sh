#!/usr/bin/env bash
# maclib.sh - entrypoint to source all modules

# shellcheck source=lib/log.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"
# shellcheck source=lib/os.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/os.sh"
# shellcheck source=lib/user.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/user.sh"
# shellcheck source=lib/system.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/system.sh"
# shellcheck source=lib/packages.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/packages.sh"
# shellcheck source=lib/signing.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/signing.sh"
# shellcheck source=lib/keychain.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/keychain.sh"
# shellcheck source=lib/launchd.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/launchd.sh"
# shellcheck source=lib/filevault.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/filevault.sh"
# shellcheck source=lib/management.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/management.sh"
# shellcheck source=lib/network.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/network.sh"
# shellcheck source=lib/app.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/app.sh"
