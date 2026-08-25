#!/usr/bin/env bash
# shellcheck disable=all
# anki.sh - "Anki" (Installomator label) helpers
#
# Vendor source: Installomator label anki
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/anki-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::anki::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/anki-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/anki-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::anki::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/anki-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::anki::is_installed() {
  [[ -d "/Applications/anki.app" ]] || [[ -d "$HOME/Applications/anki.app" ]]
}

maclib::anki::installed_path() {
  if [[ -d "/Applications/anki.app" ]]; then
    printf '%s\n' "/Applications/anki.app"
  elif [[ -d "$HOME/Applications/anki.app" ]]; then
    printf '%s\n' "$HOME/Applications/anki.app"
  else
    return 1
  fi
}

maclib::anki::install() {
  # No automated installer documented for "Anki" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "anki::install: no automated installer; deploy manually"
  return 1
}

maclib::anki::update() {
  maclib::log::error "anki::update: no update path"
  return 127
}

maclib::anki::uninstall() {
  maclib::log::warn "anki::uninstall: no clean uninstall"
  return 1
}
