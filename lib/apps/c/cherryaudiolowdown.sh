#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiolowdown.sh - "Lowdown" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiolowdown
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (Cherry Audio — verify against vendor).
# Installer type: "dmg".
# Installer URL: https://store.cherryaudio.com/software/lowdown-macos-installer
# Update: Cherry Audio provides updates via their Sync app or in-app updates.
# Uninstall: no clean uninstall (documented constraint).
#
# Sources:
#   https://cherryaudio.com/products/lowdown
#   https://store.cherryaudio.com/software/lowdown-macos-installer
#   https://cherryaudio.com/products/downloads

maclib::apps::c::cherryaudiolowdown::suite_installer_url() {
  printf '%s\n' "https://store.cherryaudio.com/software/lowdown-macos-installer"
}

maclib::apps::c::cherryaudiolowdown::latest_version() {
  # No public version API; latest version tracked on store.cherryaudio.com.
  printf '%s\n' "1.0"
}

maclib::apps::c::cherryaudiolowdown::is_installed() {
  [[ -d "/Applications/Lowdown.app" ]] || [[ -d "$HOME/Applications/Lowdown.app" ]]
}

maclib::apps::c::cherryaudiolowdown::installed_path() {
  if [[ -d "/Applications/Lowdown.app" ]]; then
    printf '%s\n' "/Applications/Lowdown.app"
  elif [[ -d "$HOME/Applications/Lowdown.app" ]]; then
    printf '%s\n' "$HOME/Applications/Lowdown.app"
  else
    return 1
  fi
}

maclib::apps::c::cherryaudiolowdown::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiolowdown::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiolowdown.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  # Cherry Audio requires purchase/license; download may require authentication.
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiolowdown::install: download failed (may require license)"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::apps::c::cherryaudiolowdown::update() {
  # Cherry Audio updates via Sync app or in-app updates.
  # install() can be re-run for manual update.
  maclib::apps::c::cherryaudiolowdown::install
}

maclib::apps::c::cherryaudiolowdown::uninstall() {
  maclib::core::log::warn "cherryaudiolowdown::uninstall: no clean uninstall"
  return 1
}
