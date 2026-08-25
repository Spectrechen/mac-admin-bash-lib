#!/usr/bin/env bash
# shellcheck disable=all
# applesfmono.sh - "San Francisco Mono" (Installomator label) helpers
#
# Vendor source: Installomator label applesfmono
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/applesfmono-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::applesfmono::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/applesfmono-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/applesfmono-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::applesfmono::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/applesfmono-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::applesfmono::is_installed() {
  [[ -d "/Applications/applesfmono.app" ]] || [[ -d "$HOME/Applications/applesfmono.app" ]]
}

maclib::applesfmono::installed_path() {
  if [[ -d "/Applications/applesfmono.app" ]]; then
    printf '%s\n' "/Applications/applesfmono.app"
  elif [[ -d "$HOME/Applications/applesfmono.app" ]]; then
    printf '%s\n' "$HOME/Applications/applesfmono.app"
  else
    return 1
  fi
}

maclib::applesfmono::install() {
  # No automated installer documented for "San Francisco Mono" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "applesfmono::install: no automated installer; deploy manually"
  return 1
}

maclib::applesfmono::update() {
  maclib::log::error "applesfmono::update: no update path"
  return 127
}

maclib::applesfmono::uninstall() {
  maclib::log::warn "applesfmono::uninstall: no clean uninstall"
  return 1
}
