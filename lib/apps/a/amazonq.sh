#!/usr/bin/env bash
# shellcheck disable=all
# amazonq.sh - "Amazon Q" (Installomator label) helpers
#
# Vendor source: Installomator label amazonq
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/amazonq-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::amazonq::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/amazonq-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/amazonq-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::amazonq::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/amazonq-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::amazonq::is_installed() {
  [[ -d "/Applications/amazonq.app" ]] || [[ -d "$HOME/Applications/amazonq.app" ]]
}

maclib::apps::a::amazonq::installed_path() {
  if [[ -d "/Applications/amazonq.app" ]]; then
    printf '%s\n' "/Applications/amazonq.app"
  elif [[ -d "$HOME/Applications/amazonq.app" ]]; then
    printf '%s\n' "$HOME/Applications/amazonq.app"
  else
    return 1
  fi
}

maclib::apps::a::amazonq::install() {
  # No automated installer documented for "Amazon Q" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "amazonq::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::amazonq::update() {
  maclib::core::log::error "amazonq::update: no update path"
  return 127
}

maclib::apps::a::amazonq::uninstall() {
  maclib::core::log::warn "amazonq::uninstall: no clean uninstall"
  return 1
}
