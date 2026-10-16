#!/usr/bin/env bash
# shellcheck disable=all
# archiwareb2go.sh - "P5 Workstation" (Installomator label) helpers
#
# Vendor source: Installomator label archiwareb2go
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (Archiware — verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://www.archiware.com/download-p5 (request trial/license to download).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#
# Notes: Archiware P5 Workstation B2G requires a trial license or purchased license.
#   The download page at archiware.com/download-p5 initiates a trial request form.
#   Enterprise deployments may need to contact Archiware for volume licensing.
#
# Sources:
#   https://www.archiware.com/download-p5

maclib::apps::a::archiwareb2go::suite_installer_url() {
  printf '%s\n' "https://www.archiware.com/download-p5"
}

maclib::apps::a::archiwareb2go::latest_version() {
  # No public version API; latest version tracked on archiware.com/download-p5.
  printf '%s\n' "5.0"
}

maclib::apps::a::archiwareb2go::is_installed() {
  [[ -d "/Applications/P5 Workstation.app" ]] || [[ -d "$HOME/Applications/P5 Workstation.app" ]]
}

maclib::apps::a::archiwareb2go::installed_path() {
  if [[ -d "/Applications/P5 Workstation.app" ]]; then
    printf '%s\n' "/Applications/P5 Workstation.app"
  elif [[ -d "$HOME/Applications/P5 Workstation.app" ]]; then
    printf '%s\n' "$HOME/Applications/P5 Workstation.app"
  else
    return 1
  fi
}

maclib::apps::a::archiwareb2go::install() {
  # Archiware P5 Workstation B2G requires a trial license or purchased license.
  # The installer is obtained via the Archiware download page.
  # For automated deployment, contact Archiware for enterprise licensing.
  maclib::core::log::error "archiwareb2go::install: requires trial/license; obtain from archiware.com/download-p5"
  return 1
}

maclib::apps::a::archiwareb2go::update() {
  maclib::apps::a::archiwareb2go::install
}

maclib::apps::a::archiwareb2go::uninstall() {
  maclib::core::log::warn "archiwareb2go::uninstall: no clean uninstall"
  return 1
}
