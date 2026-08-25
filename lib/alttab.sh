#!/usr/bin/env bash
# shellcheck disable=all
# alttab.sh - "AltTab" (Installomator label) helpers
#
# Vendor source: Installomator label alttab
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "zip".
# Installer URL: https://example.com/alttab-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::alttab::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/alttab-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/alttab-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::alttab::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/alttab-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::alttab::is_installed() {
  [[ -d "/Applications/alttab.app" ]] || [[ -d "$HOME/Applications/alttab.app" ]]
}

maclib::alttab::installed_path() {
  if [[ -d "/Applications/alttab.app" ]]; then
    printf '%s\n' "/Applications/alttab.app"
  elif [[ -d "$HOME/Applications/alttab.app" ]]; then
    printf '%s\n' "$HOME/Applications/alttab.app"
  else
    return 1
  fi
}

maclib::alttab::install() {
  # No automated installer documented for "AltTab" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "alttab::install: no automated installer; deploy manually"
  return 1
}

maclib::alttab::update() {
  maclib::log::error "alttab::update: no update path"
  return 127
}

maclib::alttab::uninstall() {
  maclib::log::warn "alttab::uninstall: no clean uninstall"
  return 1
}
