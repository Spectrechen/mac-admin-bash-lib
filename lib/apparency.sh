#!/usr/bin/env bash
# shellcheck disable=all
# apparency.sh - "Apparency" (Installomator label) helpers
#
# Vendor source: Installomator label apparency
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/apparency-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apparency::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/apparency-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/apparency-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apparency::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/apparency-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apparency::is_installed() {
  [[ -d "/Applications/apparency.app" ]] || [[ -d "$HOME/Applications/apparency.app" ]]
}

maclib::apparency::installed_path() {
  if [[ -d "/Applications/apparency.app" ]]; then
    printf '%s\n' "/Applications/apparency.app"
  elif [[ -d "$HOME/Applications/apparency.app" ]]; then
    printf '%s\n' "$HOME/Applications/apparency.app"
  else
    return 1
  fi
}

maclib::apparency::install() {
  # No automated installer documented for "Apparency" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "apparency::install: no automated installer; deploy manually"
  return 1
}

maclib::apparency::update() {
  maclib::log::error "apparency::update: no update path"
  return 127
}

maclib::apparency::uninstall() {
  maclib::log::warn "apparency::uninstall: no clean uninstall"
  return 1
}
