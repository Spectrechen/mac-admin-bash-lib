#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiomercury4.sh - "Mercury-4" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiomercury4
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (Cherry Audio — verify against vendor).
# Installer type: "dmg".
# Installer URL: https://store.cherryaudio.com/software/mercury-4-macos-installer
# Update: Cherry Audio provides updates via their Sync app or in-app updates.
# Uninstall: no clean uninstall (documented constraint).
#
# Notes: Mercury-4 is a detailed emulation of the Roland Jupiter-4 polyphonic
#   synthesizer. Available for Windows and macOS (native Apple M1 support).
#   Distributed as AU, VST, VST3, and AAX plugins plus standalone application.
#
# Sources:
#   https://cherryaudio.com/products/mercury-4/download
#   https://store.cherryaudio.com/software/mercury-4-macos-installer
#   https://cherryaudio.com/products/downloads

maclib::apps::c::cherryaudiomercury4::suite_installer_url() {
  printf '%s\n' "https://store.cherryaudio.com/software/mercury-4-macos-installer"
}

maclib::apps::c::cherryaudiomercury4::latest_version() {
  # No public version API; latest version tracked on store.cherryaudio.com.
  printf '%s\n' "1.0"
}

maclib::apps::c::cherryaudiomercury4::is_installed() {
  [[ -d "/Applications/Mercury-4.app" ]] || [[ -d "$HOME/Applications/Mercury-4.app" ]]
}

maclib::apps::c::cherryaudiomercury4::installed_path() {
  if [[ -d "/Applications/Mercury-4.app" ]]; then
    printf '%s\n' "/Applications/Mercury-4.app"
  elif [[ -d "$HOME/Applications/Mercury-4.app" ]]; then
    printf '%s\n' "$HOME/Applications/Mercury-4.app"
  else
    return 1
  fi
}

maclib::apps::c::cherryaudiomercury4::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiomercury4::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiomercury4.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  # Cherry Audio requires purchase/license; download may require authentication.
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiomercury4::install: download failed (may require license)"
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

maclib::apps::c::cherryaudiomercury4::update() {
  # Cherry Audio updates via Sync app or in-app updates.
  # install() can be re-run for manual update.
  maclib::apps::c::cherryaudiomercury4::install
}

maclib::apps::c::cherryaudiomercury4::uninstall() {
  maclib::core::log::warn "cherryaudiomercury4::uninstall: no clean uninstall"
  return 1
}
