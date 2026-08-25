#!/usr/bin/env bash
# shellcheck disable=all
# applenyfonts.sh - "Apple New York Font Collection" (Installomator label) helpers
#
# Vendor source: Installomator label applenyfonts
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/applenyfonts-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::applenyfonts::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/applenyfonts-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/applenyfonts-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::applenyfonts::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/applenyfonts-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::applenyfonts::is_installed() {
  [[ -d "/Applications/applenyfonts.app" ]] || [[ -d "$HOME/Applications/applenyfonts.app" ]]
}

maclib::applenyfonts::installed_path() {
  if [[ -d "/Applications/applenyfonts.app" ]]; then
    printf '%s\n' "/Applications/applenyfonts.app"
  elif [[ -d "$HOME/Applications/applenyfonts.app" ]]; then
    printf '%s\n' "$HOME/Applications/applenyfonts.app"
  else
    return 1
  fi
}

maclib::applenyfonts::install() {
  # No automated installer documented for "Apple New York Font Collection" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "applenyfonts::install: no automated installer; deploy manually"
  return 1
}

maclib::applenyfonts::update() {
  maclib::log::error "applenyfonts::update: no update path"
  return 127
}

maclib::applenyfonts::uninstall() {
  maclib::log::warn "applenyfonts::uninstall: no clean uninstall"
  return 1
}
