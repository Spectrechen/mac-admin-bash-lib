#!/usr/bin/env bash
# shellcheck disable=all
# aspera.sh - "IBM Aspera Connect" (Installomator label) helpers
#
# Vendor source: Installomator label aspera
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (IBM — verify against vendor).
# Installer type: "None" (Aspera Connect is a browser plugin, not a standalone app).
# Installer URL: https://download.asperasoft.com/download/dist/aspera-connect/ (IBM download page).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#
# Notes: The "aspera" label in Installomator has no name or type set.
#   The related "asperaconnect" label uses a proper DMG/pkg installer.
#   Aspera Connect is a browser plugin that enables FASP high-speed transfers.
#   For enterprise deployment, use "asperaconnect" label instead which has
#   a proper DMG installer. This "aspera" entry is a placeholder for the
#   label that has no installer metadata in Installomator.
#
# Sources:
#   https://ibmaspera.com/help/downloads/desktop
#   https://download.asperasoft.com/download/docs/connect/3.8.3/user_osx/webhelp/dita/installation.html

maclib::apps::a::aspera::suite_installer_url() {
  printf '%s\n' "https://download.asperasoft.com/download/dist/aspera-connect/"
}

maclib::apps::a::aspera::latest_version() {
  # No public version API; latest version available from IBM download page.
  # Aspera Connect 3.11.x is the latest known series.
  printf '%s\n' "3.11.2"
}

maclib::apps::a::aspera::is_installed() {
  # Aspera Connect is a browser plugin; check for the plugin directory.
  [[ -d "/Library/Internet Plug-Ins/Aspera Connect.plugin" ]] || \
  [[ -d "$HOME/Library/Internet Plug-Ins/Aspera Connect.plugin" ]] || \
  [[ -d "/Applications/Aspera Connect.app" ]]
}

maclib::apps::a::aspera::installed_path() {
  if [[ -d "/Library/Internet Plug-Ins/Aspera Connect.plugin" ]]; then
    printf '%s\n' "/Library/Internet Plug-Ins/Aspera Connect.plugin"
  elif [[ -d "$HOME/Library/Internet Plug-Ins/Aspera Connect.plugin" ]]; then
    printf '%s\n' "$HOME/Library/Internet Plug-Ins/Aspera Connect.plugin"
  elif [[ -d "/Applications/Aspera Connect.app" ]]; then
    printf '%s\n' "/Applications/Aspera Connect.app"
  else
    return 1
  fi
}

maclib::apps::a::aspera::install() {
  # The "aspera" label has no installer metadata in Installomator.
  # Use "asperaconnect" label for proper deployment:
  #   maclib::apps::a::asperaconnect::install
  maclib::core::log::error "aspera::install: no installer metadata; use asperaconnect label instead"
  return 1
}

maclib::apps::a::aspera::update() {
  maclib::apps::a::aspera::install
}

maclib::apps::a::aspera::uninstall() {
  # Aspera Connect can be removed by deleting the plugin directory.
  rm -rf "/Library/Internet Plug-Ins/Aspera Connect.plugin" 2>/dev/null
  rm -rf "$HOME/Library/Internet Plug-Ins/Aspera Connect.plugin" 2>/dev/null
  rm -rf "/Applications/Aspera Connect.app" 2>/dev/null
  maclib::core::log::info "aspera::uninstall: removed plugin directories"
}
