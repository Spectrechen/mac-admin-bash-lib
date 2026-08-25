#!/usr/bin/env bash
# shellcheck disable=all
# anastasiysextensionmanager.sh - "ExtensionManager" (Installomator label) helpers
#
# Vendor source: Installomator label anastasiysextensionmanager
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "zip".
# Installer URL: https://example.com/anastasiysextensionmanager-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::anastasiysextensionmanager::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/anastasiysextensionmanager-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/anastasiysextensionmanager-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::anastasiysextensionmanager::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/anastasiysextensionmanager-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::anastasiysextensionmanager::is_installed() {
  [[ -d "/Applications/anastasiysextensionmanager.app" ]] || [[ -d "$HOME/Applications/anastasiysextensionmanager.app" ]]
}

maclib::anastasiysextensionmanager::installed_path() {
  if [[ -d "/Applications/anastasiysextensionmanager.app" ]]; then
    printf '%s\n' "/Applications/anastasiysextensionmanager.app"
  elif [[ -d "$HOME/Applications/anastasiysextensionmanager.app" ]]; then
    printf '%s\n' "$HOME/Applications/anastasiysextensionmanager.app"
  else
    return 1
  fi
}

maclib::anastasiysextensionmanager::install() {
  # No automated installer documented for "ExtensionManager" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "anastasiysextensionmanager::install: no automated installer; deploy manually"
  return 1
}

maclib::anastasiysextensionmanager::update() {
  maclib::log::error "anastasiysextensionmanager::update: no update path"
  return 127
}

maclib::anastasiysextensionmanager::uninstall() {
  maclib::log::warn "anastasiysextensionmanager::uninstall: no clean uninstall"
  return 1
}
