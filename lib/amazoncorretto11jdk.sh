#!/usr/bin/env bash
# shellcheck disable=all
# amazoncorretto11jdk.sh - "Amazon Corretto 11 JDK" (Installomator label) helpers
#
# Vendor source: Installomator label amazoncorretto11jdk
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkg".
# Installer URL: https://example.com/amazoncorretto11jdk-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::amazoncorretto11jdk::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/amazoncorretto11jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/amazoncorretto11jdk-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::amazoncorretto11jdk::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/amazoncorretto11jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::amazoncorretto11jdk::is_installed() {
  [[ -d "/Applications/amazoncorretto11jdk.app" ]] || [[ -d "$HOME/Applications/amazoncorretto11jdk.app" ]]
}

maclib::amazoncorretto11jdk::installed_path() {
  if [[ -d "/Applications/amazoncorretto11jdk.app" ]]; then
    printf '%s\n' "/Applications/amazoncorretto11jdk.app"
  elif [[ -d "$HOME/Applications/amazoncorretto11jdk.app" ]]; then
    printf '%s\n' "$HOME/Applications/amazoncorretto11jdk.app"
  else
    return 1
  fi
}

maclib::amazoncorretto11jdk::install() {
  # No automated installer documented for "Amazon Corretto 11 JDK" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "amazoncorretto11jdk::install: no automated installer; deploy manually"
  return 1
}

maclib::amazoncorretto11jdk::update() {
  maclib::log::error "amazoncorretto11jdk::update: no update path"
  return 127
}

maclib::amazoncorretto11jdk::uninstall() {
  maclib::log::warn "amazoncorretto11jdk::uninstall: no clean uninstall"
  return 1
}
