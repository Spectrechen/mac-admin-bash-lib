#!/usr/bin/env bash
# shellcheck disable=all
# duckduckgo.sh - DuckDuckGo (Installomator label) helpers
#
# Vendor source: Installomator label duckduckgo from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::browsers::duckduckgo::suite_installer_url() {
  # TODO: Add actual download URL for DuckDuckGo
  printf '%s\\n' 'https://example.com/duckduckgo/installer'
}

maclib::browsers::duckduckgo::latest_version() {
  # TODO: Add version detection for DuckDuckGo
  return 1
}

maclib::browsers::duckduckgo::is_installed() {
  [[ -d "/Applications/Duckduckgo.app" ]] || [[ -d "$HOME/Applications/Duckduckgo.app" ]]
}

maclib::browsers::duckduckgo::installed_path() {
  if [[ -d "/Applications/Duckduckgo.app" ]]; then
    printf '%s\\n' "/Applications/Duckduckgo.app"
  elif [[ -d "$HOME/Applications/Duckduckgo.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Duckduckgo.app"
  fi
}

maclib::duckduckgo::install() {
  local url tmp mp app
  url="$(maclib::duckduckgo::suite_installer_url)"
  tmp="$(mktemp -d -t "duckduckgo.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "duckduckgo::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::browsers::duckduckgo::update() {
  # No vendor update path documented for "DuckDuckGo".
  maclib::core::log::error "duckduckgo::update: no update path"
  return 127
}

maclib::browsers::duckduckgo::uninstall() {
  # No clean uninstall for "DuckDuckGo" (documented constraint).
  maclib::core::log::error "duckduckgo::uninstall: no clean uninstall"
  return 1
}
