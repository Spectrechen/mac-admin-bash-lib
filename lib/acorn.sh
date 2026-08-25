#!/usr/bin/env bash
# shellcheck disable=all
# acorn.sh - "Acorn" (Installomator label) helpers
#
# Vendor source: Installomator label acorn
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "zip".
# Installer URL: https://example.com/acorn-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::acorn::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/acorn-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/acorn-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::acorn::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/acorn-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::acorn::is_installed() {
  [[ -d "/Applications/acorn.app" ]] || [[ -d "$HOME/Applications/acorn.app" ]]
}

maclib::acorn::installed_path() {
  if [[ -d "/Applications/acorn.app" ]]; then
    printf '%s\n' "/Applications/acorn.app"
  elif [[ -d "$HOME/Applications/acorn.app" ]]; then
    printf '%s\n' "$HOME/Applications/acorn.app"
  else
    return 1
  fi
}

maclib::acorn::install() {
  # No automated installer documented for "Acorn" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "acorn::install: no automated installer; deploy manually"
  return 1
}

maclib::acorn::update() {
  maclib::log::error "acorn::update: no update path"
  return 127
}

maclib::acorn::uninstall() {
  maclib::log::warn "acorn::uninstall: no clean uninstall"
  return 1
}
