#!/usr/bin/env bash
# shellcheck disable=all
# chemdoodle.sh - "ChemDoodle" (Installomator label) helpers
#
# Vendor source: Installomator label chemdoodle
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (iChemLabs — verify against vendor).
# Installer type: "None" (ChemDoodle is distributed as a DMG from iChemLabs).
# Installer URL: https://www.ichemlabs.com/download (iChemLabs download page).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#
# Notes: ChemDoodle is a chemical drawing application by iChemLabs.
#   The free trial and licensed versions are available from ichemlabs.com/download.
#   The "chemdoodle" label in Installomator has no name/type set.
#   Related labels: chemdoodle2d, chemdoodle3d (specific product variants).
#
# Sources:
#   https://www.ichemlabs.com/download
#   https://www.chemdoodle.com/

maclib::apps::c::chemdoodle::suite_installer_url() {
  printf '%s\n' "https://www.ichemlabs.com/download"
}

maclib::apps::c::chemdoodle::latest_version() {
  # No public version API; latest version available from iChemLabs download page.
  printf '%s\n' "8.0"
}

maclib::apps::c::chemdoodle::is_installed() {
  [[ -d "/Applications/ChemDoodle.app" ]] || [[ -d "$HOME/Applications/ChemDoodle.app" ]]
}

maclib::apps::c::chemdoodle::installed_path() {
  if [[ -d "/Applications/ChemDoodle.app" ]]; then
    printf '%s\n' "/Applications/ChemDoodle.app"
  elif [[ -d "$HOME/Applications/ChemDoodle.app" ]]; then
    printf '%s\n' "$HOME/Applications/ChemDoodle.app"
  else
    return 1
  fi
}

maclib::apps::c::chemdoodle::install() {
  # ChemDoodle requires download from iChemLabs (trial or licensed).
  # No automated installer URL available in Installomator metadata.
  maclib::core::log::error "chemdoodle::install: no installer metadata; obtain from ichemlabs.com/download"
  return 1
}

maclib::apps::c::chemdoodle::update() {
  maclib::apps::c::chemdoodle::install
}

maclib::apps::c::chemdoodle::uninstall() {
  maclib::core::log::warn "chemdoodle::uninstall: no clean uninstall"
  return 1
}
