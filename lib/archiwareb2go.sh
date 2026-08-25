#!/usr/bin/env bash
# shellcheck disable=all
# archiwareb2go.sh - "P5 Workstation" (Installomator label) helpers
#
# Vendor source: Installomator label archiwareb2go
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/archiwareb2go-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::archiwareb2go::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/archiwareb2go-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/archiwareb2go-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::archiwareb2go::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/archiwareb2go-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::archiwareb2go::is_installed() {
  [[ -d "/Applications/archiwareb2go.app" ]] || [[ -d "$HOME/Applications/archiwareb2go.app" ]]
}

maclib::archiwareb2go::installed_path() {
  if [[ -d "/Applications/archiwareb2go.app" ]]; then
    printf '%s\n' "/Applications/archiwareb2go.app"
  elif [[ -d "$HOME/Applications/archiwareb2go.app" ]]; then
    printf '%s\n' "$HOME/Applications/archiwareb2go.app"
  else
    return 1
  fi
}

maclib::archiwareb2go::install() {
  # No automated installer documented for "P5 Workstation" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "archiwareb2go::install: no automated installer; deploy manually"
  return 1
}

maclib::archiwareb2go::update() {
  maclib::log::error "archiwareb2go::update: no update path"
  return 127
}

maclib::archiwareb2go::uninstall() {
  maclib::log::warn "archiwareb2go::uninstall: no clean uninstall"
  return 1
}
