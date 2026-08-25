#!/usr/bin/env bash
# shellcheck disable=all
# chemdoodle.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label chemdoodle
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/chemdoodle-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::chemdoodle::suite_installer_url() {
  printf '%s\n' "https://example.com/chemdoodle-1.0.0.dmg"
}

maclib::chemdoodle::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::chemdoodle::is_installed() {
  [[ -d "/Applications/chemdoodle.app" ]] || [[ -d "$HOME/Applications/chemdoodle.app" ]]
}

maclib::chemdoodle::installed_path() {
  if [[ -d "/Applications/chemdoodle.app" ]]; then
    printf '%s\n' "/Applications/chemdoodle.app"
  elif [[ -d "$HOME/Applications/chemdoodle.app" ]]; then
    printf '%s\n' "$HOME/Applications/chemdoodle.app"
  else
    return 1
  fi
}

maclib::chemdoodle::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "chemdoodle::install: no automated installer; deploy manually"
  return 1
}

maclib::chemdoodle::update() {
  maclib::log::error "chemdoodle::update: no update path"
  return 127
}

maclib::chemdoodle::uninstall() {
  maclib::log::warn "chemdoodle::uninstall: no clean uninstall"
  return 1
}
