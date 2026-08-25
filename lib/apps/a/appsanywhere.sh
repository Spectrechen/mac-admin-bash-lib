#!/usr/bin/env bash
# shellcheck disable=all
# appsanywhere.sh - "AppsAnywhere Client (macOS)" (Installomator label) helpers
#
# Vendor source: Installomator label appsanywhere
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkg".
# Installer URL: https://example.com/appsanywhere-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::appsanywhere::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/appsanywhere-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/appsanywhere-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::appsanywhere::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/appsanywhere-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::appsanywhere::is_installed() {
  [[ -d "/Applications/appsanywhere.app" ]] || [[ -d "$HOME/Applications/appsanywhere.app" ]]
}

maclib::appsanywhere::installed_path() {
  if [[ -d "/Applications/appsanywhere.app" ]]; then
    printf '%s\n' "/Applications/appsanywhere.app"
  elif [[ -d "$HOME/Applications/appsanywhere.app" ]]; then
    printf '%s\n' "$HOME/Applications/appsanywhere.app"
  else
    return 1
  fi
}

maclib::appsanywhere::install() {
  # No automated installer documented for "AppsAnywhere Client (macOS)" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "appsanywhere::install: no automated installer; deploy manually"
  return 1
}

maclib::appsanywhere::update() {
  maclib::log::error "appsanywhere::update: no update path"
  return 127
}

maclib::appsanywhere::uninstall() {
  maclib::log::warn "appsanywhere::uninstall: no clean uninstall"
  return 1
}
