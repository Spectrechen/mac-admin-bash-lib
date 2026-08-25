#!/usr/bin/env bash
# shellcheck disable=all
# amazonworkspaces.sh - "Workspaces" (Installomator label) helpers
#
# Vendor source: Installomator label amazonworkspaces
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkg".
# Installer URL: https://example.com/amazonworkspaces-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::amazonworkspaces::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/amazonworkspaces-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/amazonworkspaces-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::amazonworkspaces::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/amazonworkspaces-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::amazonworkspaces::is_installed() {
  [[ -d "/Applications/amazonworkspaces.app" ]] || [[ -d "$HOME/Applications/amazonworkspaces.app" ]]
}

maclib::amazonworkspaces::installed_path() {
  if [[ -d "/Applications/amazonworkspaces.app" ]]; then
    printf '%s\n' "/Applications/amazonworkspaces.app"
  elif [[ -d "$HOME/Applications/amazonworkspaces.app" ]]; then
    printf '%s\n' "$HOME/Applications/amazonworkspaces.app"
  else
    return 1
  fi
}

maclib::amazonworkspaces::install() {
  # No automated installer documented for "Workspaces" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "amazonworkspaces::install: no automated installer; deploy manually"
  return 1
}

maclib::amazonworkspaces::update() {
  maclib::log::error "amazonworkspaces::update: no update path"
  return 127
}

maclib::amazonworkspaces::uninstall() {
  maclib::log::warn "amazonworkspaces::uninstall: no clean uninstall"
  return 1
}
