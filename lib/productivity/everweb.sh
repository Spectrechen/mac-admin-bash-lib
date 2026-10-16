#!/usr/bin/env bash
# shellcheck disable=all
# everweb.sh - EverWeb (Installomator label) helpers
#
# Vendor source: Installomator label everweb from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::everweb::suite_installer_url() {
  # TODO: Add actual download URL for EverWeb
  printf '%s\\n' 'https://example.com/everweb/installer'
}

maclib::productivity::everweb::latest_version() {
  # TODO: Add version detection for EverWeb
  return 1
}

maclib::productivity::everweb::is_installed() {
  [[ -d "/Applications/Everweb.app" ]] || [[ -d "$HOME/Applications/Everweb.app" ]]
}

maclib::productivity::everweb::installed_path() {
  if [[ -d "/Applications/Everweb.app" ]]; then
    printf '%s\\n' "/Applications/Everweb.app"
  elif [[ -d "$HOME/Applications/Everweb.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Everweb.app"
  fi
}

maclib::everweb::install() {
  local url tmp mp app
  url="$(maclib::everweb::suite_installer_url)"
  tmp="$(mktemp -d -t "everweb.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "everweb::install: download failed"
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


maclib::productivity::everweb::update() {
  # No vendor update path documented for "EverWeb".
  maclib::core::log::error "everweb::update: no update path"
  return 127
}

maclib::productivity::everweb::uninstall() {
  # No clean uninstall for "EverWeb" (documented constraint).
  maclib::core::log::error "everweb::uninstall: no clean uninstall"
  return 1
}
