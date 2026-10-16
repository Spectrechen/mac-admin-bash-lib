#!/usr/bin/env bash
# shellcheck disable=all
# abstract.sh - "Abstract" (Installomator label) helpers
#
# Vendor source: Installomator label abstract
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "zip".
# Installer URL: https://example.com/abstract-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::abstract::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/abstract-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/abstract-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::abstract::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/abstract-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::abstract::is_installed() {
  [[ -d "/Applications/abstract.app" ]] || [[ -d "$HOME/Applications/abstract.app" ]]
}

maclib::apps::a::abstract::installed_path() {
  if [[ -d "/Applications/abstract.app" ]]; then
    printf '%s\n' "/Applications/abstract.app"
  elif [[ -d "$HOME/Applications/abstract.app" ]]; then
    printf '%s\n' "$HOME/Applications/abstract.app"
  else
    return 1
  fi
}

maclib::apps::a::abstract::install() {
  # No automated installer documented for "Abstract" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "abstract::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::abstract::update() {
  maclib::core::log::error "abstract::update: no update path"
  return 127
}

maclib::apps::a::abstract::uninstall() {
  maclib::core::log::warn "abstract::uninstall: no clean uninstall"
  return 1
}
