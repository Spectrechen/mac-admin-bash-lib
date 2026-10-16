#!/usr/bin/env bash
# shellcheck disable=all
# adobeacrobatprodc.sh - "Adobe Acrobat Pro DC" (Installomator label) helpers
#
# Vendor source: Installomator label adobeacrobatprodc
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "pkgInDmg".
# Installer URL: https://example.com/adobeacrobatprodc-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::apps::a::adobeacrobatprodc::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/adobeacrobatprodc-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/adobeacrobatprodc-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::apps::a::adobeacrobatprodc::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/adobeacrobatprodc-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::apps::a::adobeacrobatprodc::is_installed() {
  [[ -d "/Applications/adobeacrobatprodc.app" ]] || [[ -d "$HOME/Applications/adobeacrobatprodc.app" ]]
}

maclib::apps::a::adobeacrobatprodc::installed_path() {
  if [[ -d "/Applications/adobeacrobatprodc.app" ]]; then
    printf '%s\n' "/Applications/adobeacrobatprodc.app"
  elif [[ -d "$HOME/Applications/adobeacrobatprodc.app" ]]; then
    printf '%s\n' "$HOME/Applications/adobeacrobatprodc.app"
  else
    return 1
  fi
}

maclib::apps::a::adobeacrobatprodc::install() {
  # No automated installer documented for "Adobe Acrobat Pro DC" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::core::log::error "adobeacrobatprodc::install: no automated installer; deploy manually"
  return 1
}

maclib::apps::a::adobeacrobatprodc::update() {
  maclib::core::log::error "adobeacrobatprodc::update: no update path"
  return 127
}

maclib::apps::a::adobeacrobatprodc::uninstall() {
  maclib::core::log::warn "adobeacrobatprodc::uninstall: no clean uninstall"
  return 1
}
