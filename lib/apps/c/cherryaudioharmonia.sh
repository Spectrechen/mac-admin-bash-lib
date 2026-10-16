#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioharmonia.sh - "Harmonia" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioharmonia
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (Cherry Audio — verify against vendor).
# Installer type: "dmg".
# Installer URL: https://store.cherryaudio.com/software/harmonia-macos-installer
# Update: Cherry Audio provides updates via their Sync app or in-app updates.
# Uninstall: no clean uninstall (documented constraint).
#
# Sources:
#   https://cherryaudio.com/products/harmonia/download
#   https://store.cherryaudio.com/software/harmonia-macos-installer
#   https://cherryaudio.com/products/downloads

maclib::apps::c::cherryaudioharmonia::suite_installer_url() {
  printf '%s\n' "https://store.cherryaudio.com/software/harmonia-macos-installer"
}

maclib::apps::c::cherryaudioharmonia::latest_version() {
  # No public version API; latest version tracked on store.cherryaudio.com.
  printf '%s\n' "1.0.9"
}

maclib::apps::c::cherryaudioharmonia::is_installed() {
  [[ -d "/Applications/Harmonia.app" ]] || [[ -d "$HOME/Applications/Harmonia.app" ]]
}

maclib::apps::c::cherryaudioharmonia::installed_path() {
  if [[ -d "/Applications/Harmonia.app" ]]; then
    printf '%s\n' "/Applications/Harmonia.app"
  elif [[ -d "$HOME/Applications/Harmonia.app" ]]; then
    printf '%s\n' "$HOME/Applications/Harmonia.app"
  else
    return 1
  fi
}

maclib::apps::c::cherryaudioharmonia::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudioharmonia::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudioharmonia.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  # Cherry Audio requires purchase/license; download may require authentication.
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudioharmonia::install: download failed (may require license)"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::apps::c::cherryaudioharmonia::update() {
  # Cherry Audio updates via Sync app or in-app updates.
  # install() can be re-run for manual update.
  maclib::apps::c::cherryaudioharmonia::install
}

maclib::apps::c::cherryaudioharmonia::uninstall() {
  maclib::core::log::warn "cherryaudioharmonia::uninstall: no clean uninstall"
  return 1
}
