#!/usr/bin/env bash
# shellcheck disable=all
# arcbrowser.sh - "Arc" (Installomator label) helpers
#
# Vendor source: Installomator label arcbrowser
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (The Browser Company — not signed with Apple Developer ID).
# Installer type: "dmg".
# Installer URL: https://cdn.arc.net/download/mac (redirects to latest Arc DMG).
# Update: Arc updates itself via "Arc > Check for Updates" or auto-update on wake.
# Uninstall: no clean uninstall (documented constraint).
#
# Sources:
#   https://arc.net/download
#   https://resources.arc.net/hc/en-us/articles/19337669022103-Arc-for-macOS
#   https://resources.arc.net/hc/en-us/articles/21489650267031-Update-Arc-for-Desktop

maclib::apps::a::arcbrowser::suite_installer_url() {
  printf '%s\n' "https://cdn.arc.net/download/mac"
}

maclib::apps::a::arcbrowser::latest_version() {
  local html ver
  html="$(curl -fsL "https://resources.arc.net/hc/en-us/articles/20498293324823-Arc-for-macOS-2024-2026-Release-Notes" 2>/dev/null)"
  if [[ "$html" =~ V\.([0-9]+\.[0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%s\n' "$ver"
}

maclib::apps::a::arcbrowser::is_installed() {
  [[ -d "/Applications/Arc.app" ]] || [[ -d "$HOME/Applications/Arc.app" ]]
}

maclib::apps::a::arcbrowser::installed_path() {
  if [[ -d "/Applications/Arc.app" ]]; then
    printf '%s\n' "/Applications/Arc.app"
  elif [[ -d "$HOME/Applications/Arc.app" ]]; then
    printf '%s\n' "$HOME/Applications/Arc.app"
  else
    return 1
  fi
}

maclib::apps::a::arcbrowser::install() {
  local url tmp
  url="$(maclib::apps::a::arcbrowser::suite_installer_url)"
  tmp="$(mktemp -d -t "arcbrowser.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "arcbrowser::install: download failed"
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

maclib::apps::a::arcbrowser::update() {
  # Arc updates itself via in-app "Check for Updates" or auto-update on wake.
  # No manual update path needed — install() overwrites the app bundle.
  maclib::apps::a::arcbrowser::install
}

maclib::apps::a::arcbrowser::uninstall() {
  maclib::core::log::warn "arcbrowser::uninstall: no clean uninstall"
  return 1
}
