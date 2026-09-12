#!/usr/bin/env bash
# STATUS: DRAFT — NOT production-ready. Placeholder installer URL (example.com)
# from the bulk vendor-research pass; real vendor data was never filled in.
# Not sourced by lib/maclib.sh. Do not use install()/update() from this module
# until the vendor URL, Team ID and update path are verified and this notice
# is removed. Re-run vendor research against the Installomator label before use.
# shellcheck disable=all
# apachedirectorystudio.sh - "ApacheDirectoryStudio" (Installomator label) helpers
#
# Vendor source: Installomator label apachedirectorystudio
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/apachedirectorystudio-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apachedirectorystudio::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/apachedirectorystudio-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/apachedirectorystudio-1.0.0.dmg"
  printf '%s\n' "$live"
}

maclib::apachedirectorystudio::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/apachedirectorystudio-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%s\n' "$ver"
}

maclib::apachedirectorystudio::is_installed() {
  [[ -d "/Applications/apachedirectorystudio.app" ]] || [[ -d "$HOME/Applications/apachedirectorystudio.app" ]]
}

maclib::apachedirectorystudio::installed_path() {
  if [[ -d "/Applications/apachedirectorystudio.app" ]]; then
    printf '%s\n' "/Applications/apachedirectorystudio.app"
  elif [[ -d "$HOME/Applications/apachedirectorystudio.app" ]]; then
    printf '%s\n' "$HOME/Applications/apachedirectorystudio.app"
  else
    return 1
  fi
}

maclib::apachedirectorystudio::install() {
  # No automated installer documented for "ApacheDirectoryStudio" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "apachedirectorystudio::install: no automated installer; deploy manually"
  return 1
}

maclib::apachedirectorystudio::update() {
  maclib::log::error "apachedirectorystudio::update: no update path"
  return 127
}

maclib::apachedirectorystudio::uninstall() {
  maclib::log::warn "apachedirectorystudio::uninstall: no clean uninstall"
  return 1
}
