#!/usr/bin/env bash
# shellcheck disable=all
# aquamacs.sh - "Aquamacs" (Installomator label) helpers
#
# Vendor source: Installomator label aquamacs
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/aquamacs-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::aquamacs::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/aquamacs-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/aquamacs-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::aquamacs::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/aquamacs-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::aquamacs::is_installed() {
  [[ -d "/Applications/aquamacs.app" ]] || [[ -d "$HOME/Applications/aquamacs.app" ]]
}

maclib::aquamacs::installed_path() {
  if [[ -d "/Applications/aquamacs.app" ]]; then
    printf '%s\n' "/Applications/aquamacs.app"
  elif [[ -d "$HOME/Applications/aquamacs.app" ]]; then
    printf '%s\n' "$HOME/Applications/aquamacs.app"
  else
    return 1
  fi
}

maclib::aquamacs::install() {
  # No automated installer documented for "Aquamacs" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "aquamacs::install: no automated installer; deploy manually"
  return 1
}

maclib::aquamacs::update() {
  maclib::log::error "aquamacs::update: no update path"
  return 127
}

maclib::aquamacs::uninstall() {
  maclib::log::warn "aquamacs::uninstall: no clean uninstall"
  return 1
}
