#!/usr/bin/env bash
# shellcheck disable=all
# appleprovideoformats.sh - "ProVideoFormats" (Installomator label) helpers
#
# Vendor source: Installomator label appleprovideoformats
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/appleprovideoformats-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::appleprovideoformats::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/appleprovideoformats-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/appleprovideoformats-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::appleprovideoformats::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/appleprovideoformats-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::appleprovideoformats::is_installed() {
  [[ -d "/Applications/appleprovideoformats.app" ]] || [[ -d "$HOME/Applications/appleprovideoformats.app" ]]
}

maclib::appleprovideoformats::installed_path() {
  if [[ -d "/Applications/appleprovideoformats.app" ]]; then
    printf '%s\n' "/Applications/appleprovideoformats.app"
  elif [[ -d "$HOME/Applications/appleprovideoformats.app" ]]; then
    printf '%s\n' "$HOME/Applications/appleprovideoformats.app"
  else
    return 1
  fi
}

maclib::appleprovideoformats::install() {
  # No automated installer documented for "ProVideoFormats" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "appleprovideoformats::install: no automated installer; deploy manually"
  return 1
}

maclib::appleprovideoformats::update() {
  maclib::log::error "appleprovideoformats::update: no update path"
  return 127
}

maclib::appleprovideoformats::uninstall() {
  maclib::log::warn "appleprovideoformats::uninstall: no clean uninstall"
  return 1
}
