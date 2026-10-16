#!/usr/bin/env bash
# shellcheck disable=all
# deskpad.sh - DeskPad (Installomator label) helpers
#
# Vendor source: Installomator label deskpad from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::productivity::deskpad::suite_installer_url() {
  # TODO: Add actual download URL for DeskPad
  printf '%s\\n' 'https://example.com/deskpad/installer'
}

maclib::productivity::deskpad::latest_version() {
  # TODO: Add version detection for DeskPad
  return 1
}

maclib::productivity::deskpad::is_installed() {
  [[ -d "/Applications/Deskpad.app" ]] || [[ -d "$HOME/Applications/Deskpad.app" ]]
}

maclib::productivity::deskpad::installed_path() {
  if [[ -d "/Applications/Deskpad.app" ]]; then
    printf '%s\\n' "/Applications/Deskpad.app"
  elif [[ -d "$HOME/Applications/Deskpad.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Deskpad.app"
  fi
}

maclib::deskpad::install() {
  local url tmp
  url="$(maclib::deskpad::suite_installer_url)"
  tmp="$(mktemp -d -t "deskpad.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "deskpad::install: download failed"
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


maclib::productivity::deskpad::update() {
  # No vendor update path documented for "DeskPad".
  maclib::core::log::error "deskpad::update: no update path"
  return 127
}

maclib::productivity::deskpad::uninstall() {
  # No clean uninstall for "DeskPad" (documented constraint).
  maclib::core::log::error "deskpad::uninstall: no clean uninstall"
  return 1
}
