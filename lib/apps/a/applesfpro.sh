#!/usr/bin/env bash
# shellcheck disable=all
# applesfpro.sh - "San Francisco Pro" (Installomator label) helpers
#
# Vendor source: Installomator label applesfpro
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/applesfpro-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::applesfpro::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/applesfpro-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/applesfpro-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::applesfpro::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/applesfpro-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::applesfpro::is_installed() {
  [[ -d "/Applications/applesfpro.app" ]] || [[ -d "$HOME/Applications/applesfpro.app" ]]
}

maclib::applesfpro::installed_path() {
  if [[ -d "/Applications/applesfpro.app" ]]; then
    printf '%s\n' "/Applications/applesfpro.app"
  elif [[ -d "$HOME/Applications/applesfpro.app" ]]; then
    printf '%s\n' "$HOME/Applications/applesfpro.app"
  else
    return 1
  fi
}

maclib::applesfpro::install() {
  # No automated installer documented for "San Francisco Pro" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "applesfpro::install: no automated installer; deploy manually"
  return 1
}

maclib::applesfpro::update() {
  maclib::log::error "applesfpro::update: no update path"
  return 127
}

maclib::applesfpro::uninstall() {
  maclib::log::warn "applesfpro::uninstall: no clean uninstall"
  return 1
}
