#!/usr/bin/env bash
# shellcheck disable=all
# archaeology.sh - "Archaeology" (Installomator label) helpers
#
# Vendor source: Installomator label archaeology
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/archaeology-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::archaeology::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/archaeology-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/archaeology-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::archaeology::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/archaeology-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::archaeology::is_installed() {
  [[ -d "/Applications/archaeology.app" ]] || [[ -d "$HOME/Applications/archaeology.app" ]]
}

maclib::archaeology::installed_path() {
  if [[ -d "/Applications/archaeology.app" ]]; then
    printf '%s\n' "/Applications/archaeology.app"
  elif [[ -d "$HOME/Applications/archaeology.app" ]]; then
    printf '%s\n' "$HOME/Applications/archaeology.app"
  else
    return 1
  fi
}

maclib::archaeology::install() {
  # No automated installer documented for "Archaeology" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "archaeology::install: no automated installer; deploy manually"
  return 1
}

maclib::archaeology::update() {
  maclib::log::error "archaeology::update: no update path"
  return 127
}

maclib::archaeology::uninstall() {
  maclib::log::warn "archaeology::uninstall: no clean uninstall"
  return 1
}
