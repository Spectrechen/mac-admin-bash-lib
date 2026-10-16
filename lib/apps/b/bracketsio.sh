#!/usr/bin/env bash
# shellcheck disable=all
# bracketsio.sh - "Brackets" (Installomator label) helpers
#
# Vendor source: Installomator label bracketsio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "JQ525L2MZD".
# Installer type: "dmg".
#

maclib::apps::b::bracketsio::suite_installer_url() {
  downloadURLFromGit brackets-cont brackets
}

maclib::apps::b::bracketsio::latest_version() {
  versionFromGit brackets-cont brackets
}

maclib::apps::b::bracketsio::is_installed() {
  [[ -d "/Applications/Brackets.app" ]] || [[ -d "$HOME/Applications/Brackets.app" ]]
}

maclib::apps::b::bracketsio::installed_path() {
  if [[ -d "/Applications/Brackets.app" ]]; then
    printf "%s\n" "/Applications/Brackets.app"
  elif [[ -d "$HOME/Applications/Brackets.app" ]]; then
    printf "%s\n" "$HOME/Applications/Brackets.app"
  fi
}

maclib::apps::b::bracketsio::install() {
  local url tmp
  url="$(maclib::apps::b::bracketsio::suite_installer_url)"
  tmp="$(mktemp -d -t "bracketsio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "bracketsio::install: download failed"
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

maclib::apps::b::bracketsio::update() {
  # No vendor update path documented for "Brackets".
  maclib::core::log::error "bracketsio::update: no update path"
  return 127
}

maclib::apps::b::bracketsio::uninstall() {
  # No clean uninstall for "Brackets" (documented constraint).
  maclib::core::log::error "bracketsio::uninstall: no clean uninstall"
  return 1
}
