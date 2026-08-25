#!/usr/bin/env bash
# shellcheck disable=all
# ape.sh - "ApE" (Installomator label) helpers
#
# Vendor source: Installomator label ape
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/ape-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::ape::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/ape-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/ape-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::ape::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/ape-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::ape::is_installed() {
  [[ -d "/Applications/ape.app" ]] || [[ -d "$HOME/Applications/ape.app" ]]
}

maclib::ape::installed_path() {
  if [[ -d "/Applications/ape.app" ]]; then
    printf '%s\n' "/Applications/ape.app"
  elif [[ -d "$HOME/Applications/ape.app" ]]; then
    printf '%s\n' "$HOME/Applications/ape.app"
  else
    return 1
  fi
}

maclib::ape::install() {
  # No automated installer documented for "ApE" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "ape::install: no automated installer; deploy manually"
  return 1
}

maclib::ape::update() {
  maclib::log::error "ape::update: no update path"
  return 127
}

maclib::ape::uninstall() {
  maclib::log::warn "ape::uninstall: no clean uninstall"
  return 1
}
