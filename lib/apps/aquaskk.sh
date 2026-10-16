#!/usr/bin/env bash
# aquaskk.sh - AquaSKK Japanese input method helpers
#
# Vendor research:
#   AquaSKK is a Japanese input method (SKK-compatible) without morphological
#   analysis. Open source on GitHub.
#   Source: https://github.com/codefirst/aquaskk
#   - Latest version: 4.7.6 (as of 2025)
#   - Download URL from GitHub Releases:
#       https://github.com/codefirst/aquaskk/releases/latest/download/aquaskk.pkg
#   - Package ID: org.codefirst.aquaskk.pkg
#   - Team ID: FPZK4WRGW7
#   - Installs as a .pkg (not DMG).
#   - App location: /Applications/AquaSKK.app
#   - Input method: Library/Input Methods/AquaSKK.inputmethod
#   - Uninstall: pkgutil --files + rm, then pkgutil --forget.

# Print the GitHub Releases URL for the latest AquaSKK installer.
maclib::apps::aquaskk::suite_installer_url() {
  printf '%s\n' 'https://github.com/codefirst/aquaskk/releases/latest/download/aquaskk.pkg'
}

# Print the latest version by checking GitHub Releases.
maclib::apps::aquaskk::latest_version() {
  local ver
  ver=$(curl -fsSL 'https://api.github.com/repos/codefirst/aquaskk/releases/latest' 2>/dev/null | \
    grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/' | head -1)
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  # Fallback: known latest
  printf '%s\n' '4.7.6'
  return 0
}

# Return 0 if AquaSKK is installed.
maclib::apps::aquaskk::is_installed() {
  /usr/sbin/pkgutil --pkg-info org.codefirst.aquaskk.pkg >/dev/null 2>&1
  return $?
}

# Print the installed app path if present.
maclib::apps::aquaskk::installed_path() {
  if [[ -d '/Applications/AquaSKK.app' ]]; then
    printf '%s\n' '/Applications/AquaSKK.app'
    return 0
  fi
  return 1
}

# Download and install AquaSKK from the GitHub Release pkg.
# Requires root (installer writes to /Applications and system locations).
maclib::apps::aquaskk::install() {
  local url pkg_path
  url="$(maclib::apps::aquaskk::suite_installer_url)"

  local tmp
  tmp="$(mktemp -t aquaskk_install.XXXXXX.pkg)" || return 1
  trap 'rm -f "$tmp"' RETURN

  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "aquaskk::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi

  /usr/sbin/installer -pkg "$tmp" -target / 2>/dev/null
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Update: same as install (reinstalls latest from GitHub).
maclib::apps::aquaskk::update() {
  maclib::apps::aquaskk::install "$@"
}

# Uninstall: remove AquaSKK package files.
# Credit: https://scrapbox.io/upamune/AquaSKKをアンインストールする
maclib::apps::aquaskk::uninstall() {
  local files
  files=$(/usr/sbin/pkgutil --files org.codefirst.aquaskk.pkg 2>/dev/null)
  if [[ -n "$files" ]]; then
    echo "$files" | while IFS= read -r f; do
      case "$f" in
        Library/Input\ Methods/AquaSKK.inputmethod)
          rm -f "/$f"
          ;;
        Applications/AquaSKK.app)
          rm -rf "${f:?}"
          ;;
        *)
          [[ -e "${f:?}" ]] && rm -rf "${f:?}"
          ;;
      esac
    done
  fi
  /usr/sbin/pkgutil --forget org.codefirst.aquaskk.pkg 2>/dev/null
}
