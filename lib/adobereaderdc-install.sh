#!/usr/bin/env bash
# shellcheck disable=all
# adobereaderdc-install.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label adobereaderdc-install
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/adobereaderdc-install-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::adobereaderdc-install::suite_installer_url() {
  printf '%s\n' "https://example.com/adobereaderdc-install-1.0.0.dmg"
}

maclib::adobereaderdc-install::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::adobereaderdc-install::is_installed() {
  [[ -d "/Applications/adobereaderdc-install.app" ]] || [[ -d "$HOME/Applications/adobereaderdc-install.app" ]]
}

maclib::adobereaderdc-install::installed_path() {
  if [[ -d "/Applications/adobereaderdc-install.app" ]]; then
    printf '%s\n' "/Applications/adobereaderdc-install.app"
  elif [[ -d "$HOME/Applications/adobereaderdc-install.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobereaderdc-install.app"
  else
    return 1
  fi
}

maclib::adobereaderdc-install::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "adobereaderdc-install::install: no automated installer; deploy manually"
  return 1
}

maclib::adobereaderdc-install::update() {
  maclib::log::error "adobereaderdc-install::update: no update path"
  return 127
}

maclib::adobereaderdc-install::uninstall() {
  maclib::log::warn "adobereaderdc-install::uninstall: no clean uninstall"
  return 1
}
