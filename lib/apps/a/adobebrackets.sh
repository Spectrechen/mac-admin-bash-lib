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

maclib::apps::a::adobebrackets::suite_installer_url() {
  printf '%s\n' "https://example.com/adobebrackets-1.0.0.dmg"
}

maclib::apps::a::adobebrackets::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::apps::a::adobebrackets::is_installed() {
  [[ -d "/Applications/adobebrackets.app" ]] || [[ -d "$HOME/Applications/adobebrackets.app" ]]
}

maclib::apps::a::adobebrackets::installed_path() {
  if [[ -d "/Applications/adobebrackets.app" ]]; then
    printf '%s\n' "/Applications/adobebrackets.app"
  elif [[ -d "$HOME/Applications/adobebrackets.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobebrackets.app"
  else
    return 1
  fi
}

maclib::apps::a::adobebrackets::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "adobebrackets::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::adobebrackets::update() {
  maclib::core::log::error "adobebrackets::update: no update path"
  return 127
}

maclib::apps::a::adobebrackets::uninstall() {
  maclib::core::log::warn "adobebrackets::uninstall: no clean uninstall"
  return 1
}
