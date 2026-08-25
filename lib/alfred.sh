#!/usr/bin/env bash
# shellcheck disable=all
# alfred.sh - "Alfred" (Installomator label) helpers
#
# Vendor source: Installomator label alfred
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/alfred-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::alfred::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/alfred-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/alfred-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::alfred::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/alfred-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::alfred::is_installed() {
  [[ -d "/Applications/alfred.app" ]] || [[ -d "$HOME/Applications/alfred.app" ]]
}

maclib::alfred::installed_path() {
  if [[ -d "/Applications/alfred.app" ]]; then
    printf '%s\n' "/Applications/alfred.app"
  elif [[ -d "$HOME/Applications/alfred.app" ]]; then
    printf '%s\n' "$HOME/Applications/alfred.app"
  else
    return 1
  fi
}

maclib::alfred::install() {
  # No automated installer documented for "Alfred" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "alfred::install: no automated installer; deploy manually"
  return 1
}

maclib::alfred::update() {
  maclib::log::error "alfred::update: no update path"
  return 127
}

maclib::alfred::uninstall() {
  maclib::log::warn "alfred::uninstall: no clean uninstall"
  return 1
}
