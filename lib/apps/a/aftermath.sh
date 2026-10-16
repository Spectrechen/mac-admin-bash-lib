#!/usr/bin/env bash
# shellcheck disable=all
# aftermath.sh - "Aftermath" (Installomator label) helpers
#
# Vendor source: Installomator label aftermath
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkg".
# Installer URL: https://example.com/aftermath-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::aftermath::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/aftermath-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/aftermath-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::aftermath::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/aftermath-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::aftermath::is_installed() {
  [[ -d "/Applications/aftermath.app" ]] || [[ -d "$HOME/Applications/aftermath.app" ]]
}

maclib::apps::a::aftermath::installed_path() {
  if [[ -d "/Applications/aftermath.app" ]]; then
    printf '%s\n' "/Applications/aftermath.app"
  elif [[ -d "$HOME/Applications/aftermath.app" ]]; then
    printf '%s\n' "$HOME/Applications/aftermath.app"
  else
    return 1
  fi
}

maclib::apps::a::aftermath::install() {
  # No automated installer documented for "Aftermath" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "aftermath::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::aftermath::update() {
  maclib::core::log::error "aftermath::update: no update path"
  return 127
}

maclib::apps::a::aftermath::uninstall() {
  maclib::core::log::warn "aftermath::uninstall: no clean uninstall"
  return 1
}
