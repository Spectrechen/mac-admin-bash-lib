#!/usr/bin/env bash
# shellcheck disable=all
# abletonlive12trial.sh - "Ableton Live 12 Trial" (Installomator label) helpers
#
# Vendor source: Installomator label abletonlive12trial
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/abletonlive12trial-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::abletonlive12trial::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/abletonlive12trial-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/abletonlive12trial-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::abletonlive12trial::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/abletonlive12trial-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::abletonlive12trial::is_installed() {
  [[ -d "/Applications/abletonlive12trial.app" ]] || [[ -d "$HOME/Applications/abletonlive12trial.app" ]]
}

maclib::abletonlive12trial::installed_path() {
  if [[ -d "/Applications/abletonlive12trial.app" ]]; then
    printf '%s\n' "/Applications/abletonlive12trial.app"
  elif [[ -d "$HOME/Applications/abletonlive12trial.app" ]]; then
    printf '%s\n' "$HOME/Applications/abletonlive12trial.app"
  else
    return 1
  fi
}

maclib::abletonlive12trial::install() {
  # No automated installer documented for "Ableton Live 12 Trial" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "abletonlive12trial::install: no automated installer; deploy manually"
  return 1
}

maclib::abletonlive12trial::update() {
  maclib::log::error "abletonlive12trial::update: no update path"
  return 127
}

maclib::abletonlive12trial::uninstall() {
  maclib::log::warn "abletonlive12trial::uninstall: no clean uninstall"
  return 1
}
