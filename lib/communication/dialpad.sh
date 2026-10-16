#!/usr/bin/env bash
# shellcheck disable=all
# dialpad.sh - Dialpad (Installomator label) helpers
#
# Vendor source: Installomator label dialpad from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::communication::dialpad::suite_installer_url() {
  # TODO: Add actual download URL for Dialpad
  printf '%s\\n' 'https://example.com/dialpad/installer'
}

maclib::communication::dialpad::latest_version() {
  # TODO: Add version detection for Dialpad
  return 1
}

maclib::communication::dialpad::is_installed() {
  [[ -d "/Applications/Dialpad.app" ]] || [[ -d "$HOME/Applications/Dialpad.app" ]]
}

maclib::communication::dialpad::installed_path() {
  if [[ -d "/Applications/Dialpad.app" ]]; then
    printf '%s\\n' "/Applications/Dialpad.app"
  elif [[ -d "$HOME/Applications/Dialpad.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dialpad.app"
  fi
}

maclib::dialpad::install() {
  local url tmp mp app
  url="$(maclib::dialpad::suite_installer_url)"
  tmp="$(mktemp -d -t "dialpad.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dialpad::install: download failed"
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


maclib::communication::dialpad::update() {
  # No vendor update path documented for "Dialpad".
  maclib::core::log::error "dialpad::update: no update path"
  return 127
}

maclib::communication::dialpad::uninstall() {
  # No clean uninstall for "Dialpad" (documented constraint).
  maclib::core::log::error "dialpad::uninstall: no clean uninstall"
  return 1
}
