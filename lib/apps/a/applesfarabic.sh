#!/usr/bin/env bash
# shellcheck disable=all
# applesfarabic.sh - "San Francisco Arabic" (Installomator label) helpers
#
# Vendor source: Installomator label applesfarabic
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/applesfarabic-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::applesfarabic::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/applesfarabic-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/applesfarabic-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::applesfarabic::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/applesfarabic-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::applesfarabic::is_installed() {
  [[ -d "/Applications/applesfarabic.app" ]] || [[ -d "$HOME/Applications/applesfarabic.app" ]]
}

maclib::applesfarabic::installed_path() {
  if [[ -d "/Applications/applesfarabic.app" ]]; then
    printf '%s\n' "/Applications/applesfarabic.app"
  elif [[ -d "$HOME/Applications/applesfarabic.app" ]]; then
    printf '%s\n' "$HOME/Applications/applesfarabic.app"
  else
    return 1
  fi
}

maclib::applesfarabic::install() {
  # No automated installer documented for "San Francisco Arabic" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "applesfarabic::install: no automated installer; deploy manually"
  return 1
}

maclib::applesfarabic::update() {
  maclib::log::error "applesfarabic::update: no update path"
  return 127
}

maclib::applesfarabic::uninstall() {
  maclib::log::warn "applesfarabic::uninstall: no clean uninstall"
  return 1
}
