#!/usr/bin/env bash
# shellcheck disable=all
# amazoncorretto21jdk.sh - "Amazon Corretto 21 JDK" (Installomator label) helpers
#
# Vendor source: Installomator label amazoncorretto21jdk
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkg".
# Installer URL: https://example.com/amazoncorretto21jdk-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::amazoncorretto21jdk::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/amazoncorretto21jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/amazoncorretto21jdk-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::amazoncorretto21jdk::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/amazoncorretto21jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::amazoncorretto21jdk::is_installed() {
  [[ -d "/Applications/amazoncorretto21jdk.app" ]] || [[ -d "$HOME/Applications/amazoncorretto21jdk.app" ]]
}

maclib::amazoncorretto21jdk::installed_path() {
  if [[ -d "/Applications/amazoncorretto21jdk.app" ]]; then
    printf '%s\n' "/Applications/amazoncorretto21jdk.app"
  elif [[ -d "$HOME/Applications/amazoncorretto21jdk.app" ]]; then
    printf '%s\n' "$HOME/Applications/amazoncorretto21jdk.app"
  else
    return 1
  fi
}

maclib::amazoncorretto21jdk::install() {
  # No automated installer documented for "Amazon Corretto 21 JDK" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "amazoncorretto21jdk::install: no automated installer; deploy manually"
  return 1
}

maclib::amazoncorretto21jdk::update() {
  maclib::log::error "amazoncorretto21jdk::update: no update path"
  return 127
}

maclib::amazoncorretto21jdk::uninstall() {
  maclib::log::warn "amazoncorretto21jdk::uninstall: no clean uninstall"
  return 1
}
