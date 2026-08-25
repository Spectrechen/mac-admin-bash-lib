#!/usr/bin/env bash
# shellcheck disable=all
# archimate.sh - "Archi" (Installomator label) helpers
#
# Vendor source: Installomator label archimate
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/archimate-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::archimate::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/archimate-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/archimate-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::archimate::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/archimate-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::archimate::is_installed() {
  [[ -d "/Applications/archimate.app" ]] || [[ -d "$HOME/Applications/archimate.app" ]]
}

maclib::archimate::installed_path() {
  if [[ -d "/Applications/archimate.app" ]]; then
    printf '%s\n' "/Applications/archimate.app"
  elif [[ -d "$HOME/Applications/archimate.app" ]]; then
    printf '%s\n' "$HOME/Applications/archimate.app"
  else
    return 1
  fi
}

maclib::archimate::install() {
  # No automated installer documented for "Archi" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "archimate::install: no automated installer; deploy manually"
  return 1
}

maclib::archimate::update() {
  maclib::log::error "archimate::update: no update path"
  return 127
}

maclib::archimate::uninstall() {
  maclib::log::warn "archimate::uninstall: no clean uninstall"
  return 1
}
