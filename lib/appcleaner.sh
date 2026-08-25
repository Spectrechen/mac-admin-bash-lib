#!/usr/bin/env bash
# shellcheck disable=all
# appcleaner.sh - "AppCleaner" (Installomator label) helpers
#
# Vendor source: Installomator label appcleaner
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "zip".
# Installer URL: https://example.com/appcleaner-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::appcleaner::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/appcleaner-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/appcleaner-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::appcleaner::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/appcleaner-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::appcleaner::is_installed() {
  [[ -d "/Applications/appcleaner.app" ]] || [[ -d "$HOME/Applications/appcleaner.app" ]]
}

maclib::appcleaner::installed_path() {
  if [[ -d "/Applications/appcleaner.app" ]]; then
    printf '%s\n' "/Applications/appcleaner.app"
  elif [[ -d "$HOME/Applications/appcleaner.app" ]]; then
    printf '%s\n' "$HOME/Applications/appcleaner.app"
  else
    return 1
  fi
}

maclib::appcleaner::install() {
  # No automated installer documented for "AppCleaner" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "appcleaner::install: no automated installer; deploy manually"
  return 1
}

maclib::appcleaner::update() {
  maclib::log::error "appcleaner::update: no update path"
  return 127
}

maclib::appcleaner::uninstall() {
  maclib::log::warn "appcleaner::uninstall: no clean uninstall"
  return 1
}
