#!/usr/bin/env bash
# shellcheck disable=all
# adobeconnect.sh - "AdobeConnectInstaller" (Installomator label) helpers
#
# Vendor source: Installomator label adobeconnect
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/adobeconnect-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::adobeconnect::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/adobeconnect-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/adobeconnect-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::adobeconnect::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/adobeconnect-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::adobeconnect::is_installed() {
  [[ -d "/Applications/adobeconnect.app" ]] || [[ -d "$HOME/Applications/adobeconnect.app" ]]
}

maclib::adobeconnect::installed_path() {
  if [[ -d "/Applications/adobeconnect.app" ]]; then
    printf '%s\n' "/Applications/adobeconnect.app"
  elif [[ -d "$HOME/Applications/adobeconnect.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobeconnect.app"
  else
    return 1
  fi
}

maclib::adobeconnect::install() {
  # No automated installer documented for "AdobeConnectInstaller" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "adobeconnect::install: no automated installer; deploy manually"
  return 1
}

maclib::adobeconnect::update() {
  maclib::log::error "adobeconnect::update: no update path"
  return 127
}

maclib::adobeconnect::uninstall() {
  maclib::log::warn "adobeconnect::uninstall: no clean uninstall"
  return 1
}
