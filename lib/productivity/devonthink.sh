#!/usr/bin/env bash
# shellcheck disable=all
# devonthink.sh - DEVONthink (Installomator label) helpers
#
# Vendor source: Installomator label devonthink from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "appInDmgInZip".
#

maclib::productivity::devonthink::suite_installer_url() {
  # TODO: Add actual download URL for DEVONthink
  printf '%s\\n' 'https://example.com/devonthink/installer'
}

maclib::productivity::devonthink::latest_version() {
  # TODO: Add version detection for DEVONthink
  return 1
}

maclib::productivity::devonthink::is_installed() {
  [[ -d "/Applications/Devonthink.app" ]] || [[ -d "$HOME/Applications/Devonthink.app" ]]
}

maclib::productivity::devonthink::installed_path() {
  if [[ -d "/Applications/Devonthink.app" ]]; then
    printf '%s\\n' "/Applications/Devonthink.app"
  elif [[ -d "$HOME/Applications/Devonthink.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Devonthink.app"
  fi
}

maclib::devonthink::install() {
  local url tmp mp app
  url="$(maclib::devonthink::suite_installer_url)"
  tmp="$(mktemp -d -t "devonthink.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "devonthink::install: download failed"
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


maclib::productivity::devonthink::update() {
  # No vendor update path documented for "DEVONthink".
  maclib::core::log::error "devonthink::update: no update path"
  return 127
}

maclib::productivity::devonthink::uninstall() {
  # No clean uninstall for "DEVONthink" (documented constraint).
  maclib::core::log::error "devonthink::uninstall: no clean uninstall"
  return 1
}
