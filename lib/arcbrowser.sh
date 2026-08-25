#!/usr/bin/env bash
# shellcheck disable=all
# arcbrowser.sh - "Arc" (Installomator label) helpers
#
# Vendor source: Installomator label arcbrowser
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/arcbrowser-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::arcbrowser::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/arcbrowser-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/arcbrowser-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::arcbrowser::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/arcbrowser-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::arcbrowser::is_installed() {
  [[ -d "/Applications/arcbrowser.app" ]] || [[ -d "$HOME/Applications/arcbrowser.app" ]]
}

maclib::arcbrowser::installed_path() {
  if [[ -d "/Applications/arcbrowser.app" ]]; then
    printf '%s\n' "/Applications/arcbrowser.app"
  elif [[ -d "$HOME/Applications/arcbrowser.app" ]]; then
    printf '%s\n' "$HOME/Applications/arcbrowser.app"
  else
    return 1
  fi
}

maclib::arcbrowser::install() {
  # No automated installer documented for "Arc" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "arcbrowser::install: no automated installer; deploy manually"
  return 1
}

maclib::arcbrowser::update() {
  maclib::log::error "arcbrowser::update: no update path"
  return 127
}

maclib::arcbrowser::uninstall() {
  maclib::log::warn "arcbrowser::uninstall: no clean uninstall"
  return 1
}
