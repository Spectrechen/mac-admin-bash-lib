#!/usr/bin/env bash
# STATUS: DRAFT — NOT production-ready. Placeholder installer URL (example.com)
# from the bulk vendor-research pass; real vendor data was never filled in.
# Not sourced by lib/maclib.sh. Do not use install()/update() from this module
# until the vendor URL, Team ID and update path are verified and this notice
# is removed. Re-run vendor research against the Installomator label before use.
# shellcheck disable=all
# antconc.sh - "AntConc" (Installomator label) helpers
#
# Vendor source: Installomator label antconc
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/antconc-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::antconc::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/antconc-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/antconc-1.0.0.dmg"
  printf '%s\n' "$live"
}

maclib::antconc::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/antconc-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%s\n' "$ver"
}

maclib::antconc::is_installed() {
  [[ -d "/Applications/antconc.app" ]] || [[ -d "$HOME/Applications/antconc.app" ]]
}

maclib::antconc::installed_path() {
  if [[ -d "/Applications/antconc.app" ]]; then
    printf '%s\n' "/Applications/antconc.app"
  elif [[ -d "$HOME/Applications/antconc.app" ]]; then
    printf '%s\n' "$HOME/Applications/antconc.app"
  else
    return 1
  fi
}

maclib::antconc::install() {
  # No automated installer documented for "AntConc" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "antconc::install: no automated installer; deploy manually"
  return 1
}

maclib::antconc::update() {
  maclib::log::error "antconc::update: no update path"
  return 127
}

maclib::antconc::uninstall() {
  maclib::log::warn "antconc::uninstall: no clean uninstall"
  return 1
}
