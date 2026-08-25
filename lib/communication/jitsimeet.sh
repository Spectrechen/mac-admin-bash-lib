#!/usr/bin/env bash
# shellcheck disable=all
# jitsimeet.sh - Jitsi Meet (disk image) helpers
#
# Vendor source: Installomator label jitsimeet (github.com/Installomator/Installomator, Installomator.sh).
#   Jitsi Meet ships a signed .dmg from its GitHub releases
#   (github.com/Jitsi/jitsi-meet-electron). The current build is parsed from
#   the latest-release download URL / version.
#   Apple Developer Team ID: FC967L3QRG.

# Print the Jitsi Meet installer disk-image URL (from the latest GitHub release).
maclib::jitsimeet::suite_installer_url() {
  local url
  url="$(curl -fsL 'https://api.github.com/repos/Jitsi/jitsi-meet-electron/releases/latest' 2>/dev/null \
    | grep -oE 'https[^"]*-jitsi-meet-electron-darwin[^"]*\.dmg' | head -n1)"
  [[ -n "$url" ]] || return 1
  printf '%s\n' "$url"
}

# Print the current Jitsi Meet build version (from the latest GitHub release).
maclib::jitsimeet::latest_version() {
  local version
  version="$(curl -fsL 'https://api.github.com/repos/Jitsi/jitsi-meet-electron/releases/latest' 2>/dev/null \
    | grep -oE '/tags/v?[0-9]+\.[0-9]+\.[0-9]+' | head -n1 \
    | sed -E 's#.*/tags/v?##')"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Jitsi Meet app bundle is installed.
maclib::jitsimeet::is_installed() {
  [[ -d "/Applications/Jitsi Meet.app" ]] || [[ -d "$HOME/Applications/Jitsi Meet.app" ]]
}

# Print the path to the Jitsi Meet app bundle if present.
maclib::jitsimeet::installed_path() {
  if [[ -d "/Applications/Jitsi Meet.app" ]]; then
    printf '%s\n' "/Applications/Jitsi Meet.app"
  elif [[ -d "$HOME/Applications/Jitsi Meet.app" ]]; then
    printf '%s\n' "$HOME/Applications/Jitsi Meet.app"
  else
    return 1
  fi
}

# Download the Jitsi Meet disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::jitsimeet::install() {
  local url dmg mount
  url="$(maclib::jitsimeet::suite_installer_url)"
  dmg="$(mktemp -t "jitsimeet_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/jitsimeet_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "jitsimeet::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "jitsimeet::install: failed to mount disk image"
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
  maclib::log::error "jitsimeet::install: no .app found in disk image"
  return 1
}

# Jitsi Meet updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::jitsimeet::update() {
  maclib::jitsimeet::install "$@"
}

# No clean uninstall (documented constraint).
maclib::jitsimeet::uninstall() {
  maclib::log::warn "jitsimeet::uninstall: no clean uninstall"
  return 1
}
