#!/usr/bin/env bash
# shellcheck disable=all
# caffeine.sh - "Caffeine" (Installomator label) helpers
#
# Vendor source: Installomator label caffeine from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "YD6LEYT6WZ".
# Installer type: "dmg".
#

maclib::caffeine::suite_installer_url() {
  downloadURLFromGit IntelliScape caffeine
}

maclib::caffeine::latest_version() {
  versionFromGit IntelliScape caffeine
}

maclib::caffeine::is_installed() {
  [[ -d "/Applications/Caffeine.app" ]] || [[ -d "$HOME/Applications/Caffeine.app" ]]
}

maclib::caffeine::installed_path() {
  if [[ -d "/Applications/Caffeine.app" ]]; then
    printf "%s\n" "/Applications/Caffeine.app"
  elif [[ -d "$HOME/Applications/Caffeine.app" ]]; then
    printf "%s\n" "$HOME/Applications/Caffeine.app"
  fi
}

maclib::caffeine::install() {
  local url tmp
  url="$(maclib::caffeine::suite_installer_url)"
  tmp="$(mktemp -d -t "caffeine.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "caffeine::install: download failed"
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

maclib::caffeine::update() {
  # No vendor update path documented for "Caffeine".
  maclib::log::error "caffeine::update: no update path"
  return 127
}

maclib::caffeine::uninstall() {
  # No clean uninstall for "Caffeine" (documented constraint).
  maclib::log::error "caffeine::uninstall: no clean uninstall"
  return 1
}
