#!/usr/bin/env bash
# shellcheck disable=all
# anydesk.sh - AnyDesk (disk image) helpers
#
# Vendor source: Installomator label anydesk (github.com/Installomator/Installomator, Installomator.sh).
#   AnyDesk ships a signed .dmg from https://download.anydesk.com/anydesk.dmg.
#   The current build is parsed from https://download.anydesk.com/changelog.txt.
#   Apple Developer Team ID: KHRWM533LU.

# Print the AnyDesk installer disk-image URL.
maclib::anydesk::suite_installer_url() {
  printf '%s\n' 'https://download.anydesk.com/anydesk.dmg'
}

# Print the current AnyDesk build version.
# Installomator reads the first "(macOS)" entry from anydesk's changelog.txt.
maclib::anydesk::latest_version() {
  local version
  version="$(curl -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15' -fs 'https://download.anydesk.com/changelog.txt' 2>/dev/null \
    | grep -m1 '(macOS)' | sed -E 's/.*- ([0-9.]+) \(macOS\).*/\1/' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the AnyDesk app bundle is installed.
maclib::anydesk::is_installed() {
  [[ -d "/Applications/AnyDesk.app" ]] || [[ -d "$HOME/Applications/AnyDesk.app" ]]
}

# Print the path to the AnyDesk app bundle if present.
maclib::anydesk::installed_path() {
  if [[ -d "/Applications/AnyDesk.app" ]]; then
    printf '%s\n' "/Applications/AnyDesk.app"
  elif [[ -d "$HOME/Applications/AnyDesk.app" ]]; then
    printf '%s\n' "$HOME/Applications/AnyDesk.app"
  else
    return 1
  fi
}

# Download the AnyDesk disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::anydesk::install() {
  local url dmg mount
  url="$(maclib::anydesk::suite_installer_url)"
  dmg="$(mktemp -t "anydesk_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/anydesk_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "anydesk::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "anydesk::install: failed to mount disk image"
    return 1
  fi
  local app
  app="$(find "$mount" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$mount" >/dev/null 2>&1
    return "$rc"
  fi
  hdiutil detach "$mount" >/dev/null 2>&1
  maclib::log::error "anydesk::install: no .app found in disk image"
  return 1
}

# AnyDesk updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::anydesk::update() {
  maclib::anydesk::install "$@"
}

# No clean uninstall (documented constraint).
maclib::anydesk::uninstall() {
  maclib::log::warn "anydesk::uninstall: no clean uninstall"
  return 1
}
