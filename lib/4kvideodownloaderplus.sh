#!/usr/bin/env bash
# shellcheck disable=all
# 4kvideodownloaderplus.sh - "4K Video Downloader+" (Installomator label) helpers
#
# Vendor source: Installomator label 4kvideodownloaderplus
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/4kvideodownloaderplus-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::4kvideodownloaderplus::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/4kvideodownloaderplus-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/4kvideodownloaderplus-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::4kvideodownloaderplus::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/4kvideodownloaderplus-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::4kvideodownloaderplus::is_installed() {
  [[ -d "/Applications/4kvideodownloaderplus.app" ]] || [[ -d "$HOME/Applications/4kvideodownloaderplus.app" ]]
}

maclib::4kvideodownloaderplus::installed_path() {
  if [[ -d "/Applications/4kvideodownloaderplus.app" ]]; then
    printf '%s\n' "/Applications/4kvideodownloaderplus.app"
  elif [[ -d "$HOME/Applications/4kvideodownloaderplus.app" ]]; then
    printf '%s\n' "$HOME/Applications/4kvideodownloaderplus.app"
  else
    return 1
  fi
}

maclib::4kvideodownloaderplus::install() {
  # No automated installer documented for "4K Video Downloader+" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "4kvideodownloaderplus::install: no automated installer; deploy manually"
  return 1
}

maclib::4kvideodownloaderplus::update() {
  maclib::log::error "4kvideodownloaderplus::update: no update path"
  return 127
}

maclib::4kvideodownloaderplus::uninstall() {
  maclib::log::warn "4kvideodownloaderplus::uninstall: no clean uninstall"
  return 1
}
