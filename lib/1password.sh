#!/usr/bin/env bash
# 1password.sh - 1Password 8 (package installer) helpers
#
# Vendor research (see docs/1password-vendor-notes.md):
#   1Password ships a signed .pkg installer from https://downloads.1password.com.
#   IT deployment installs the package into /Applications (bundle ID
#   com.1password.1password, group ID / team ID 2BUA8C4S2C).
#   The current build is read from 1Password's releases XML feed.
#   Apple Developer Team ID: 2BUA8C4S2C.
#   Source: Installomator `1password8` label + 1Password deploy docs.

# Print the 1Password package installer URL.
maclib::1password::url() {
  printf '%s\n' 'https://downloads.1password.com/mac/1Password.pkg'
}

# Print the current 1Password build version (e.g. 8.x.y).
# Reads the version from 1Password's releases XML feed.
maclib::1password::latest_version() {
  local xml version
  xml="$(curl -fs 'https://releases.1password.com/mac/stable/index.xml' 2>/dev/null)"
  [[ -n "$xml" ]] || return 1
  version="$(printf '%s' "$xml" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the 1Password app bundle is installed.
maclib::1password::is_installed() {
  [[ -d "/Applications/1Password.app" ]] || [[ -d "$HOME/Applications/1Password.app" ]]
}

# Print the path to the 1Password app bundle if present.
maclib::1password::installed_path() {
  if [[ -d "/Applications/1Password.app" ]]; then
    printf '%s\n' "/Applications/1Password.app"
  elif [[ -d "$HOME/Applications/1Password.app" ]]; then
    printf '%s\n' "$HOME/Applications/1Password.app"
  fi
}

# Download the 1Password package installer and install it (requires root).
maclib::1password::install() {
  local url tmp
  url="$(maclib::1password::url)"
  tmp="$(mktemp -t "1password_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "1password::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# 1Password updates are applied by re-installing the latest package (see
# install()). Documented as no separate update path.
