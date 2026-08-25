#!/usr/bin/env bash
# shellcheck disable=all
# applesfcompact.sh - "San Francisco Compact" (Installomator label) helpers
#
# Vendor source: Installomator label applesfcompact
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/applesfcompact-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::applesfcompact::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/applesfcompact-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/applesfcompact-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::applesfcompact::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/applesfcompact-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::applesfcompact::is_installed() {
  [[ -d "/Applications/applesfcompact.app" ]] || [[ -d "$HOME/Applications/applesfcompact.app" ]]
}

maclib::applesfcompact::installed_path() {
  if [[ -d "/Applications/applesfcompact.app" ]]; then
    printf '%s\n' "/Applications/applesfcompact.app"
  elif [[ -d "$HOME/Applications/applesfcompact.app" ]]; then
    printf '%s\n' "$HOME/Applications/applesfcompact.app"
  else
    return 1
  fi
}

maclib::applesfcompact::install() {
  # No automated installer documented for "San Francisco Compact" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "applesfcompact::install: no automated installer; deploy manually"
  return 1
}

maclib::applesfcompact::update() {
  maclib::log::error "applesfcompact::update: no update path"
  return 127
}

maclib::applesfcompact::uninstall() {
  maclib::log::warn "applesfcompact::uninstall: no clean uninstall"
  return 1
}
