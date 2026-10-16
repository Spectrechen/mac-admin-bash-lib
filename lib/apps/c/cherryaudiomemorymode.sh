#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiomemorymode.sh - "Memory Mode" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiomemorymode
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (Cherry Audio — verify against vendor).
# Installer type: "dmg".
# Installer URL: https://store.cherryaudio.com/software/memory-mode-macos-installer
# Update: Cherry Audio provides updates via their Sync app or in-app updates.
# Uninstall: no clean uninstall (documented constraint).
#
# Notes: Memory Mode is a Cherry Audio virtual instrument emulating the Memorymoog.
#   Downloads require a Cherry Audio account and product license.
#
# Sources:
#   https://cherryaudio.com/products/memorymode
#   https://cherryaudio.com/products/downloads

maclib::apps::c::cherryaudiomemorymode::suite_installer_url() {
  printf '%s\n' "https://store.cherryaudio.com/software/memory-mode-macos-installer"
}

maclib::apps::c::cherryaudiomemorymode::latest_version() {
  # No public version API; latest version tracked on store.cherryaudio.com.
  printf '%s\n' "1.0"
}

maclib::apps::c::cherryaudiomemorymode::is_installed() {
  [[ -d "/Applications/Memory Mode.app" ]] || [[ -d "$HOME/Applications/Memory Mode.app" ]]
}

maclib::apps::c::cherryaudiomemorymode::installed_path() {
  if [[ -d "/Applications/Memory Mode.app" ]]; then
    printf '%s\n' "/Applications/Memory Mode.app"
  elif [[ -d "$HOME/Applications/Memory Mode.app" ]]; then
    printf '%s\n' "$HOME/Applications/Memory Mode.app"
  else
    return 1
  fi
}

maclib::apps::c::cherryaudiomemorymode::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiomemorymode::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiomemorymode.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  # Cherry Audio requires purchase/license; download may require authentication.
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiomemorymode::install: download failed (may require license)"
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

maclib::apps::c::cherryaudiomemorymode::update() {
  # Cherry Audio updates via Sync app or in-app updates.
  # install() can be re-run for manual update.
  maclib::apps::c::cherryaudiomemorymode::install
}

maclib::apps::c::cherryaudiomemorymode::uninstall() {
  maclib::core::log::warn "cherryaudiomemorymode::uninstall: no clean uninstall"
  return 1
}
