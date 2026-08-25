#!/usr/bin/env bash
# shellcheck disable=all
# 8x8.sh - "8x8 Work" (Installomator label) helpers
#
# Vendor source: Installomator label 8x8
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/8x8-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::8x8::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/8x8-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/8x8-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::8x8::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/8x8-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::8x8::is_installed() {
  [[ -d "/Applications/8x8.app" ]] || [[ -d "$HOME/Applications/8x8.app" ]]
}

maclib::8x8::installed_path() {
  if [[ -d "/Applications/8x8.app" ]]; then
    printf '%s\n' "/Applications/8x8.app"
  elif [[ -d "$HOME/Applications/8x8.app" ]]; then
    printf '%s\n' "$HOME/Applications/8x8.app"
  else
    return 1
  fi
}

maclib::8x8::install() {
  # No automated installer documented for "8x8 Work" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "8x8::install: no automated installer; deploy manually"
  return 1
}

maclib::8x8::update() {
  maclib::log::error "8x8::update: no update path"
  return 127
}

maclib::8x8::uninstall() {
  maclib::log::warn "8x8::uninstall: no clean uninstall"
  return 1
}
