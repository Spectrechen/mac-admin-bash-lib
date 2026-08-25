#!/usr/bin/env bash
# shellcheck disable=all
# acroniscyberprotectconnectagent.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label acroniscyberprotectconnectagent
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/acroniscyberprotectconnectagent-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::acroniscyberprotectconnectagent::suite_installer_url() {
  printf '%s\n' "https://example.com/acroniscyberprotectconnectagent-1.0.0.dmg"
}

maclib::acroniscyberprotectconnectagent::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::acroniscyberprotectconnectagent::is_installed() {
  [[ -d "/Applications/acroniscyberprotectconnectagent.app" ]] || [[ -d "$HOME/Applications/acroniscyberprotectconnectagent.app" ]]
}

maclib::acroniscyberprotectconnectagent::installed_path() {
  if [[ -d "/Applications/acroniscyberprotectconnectagent.app" ]]; then
    printf '%s\n' "/Applications/acroniscyberprotectconnectagent.app"
  elif [[ -d "$HOME/Applications/acroniscyberprotectconnectagent.app" ]]; then
    printf '%s\n' "$HOME/Applications/acroniscyberprotectconnectagent.app"
  else
    return 1
  fi
}

maclib::acroniscyberprotectconnectagent::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "acroniscyberprotectconnectagent::install: no automated installer; deploy manually"
  return 1
}

maclib::acroniscyberprotectconnectagent::update() {
  maclib::log::error "acroniscyberprotectconnectagent::update: no update path"
  return 127
}

maclib::acroniscyberprotectconnectagent::uninstall() {
  maclib::log::warn "acroniscyberprotectconnectagent::uninstall: no clean uninstall"
  return 1
}
