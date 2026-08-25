#!/usr/bin/env bash
# shellcheck disable=all
# adobereaderdc-update.sh - "Adobe Acrobat Reader" (Installomator label) helpers
#
# Vendor source: Installomator label adobereaderdc-update
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/adobereaderdc-update-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::adobereaderdc-update::suite_installer_url() {
  printf '%s\n' "https://example.com/adobereaderdc-update-1.0.0.dmg"
}

maclib::adobereaderdc-update::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::adobereaderdc-update::is_installed() {
  [[ -d "/Applications/adobereaderdc-update.app" ]] || [[ -d "$HOME/Applications/adobereaderdc-update.app" ]]
}

maclib::adobereaderdc-update::installed_path() {
  if [[ -d "/Applications/adobereaderdc-update.app" ]]; then
    printf '%s\n' "/Applications/adobereaderdc-update.app"
  elif [[ -d "$HOME/Applications/adobereaderdc-update.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobereaderdc-update.app"
  else
    return 1
  fi
}

maclib::adobereaderdc-update::install() {
  # No automated installer documented for "Adobe Acrobat Reader" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "adobereaderdc-update::install: no automated installer; deploy manually"
  return 1
}

maclib::adobereaderdc-update::update() {
  maclib::log::error "adobereaderdc-update::update: no update path"
  return 127
}

maclib::adobereaderdc-update::uninstall() {
  maclib::log::warn "adobereaderdc-update::uninstall: no clean uninstall"
  return 1
}
