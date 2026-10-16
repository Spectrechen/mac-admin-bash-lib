#!/usr/bin/env bash
# shellcheck disable=all
# abletonlive12standard.sh - "Ableton Live 12 Standard" (Installomator label) helpers
#
# Vendor source: Installomator label abletonlive12standard
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/abletonlive12standard-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::abletonlive12standard::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/abletonlive12standard-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/abletonlive12standard-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::abletonlive12standard::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/abletonlive12standard-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::abletonlive12standard::is_installed() {
  [[ -d "/Applications/abletonlive12standard.app" ]] || [[ -d "$HOME/Applications/abletonlive12standard.app" ]]
}

maclib::apps::a::abletonlive12standard::installed_path() {
  if [[ -d "/Applications/abletonlive12standard.app" ]]; then
    printf '%s\n' "/Applications/abletonlive12standard.app"
  elif [[ -d "$HOME/Applications/abletonlive12standard.app" ]]; then
    printf '%s\n' "$HOME/Applications/abletonlive12standard.app"
  else
    return 1
  fi
}

maclib::apps::a::abletonlive12standard::install() {
  # No automated installer documented for "Ableton Live 12 Standard" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "abletonlive12standard::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::abletonlive12standard::update() {
  maclib::core::log::error "abletonlive12standard::update: no update path"
  return 127
}

maclib::apps::a::abletonlive12standard::uninstall() {
  maclib::core::log::warn "abletonlive12standard::uninstall: no clean uninstall"
  return 1
}
