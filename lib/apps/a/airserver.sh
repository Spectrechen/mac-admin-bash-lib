#!/usr/bin/env bash
# shellcheck disable=all
# airserver.sh - "AirServer" (Installomator label) helpers
#
# Vendor source: Installomator label airserver
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/airserver-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::airserver::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/airserver-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/airserver-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::airserver::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/airserver-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::airserver::is_installed() {
  [[ -d "/Applications/airserver.app" ]] || [[ -d "$HOME/Applications/airserver.app" ]]
}

maclib::airserver::installed_path() {
  if [[ -d "/Applications/airserver.app" ]]; then
    printf '%s\n' "/Applications/airserver.app"
  elif [[ -d "$HOME/Applications/airserver.app" ]]; then
    printf '%s\n' "$HOME/Applications/airserver.app"
  else
    return 1
  fi
}

maclib::airserver::install() {
  # No automated installer documented for "AirServer" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "airserver::install: no automated installer; deploy manually"
  return 1
}

maclib::airserver::update() {
  maclib::log::error "airserver::update: no update path"
  return 127
}

maclib::airserver::uninstall() {
  maclib::log::warn "airserver::uninstall: no clean uninstall"
  return 1
}
