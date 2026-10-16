#!/usr/bin/env bash
# shellcheck disable=all
# closeio.sh - Close.io (Installomator label) helpers
#
# Vendor source: Installomator label closeio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::closeio::suite_installer_url() {
  # TODO: Add actual download URL for Close.io
  printf '%s\\n' 'https://example.com/closeio/installer'
}

maclib::productivity::closeio::latest_version() {
  # TODO: Add version detection for Close.io
  return 1
}

maclib::productivity::closeio::is_installed() {
  [[ -d "/Applications/Close.Io.app" ]] || [[ -d "$HOME/Applications/Close.Io.app" ]]
}

maclib::productivity::closeio::installed_path() {
  if [[ -d "/Applications/Close.Io.app" ]]; then
    printf '%s\\n' "/Applications/Close.Io.app"
  elif [[ -d "$HOME/Applications/Close.Io.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Close.Io.app"
  fi
}

maclib::closeio::install() {
  local url tmp mp app
  url="$(maclib::closeio::suite_installer_url)"
  tmp="$(mktemp -d -t "closeio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "closeio::install: download failed"
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


maclib::productivity::closeio::update() {
  # No vendor update path documented for "Close.io".
  maclib::core::log::error "closeio::update: no update path"
  return 127
}

maclib::productivity::closeio::uninstall() {
  # No clean uninstall for "Close.io" (documented constraint).
  maclib::core::log::error "closeio::uninstall: no clean uninstall"
  return 1
}
