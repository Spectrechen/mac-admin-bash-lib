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

maclib::apps::a::adobereaderdc::suite_installer_url() {
  printf '%s\n' "https://example.com/adobereaderdc-1.0.0.dmg"
}

maclib::apps::a::adobereaderdc::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::apps::a::adobereaderdc::is_installed() {
  [[ -d "/Applications/adobereaderdc.app" ]] || [[ -d "$HOME/Applications/adobereaderdc.app" ]]
}

maclib::apps::a::adobereaderdc::installed_path() {
  if [[ -d "/Applications/adobereaderdc.app" ]]; then
    printf '%s\n' "/Applications/adobereaderdc.app"
  elif [[ -d "$HOME/Applications/adobereaderdc.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobereaderdc.app"
  else
    return 1
  fi
}

maclib::apps::a::adobereaderdc::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "adobereaderdc::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::adobereaderdc::update() {
  maclib::core::log::error "adobereaderdc::update: no update path"
  return 127
}

maclib::apps::a::adobereaderdc::uninstall() {
  maclib::core::log::warn "adobereaderdc::uninstall: no clean uninstall"
  return 1
}
