#!/usr/bin/env bash
# shellcheck disable=all
# adobebrackets.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label adobebrackets
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/adobebrackets-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::adobebrackets::suite_installer_url() {
  printf '%s\n' "https://example.com/adobebrackets-1.0.0.dmg"
}

maclib::adobebrackets::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::adobebrackets::is_installed() {
  [[ -d "/Applications/adobebrackets.app" ]] || [[ -d "$HOME/Applications/adobebrackets.app" ]]
}

maclib::adobebrackets::installed_path() {
  if [[ -d "/Applications/adobebrackets.app" ]]; then
    printf '%s\n' "/Applications/adobebrackets.app"
  elif [[ -d "$HOME/Applications/adobebrackets.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobebrackets.app"
  else
    return 1
  fi
}

maclib::adobebrackets::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "adobebrackets::install: no automated installer; deploy manually"
  return 1
}

maclib::adobebrackets::update() {
  maclib::log::error "adobebrackets::update: no update path"
  return 127
}

maclib::adobebrackets::uninstall() {
  maclib::log::warn "adobebrackets::uninstall: no clean uninstall"
  return 1
}
