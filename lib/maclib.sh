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
# shellcheck source=lib/security.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/security.sh"
# shellcheck source=lib/management.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/management.sh"
# shellcheck source=lib/network.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/network.sh"
# shellcheck source=lib/app.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/app.sh"
# shellcheck source=lib/office.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/office.sh"
# shellcheck source=lib/chrome.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/chrome.sh"
# shellcheck source=lib/firefox.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/firefox.sh"
# shellcheck source=lib/zoom.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/zoom.sh"
# shellcheck source=lib/1password.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/1password.sh"
# shellcheck source=lib/slack.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/slack.sh"
# shellcheck source=lib/dropbox.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dropbox.sh"
# shellcheck source=lib/notion.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/notion.sh"
# shellcheck source=lib/vlc.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/vlc.sh"
# shellcheck source=lib/signal.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/signal.sh"
# shellcheck source=lib/libreoffice.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/libreoffice.sh"
# shellcheck source=lib/iterm2.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/iterm2.sh"
# shellcheck source=lib/figma.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/figma.sh"
# shellcheck source=lib/chatgpt.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/chatgpt.sh"
# shellcheck source=lib/jamf.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/jamf.sh"
