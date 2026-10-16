#!/usr/bin/env bash
# shellcheck disable=all
# blitzit.sh - "Blitzit" (Installomator label) helpers
#
# Vendor source: Installomator label blitzit from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "29VYWQJ9TL".
# Installer type: "dmg".
#

maclib::apps::b::blitzit::suite_installer_url() {
  downloadURLFromGit blitzit-hq desktop-releases
}

maclib::apps::b::blitzit::latest_version() {
  versionFromGit blitzit-hq desktop-releases
}

maclib::apps::b::blitzit::is_installed() {
  [[ -d "/Applications/Blitzit.app" ]] || [[ -d "$HOME/Applications/Blitzit.app" ]]
}

maclib::apps::b::blitzit::installed_path() {
  if [[ -d "/Applications/Blitzit.app" ]]; then
    printf "%s\n" "/Applications/Blitzit.app"
  elif [[ -d "$HOME/Applications/Blitzit.app" ]]; then
    printf "%s\n" "$HOME/Applications/Blitzit.app"
  fi
}

maclib::apps::b::blitzit::install() {
  local url tmp
  url="$(maclib::apps::b::blitzit::suite_installer_url)"
  tmp="$(mktemp -d -t "blitzit.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "blitzit::install: download failed"
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

maclib::apps::b::blitzit::update() {
  # No vendor update path documented for "Blitzit".
  maclib::core::log::error "blitzit::update: no update path"
  return 127
}

maclib::apps::b::blitzit::uninstall() {
  # No clean uninstall for "Blitzit" (documented constraint).
  maclib::core::log::error "blitzit::uninstall: no clean uninstall"
  return 1
}
