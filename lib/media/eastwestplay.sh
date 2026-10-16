#!/usr/bin/env bash
# shellcheck disable=all
# eastwestplay.sh - Play (Installomator label) helpers
#
# Vendor source: Installomator label eastwestplay from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInZip".
#

maclib::media::eastwestplay::suite_installer_url() {
  # TODO: Add actual download URL for Play
  printf '%s\\n' 'https://example.com/eastwestplay/installer'
}

maclib::media::eastwestplay::latest_version() {
  # TODO: Add version detection for Play
  return 1
}

maclib::media::eastwestplay::is_installed() {
  [[ -d "/Applications/Play.app" ]] || [[ -d "$HOME/Applications/Play.app" ]]
}

maclib::media::eastwestplay::installed_path() {
  if [[ -d "/Applications/Play.app" ]]; then
    printf '%s\\n' "/Applications/Play.app"
  elif [[ -d "$HOME/Applications/Play.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Play.app"
  fi
}

maclib::eastwestplay::install() {
  local url tmp mp app
  url="$(maclib::eastwestplay::suite_installer_url)"
  tmp="$(mktemp -d -t "eastwestplay.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "eastwestplay::install: download failed"
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


maclib::media::eastwestplay::update() {
  # No vendor update path documented for "Play".
  maclib::core::log::error "eastwestplay::update: no update path"
  return 127
}

maclib::media::eastwestplay::uninstall() {
  # No clean uninstall for "Play" (documented constraint).
  maclib::core::log::error "eastwestplay::uninstall: no clean uninstall"
  return 1
}
