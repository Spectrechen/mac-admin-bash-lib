#!/usr/bin/env bash
# shellcheck disable=all
# altserver.sh - "AltServer" (Installomator label) helpers
#
# Vendor source: Installomator label altserver
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "zip".
# Installer URL: https://example.com/altserver-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::altserver::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/altserver-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/altserver-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::altserver::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/altserver-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::altserver::is_installed() {
  [[ -d "/Applications/altserver.app" ]] || [[ -d "$HOME/Applications/altserver.app" ]]
}

maclib::apps::a::altserver::installed_path() {
  if [[ -d "/Applications/altserver.app" ]]; then
    printf '%s\n' "/Applications/altserver.app"
  elif [[ -d "$HOME/Applications/altserver.app" ]]; then
    printf '%s\n' "$HOME/Applications/altserver.app"
  else
    return 1
  fi
}

maclib::apps::a::altserver::install() {
  # No automated installer documented for "AltServer" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "altserver::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::altserver::update() {
  maclib::core::log::error "altserver::update: no update path"
  return 127
}

maclib::apps::a::altserver::uninstall() {
  maclib::core::log::warn "altserver::uninstall: no clean uninstall"
  return 1
}
