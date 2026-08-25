#!/usr/bin/env bash
# shellcheck disable=all
# adium.sh - "Adium" (Installomator label) helpers
#
# Vendor source: Installomator label adium
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/adium-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::adium::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/adium-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/adium-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::adium::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/adium-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::adium::is_installed() {
  [[ -d "/Applications/adium.app" ]] || [[ -d "$HOME/Applications/adium.app" ]]
}

maclib::adium::installed_path() {
  if [[ -d "/Applications/adium.app" ]]; then
    printf '%s\n' "/Applications/adium.app"
  elif [[ -d "$HOME/Applications/adium.app" ]]; then
    printf '%s\n' "$HOME/Applications/adium.app"
  else
    return 1
  fi
}

maclib::adium::install() {
  # No automated installer documented for "Adium" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "adium::install: no automated installer; deploy manually"
  return 1
}

maclib::adium::update() {
  maclib::log::error "adium::update: no update path"
  return 127
}

maclib::adium::uninstall() {
  maclib::log::warn "adium::uninstall: no clean uninstall"
  return 1
}
