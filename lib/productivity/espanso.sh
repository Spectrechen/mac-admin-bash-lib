#!/usr/bin/env bash
# shellcheck disable=all
# espanso.sh - Espanso (Installomator label) helpers
#
# Vendor source: Installomator label espanso from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "appInDmgInZip".
#

maclib::productivity::espanso::suite_installer_url() {
  # TODO: Add actual download URL for Espanso
  printf '%s\\n' 'https://example.com/espanso/installer'
}

maclib::productivity::espanso::latest_version() {
  # TODO: Add version detection for Espanso
  return 1
}

maclib::productivity::espanso::is_installed() {
  [[ -d "/Applications/Espanso.app" ]] || [[ -d "$HOME/Applications/Espanso.app" ]]
}

maclib::productivity::espanso::installed_path() {
  if [[ -d "/Applications/Espanso.app" ]]; then
    printf '%s\\n' "/Applications/Espanso.app"
  elif [[ -d "$HOME/Applications/Espanso.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Espanso.app"
  fi
}

maclib::espanso::install() {
  local url tmp mp app
  url="$(maclib::espanso::suite_installer_url)"
  tmp="$(mktemp -d -t "espanso.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "espanso::install: download failed"
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


maclib::productivity::espanso::update() {
  # No vendor update path documented for "Espanso".
  maclib::core::log::error "espanso::update: no update path"
  return 127
}

maclib::productivity::espanso::uninstall() {
  # No clean uninstall for "Espanso" (documented constraint).
  maclib::core::log::error "espanso::uninstall: no clean uninstall"
  return 1
}
