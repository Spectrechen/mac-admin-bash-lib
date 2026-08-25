#!/usr/bin/env bash
# shellcheck disable=all
# aspera.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label aspera
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/aspera-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::aspera::suite_installer_url() {
  printf '%s\n' "https://example.com/aspera-1.0.0.dmg"
}

maclib::aspera::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::aspera::is_installed() {
  [[ -d "/Applications/aspera.app" ]] || [[ -d "$HOME/Applications/aspera.app" ]]
}

maclib::aspera::installed_path() {
  if [[ -d "/Applications/aspera.app" ]]; then
    printf '%s\n' "/Applications/aspera.app"
  elif [[ -d "$HOME/Applications/aspera.app" ]]; then
    printf '%s\n' "$HOME/Applications/aspera.app"
  else
    return 1
  fi
}

maclib::aspera::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "aspera::install: no automated installer; deploy manually"
  return 1
}

maclib::aspera::update() {
  maclib::log::error "aspera::update: no update path"
  return 127
}

maclib::aspera::uninstall() {
  maclib::log::warn "aspera::uninstall: no clean uninstall"
  return 1
}
