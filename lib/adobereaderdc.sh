#!/usr/bin/env bash
# shellcheck disable=all
# adobereaderdc.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label adobereaderdc
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/adobereaderdc-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::adobereaderdc::suite_installer_url() {
  printf '%s\n' "https://example.com/adobereaderdc-1.0.0.dmg"
}

maclib::adobereaderdc::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::adobereaderdc::is_installed() {
  [[ -d "/Applications/adobereaderdc.app" ]] || [[ -d "$HOME/Applications/adobereaderdc.app" ]]
}

maclib::adobereaderdc::installed_path() {
  if [[ -d "/Applications/adobereaderdc.app" ]]; then
    printf '%s\n' "/Applications/adobereaderdc.app"
  elif [[ -d "$HOME/Applications/adobereaderdc.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobereaderdc.app"
  else
    return 1
  fi
}

maclib::adobereaderdc::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "adobereaderdc::install: no automated installer; deploy manually"
  return 1
}

maclib::adobereaderdc::update() {
  maclib::log::error "adobereaderdc::update: no update path"
  return 127
}

maclib::adobereaderdc::uninstall() {
  maclib::log::warn "adobereaderdc::uninstall: no clean uninstall"
  return 1
}
