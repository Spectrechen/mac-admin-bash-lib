#!/usr/bin/env bash
# shellcheck disable=all
# applesfsymbols.sh - "None" (Installomator label) helpers
#
# Vendor source: Installomator label applesfsymbols
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "None".
# Installer URL: https://example.com/applesfsymbols-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::applesfsymbols::suite_installer_url() {
  printf '%s\n' "https://example.com/applesfsymbols-1.0.0.dmg"
}

maclib::apps::a::applesfsymbols::latest_version() {
  printf '%%s\n' "1.0.0"
}

maclib::apps::a::applesfsymbols::is_installed() {
  [[ -d "/Applications/applesfsymbols.app" ]] || [[ -d "$HOME/Applications/applesfsymbols.app" ]]
}

maclib::apps::a::applesfsymbols::installed_path() {
  if [[ -d "/Applications/applesfsymbols.app" ]]; then
    printf '%s\n' "/Applications/applesfsymbols.app"
  elif [[ -d "$HOME/Applications/applesfsymbols.app" ]]; then
    printf '%s\n' "$HOME/Applications/applesfsymbols.app"
  else
    return 1
  fi
}

maclib::apps::a::applesfsymbols::install() {
  # No automated installer documented for "None" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "applesfsymbols::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::applesfsymbols::update() {
  maclib::core::log::error "applesfsymbols::update: no update path"
  return 127
}

maclib::apps::a::applesfsymbols::uninstall() {
  maclib::core::log::warn "applesfsymbols::uninstall: no clean uninstall"
  return 1
}
