#!/usr/bin/env bash
# shellcheck disable=all
# amazoncorretto23jdk.sh - "Amazon Corretto 23 JDK" (Installomator label) helpers
#
# Vendor source: Installomator label amazoncorretto23jdk
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkg".
# Installer URL: https://example.com/amazoncorretto23jdk-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::amazoncorretto23jdk::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/amazoncorretto23jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/amazoncorretto23jdk-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::amazoncorretto23jdk::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/amazoncorretto23jdk-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::amazoncorretto23jdk::is_installed() {
  [[ -d "/Applications/amazoncorretto23jdk.app" ]] || [[ -d "$HOME/Applications/amazoncorretto23jdk.app" ]]
}

maclib::apps::a::amazoncorretto23jdk::installed_path() {
  if [[ -d "/Applications/amazoncorretto23jdk.app" ]]; then
    printf '%s\n' "/Applications/amazoncorretto23jdk.app"
  elif [[ -d "$HOME/Applications/amazoncorretto23jdk.app" ]]; then
    printf '%s\n' "$HOME/Applications/amazoncorretto23jdk.app"
  else
    return 1
  fi
}

maclib::apps::a::amazoncorretto23jdk::install() {
  # No automated installer documented for "Amazon Corretto 23 JDK" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "amazoncorretto23jdk::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::amazoncorretto23jdk::update() {
  maclib::core::log::error "amazoncorretto23jdk::update: no update path"
  return 127
}

maclib::apps::a::amazoncorretto23jdk::uninstall() {
  maclib::core::log::warn "amazoncorretto23jdk::uninstall: no clean uninstall"
  return 1
}
