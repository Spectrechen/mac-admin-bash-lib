#!/usr/bin/env bash
# shellcheck disable=all
# blitzit.sh - "Blitzit" (Installomator label) helpers
#
# Vendor source: Installomator label blitzit from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "29VYWQJ9TL".
# Installer type: "dmg".
#

maclib::blitzit::suite_installer_url() {
  downloadURLFromGit blitzit-hq desktop-releases
}

maclib::blitzit::latest_version() {
  versionFromGit blitzit-hq desktop-releases
}

maclib::blitzit::is_installed() {
  [[ -d "/Applications/Blitzit.app" ]] || [[ -d "$HOME/Applications/Blitzit.app" ]]
}

maclib::blitzit::installed_path() {
  if [[ -d "/Applications/Blitzit.app" ]]; then
    printf "%s\n" "/Applications/Blitzit.app"
  elif [[ -d "$HOME/Applications/Blitzit.app" ]]; then
    printf "%s\n" "$HOME/Applications/Blitzit.app"
  fi
}

maclib::blitzit::install() {
  local url tmp
  url="$(maclib::blitzit::suite_installer_url)"
  tmp="$(mktemp -d -t "blitzit.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "blitzit::install: download failed"
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

maclib::blitzit::update() {
  # No vendor update path documented for "Blitzit".
  maclib::log::error "blitzit::update: no update path"
  return 127
}

maclib::blitzit::uninstall() {
  # No clean uninstall for "Blitzit" (documented constraint).
  maclib::log::error "blitzit::uninstall: no clean uninstall"
  return 1
}
