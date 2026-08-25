#!/usr/bin/env bash
# shellcheck disable=all
# amazoncorretto25jdk.sh - "Amazon Corretto 25 JDK" (Installomator label) helpers
#
# Vendor source: Installomator label amazoncorretto25jdk
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkg".
# Installer URL: https://example.com/amazoncorretto25jdk-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::amazoncorretto25jdk::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/amazoncorretto25jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/amazoncorretto25jdk-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::amazoncorretto25jdk::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/amazoncorretto25jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::amazoncorretto25jdk::is_installed() {
  [[ -d "/Applications/amazoncorretto25jdk.app" ]] || [[ -d "$HOME/Applications/amazoncorretto25jdk.app" ]]
}

maclib::amazoncorretto25jdk::installed_path() {
  if [[ -d "/Applications/amazoncorretto25jdk.app" ]]; then
    printf '%s\n' "/Applications/amazoncorretto25jdk.app"
  elif [[ -d "$HOME/Applications/amazoncorretto25jdk.app" ]]; then
    printf '%s\n' "$HOME/Applications/amazoncorretto25jdk.app"
  else
    return 1
  fi
}

maclib::amazoncorretto25jdk::install() {
  # No automated installer documented for "Amazon Corretto 25 JDK" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "amazoncorretto25jdk::install: no automated installer; deploy manually"
  return 1
}

maclib::amazoncorretto25jdk::update() {
  maclib::log::error "amazoncorretto25jdk::update: no update path"
  return 127
}

maclib::amazoncorretto25jdk::uninstall() {
  maclib::log::warn "amazoncorretto25jdk::uninstall: no clean uninstall"
  return 1
}
