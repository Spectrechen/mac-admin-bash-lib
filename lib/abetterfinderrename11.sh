#!/usr/bin/env bash
# shellcheck disable=all
# abetterfinderrename11.sh - "A Better Finder Rename 11" (Installomator label) helpers
#
# Vendor source: Installomator label abetterfinderrename11
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/abetterfinderrename11-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::abetterfinderrename11::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/abetterfinderrename11-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/abetterfinderrename11-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::abetterfinderrename11::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/abetterfinderrename11-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::abetterfinderrename11::is_installed() {
  [[ -d "/Applications/abetterfinderrename11.app" ]] || [[ -d "$HOME/Applications/abetterfinderrename11.app" ]]
}

maclib::abetterfinderrename11::installed_path() {
  if [[ -d "/Applications/abetterfinderrename11.app" ]]; then
    printf '%s\n' "/Applications/abetterfinderrename11.app"
  elif [[ -d "$HOME/Applications/abetterfinderrename11.app" ]]; then
    printf '%s\n' "$HOME/Applications/abetterfinderrename11.app"
  else
    return 1
  fi
}

maclib::abetterfinderrename11::install() {
  # No automated installer documented for "A Better Finder Rename 11" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "abetterfinderrename11::install: no automated installer; deploy manually"
  return 1
}

maclib::abetterfinderrename11::update() {
  maclib::log::error "abetterfinderrename11::update: no update path"
  return 127
}

maclib::abetterfinderrename11::uninstall() {
  maclib::log::warn "abetterfinderrename11::uninstall: no clean uninstall"
  return 1
}
