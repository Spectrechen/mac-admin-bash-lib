#!/usr/bin/env bash
# shellcheck disable=all
# soundly.sh - Soundly (disk image) helpers
#
# Vendor source: Installomator label `soundly`
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Soundly ships signed .dmg installers from Google Cloud Storage, with a
#   build per architecture:
#     x86_64: https://storage.googleapis.com/soundlyapp/Soundly.dmg
#     arm64:  https://storage.googleapis.com/soundlyapp/arm/Soundly.dmg
#   Apple Developer Team ID: 67Y6N7VTDG.
#   Installer type: dmg.

# Print the Soundly installer disk-image URL (selected by arch).
maclib::communication::soundly::suite_installer_url() {
  if [[ "$(uname -m)" == "i386" ]]; then
    printf '%s\n' 'https://storage.googleapis.com/soundlyapp/Soundly.dmg'
  else
    printf '%s\n' 'https://storage.googleapis.com/soundlyapp/arm/Soundly.dmg'
  fi
}

# Soundly has no vendor version endpoint (the dmg URL carries no build number).
# Returns non-zero; documented as no update path.
maclib::communication::soundly::latest_version() {
  maclib::core::log::warn "soundly::latest_version: no vendor version source"
  return 1
}

# Return 0 if the Soundly app bundle is installed.
maclib::communication::soundly::is_installed() {
  [[ -d "/Applications/Soundly.app" ]] || [[ -d "$HOME/Applications/Soundly.app" ]]
}

# Print the path to the Soundly app bundle if present.
maclib::communication::soundly::installed_path() {
  if [[ -d "/Applications/Soundly.app" ]]; then
    printf '%s\n' "/Applications/Soundly.app"
  elif [[ -d "$HOME/Applications/Soundly.app" ]]; then
    printf '%s\n' "$HOME/Applications/Soundly.app"
  else
    return 1
  fi
}

# Download the Soundly disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::communication::soundly::install() {
  local url dmg mount
  url="$(maclib::communication::soundly::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  dmg="$(mktemp -t "soundly_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/soundly_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::core::log::error "soundly::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::core::log::error "soundly::install: failed to mount disk image"
    return 1
  fi
  local app
  app="$(find "$mount" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$mount" >/dev/null 2>&1
    return "$rc"
  fi
  hdiutil detach "$mount" >/dev/null 2>&1
  maclib::core::log::error "soundly::install: no .app found in disk image"
  return 1
}

# Soundly has no vendor version endpoint; updates are applied by re-installing
# the latest disk image (see install()). Documented as no separate update path.
maclib::communication::soundly::update() {
  maclib::communication::soundly::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::soundly::uninstall() {
  maclib::core::log::warn "soundly::uninstall: no clean uninstall"
  return 1
}
