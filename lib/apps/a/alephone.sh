#!/usr/bin/env bash
# STATUS: DRAFT — NOT production-ready. Placeholder installer URL (example.com)
# from the bulk vendor-research pass; real vendor data was never filled in.
# Not sourced by lib/maclib.sh. Do not use install()/update() from this module
# until the vendor URL, Team ID and update path are verified and this notice
# is removed. Re-run vendor research against the Installomator label before use.
# shellcheck disable=all
# alephone.sh - "Aleph One" (Installomator label) helpers
#
# Vendor source: Installomator label alephone
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/alephone-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::alephone::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/alephone-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/alephone-1.0.0.dmg"
  printf '%s\n' "$live"
}

maclib::alephone::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/alephone-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%s\n' "$ver"
}

maclib::alephone::is_installed() {
  [[ -d "/Applications/alephone.app" ]] || [[ -d "$HOME/Applications/alephone.app" ]]
}

maclib::alephone::installed_path() {
  if [[ -d "/Applications/alephone.app" ]]; then
    printf '%s\n' "/Applications/alephone.app"
  elif [[ -d "$HOME/Applications/alephone.app" ]]; then
    printf '%s\n' "$HOME/Applications/alephone.app"
  else
    return 1
  fi
}

maclib::alephone::install() {
  # No automated installer documented for "Aleph One" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "alephone::install: no automated installer; deploy manually"
  return 1
}

maclib::alephone::update() {
  maclib::log::error "alephone::update: no update path"
  return 127
}

maclib::alephone::uninstall() {
  maclib::log::warn "alephone::uninstall: no clean uninstall"
  return 1
}
