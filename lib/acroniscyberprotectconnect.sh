#!/usr/bin/env bash
# shellcheck disable=all
# acroniscyberprotectconnect.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label acroniscyberprotectconnect
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/acroniscyberprotectconnect-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::acroniscyberprotectconnect::suite_installer_url() {
  printf '%s\n' "https://example.com/acroniscyberprotectconnect-1.0.0.dmg"
}

maclib::acroniscyberprotectconnect::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::acroniscyberprotectconnect::is_installed() {
  [[ -d "/Applications/acroniscyberprotectconnect.app" ]] || [[ -d "$HOME/Applications/acroniscyberprotectconnect.app" ]]
}

maclib::acroniscyberprotectconnect::installed_path() {
  if [[ -d "/Applications/acroniscyberprotectconnect.app" ]]; then
    printf '%s\n' "/Applications/acroniscyberprotectconnect.app"
  elif [[ -d "$HOME/Applications/acroniscyberprotectconnect.app" ]]; then
    printf '%s\n' "$HOME/Applications/acroniscyberprotectconnect.app"
  else
    return 1
  fi
}

maclib::acroniscyberprotectconnect::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "acroniscyberprotectconnect::install: no automated installer; deploy manually"
  return 1
}

maclib::acroniscyberprotectconnect::update() {
  maclib::log::error "acroniscyberprotectconnect::update: no update path"
  return 127
}

maclib::acroniscyberprotectconnect::uninstall() {
  maclib::log::warn "acroniscyberprotectconnect::uninstall: no clean uninstall"
  return 1
}
