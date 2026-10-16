#!/usr/bin/env bash
# shellcheck disable=all
# abetterfinderattributes7.sh - "A Better Finder Attributes 7" (Installomator label) helpers
#
# Vendor source: Installomator label abetterfinderattributes7
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/abetterfinderattributes7-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::abetterfinderattributes7::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/abetterfinderattributes7-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/abetterfinderattributes7-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::abetterfinderattributes7::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/abetterfinderattributes7-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::abetterfinderattributes7::is_installed() {
  [[ -d "/Applications/abetterfinderattributes7.app" ]] || [[ -d "$HOME/Applications/abetterfinderattributes7.app" ]]
}

maclib::apps::a::abetterfinderattributes7::installed_path() {
  if [[ -d "/Applications/abetterfinderattributes7.app" ]]; then
    printf '%s\n' "/Applications/abetterfinderattributes7.app"
  elif [[ -d "$HOME/Applications/abetterfinderattributes7.app" ]]; then
    printf '%s\n' "$HOME/Applications/abetterfinderattributes7.app"
  else
    return 1
  fi
}

maclib::apps::a::abetterfinderattributes7::install() {
  # No automated installer documented for "A Better Finder Attributes 7" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "abetterfinderattributes7::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::abetterfinderattributes7::update() {
  maclib::core::log::error "abetterfinderattributes7::update: no update path"
  return 127
}

maclib::apps::a::abetterfinderattributes7::uninstall() {
  maclib::core::log::warn "abetterfinderattributes7::uninstall: no clean uninstall"
  return 1
}
