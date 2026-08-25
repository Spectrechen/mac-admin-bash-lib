#!/usr/bin/env bash
# shellcheck disable=all
# abletonlive12lite.sh - "Ableton Live 12 Lite" (Installomator label) helpers
#
# Vendor source: Installomator label abletonlive12lite
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/abletonlive12lite-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::abletonlive12lite::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/abletonlive12lite-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/abletonlive12lite-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::abletonlive12lite::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/abletonlive12lite-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::abletonlive12lite::is_installed() {
  [[ -d "/Applications/abletonlive12lite.app" ]] || [[ -d "$HOME/Applications/abletonlive12lite.app" ]]
}

maclib::abletonlive12lite::installed_path() {
  if [[ -d "/Applications/abletonlive12lite.app" ]]; then
    printf '%s\n' "/Applications/abletonlive12lite.app"
  elif [[ -d "$HOME/Applications/abletonlive12lite.app" ]]; then
    printf '%s\n' "$HOME/Applications/abletonlive12lite.app"
  else
    return 1
  fi
}

maclib::abletonlive12lite::install() {
  # No automated installer documented for "Ableton Live 12 Lite" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "abletonlive12lite::install: no automated installer; deploy manually"
  return 1
}

maclib::abletonlive12lite::update() {
  maclib::log::error "abletonlive12lite::update: no update path"
  return 127
}

maclib::abletonlive12lite::uninstall() {
  maclib::log::warn "abletonlive12lite::uninstall: no clean uninstall"
  return 1
}
