#!/usr/bin/env bash
# shellcheck disable=all
# eul.sh - eul (Installomator label) helpers
#
# Vendor source: Installomator label eul from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::apps/e::eul::suite_installer_url() {
  # TODO: Add actual download URL for eul
  printf '%s\\n' 'https://example.com/eul/installer'
}

maclib::apps/e::eul::latest_version() {
  # TODO: Add version detection for eul
  return 1
}

maclib::apps/e::eul::is_installed() {
  [[ -d "/Applications/Eul.app" ]] || [[ -d "$HOME/Applications/Eul.app" ]]
}

maclib::apps/e::eul::installed_path() {
  if [[ -d "/Applications/Eul.app" ]]; then
    printf '%s\\n' "/Applications/Eul.app"
  elif [[ -d "$HOME/Applications/Eul.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Eul.app"
  fi
}

maclib::eul::install() {
  local url tmp
  url="$(maclib::eul::suite_installer_url)"
  tmp="$(mktemp -d -t "eul.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "eul::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}


maclib::apps/e::eul::update() {
  # No vendor update path documented for "eul".
  maclib::core::log::error "eul::update: no update path"
  return 127
}

maclib::apps/e::eul::uninstall() {
  # No clean uninstall for "eul" (documented constraint).
  maclib::core::log::error "eul::uninstall: no clean uninstall"
  return 1
}
