#!/usr/bin/env bash
# shellcheck disable=all
# exocharts.sh - Exocharts (Installomator label) helpers
#
# Vendor source: Installomator label exocharts from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::media::exocharts::suite_installer_url() {
  # TODO: Add actual download URL for Exocharts
  printf '%s\\n' 'https://example.com/exocharts/installer'
}

maclib::media::exocharts::latest_version() {
  # TODO: Add version detection for Exocharts
  return 1
}

maclib::media::exocharts::is_installed() {
  [[ -d "/Applications/Exocharts.app" ]] || [[ -d "$HOME/Applications/Exocharts.app" ]]
}

maclib::media::exocharts::installed_path() {
  if [[ -d "/Applications/Exocharts.app" ]]; then
    printf '%s\\n' "/Applications/Exocharts.app"
  elif [[ -d "$HOME/Applications/Exocharts.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Exocharts.app"
  fi
}

maclib::exocharts::install() {
  local url tmp mp app
  url="$(maclib::exocharts::suite_installer_url)"
  tmp="$(mktemp -d -t "exocharts.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "exocharts::install: download failed"
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


maclib::media::exocharts::update() {
  # No vendor update path documented for "Exocharts".
  maclib::core::log::error "exocharts::update: no update path"
  return 127
}

maclib::media::exocharts::uninstall() {
  # No clean uninstall for "Exocharts" (documented constraint).
  maclib::core::log::error "exocharts::uninstall: no clean uninstall"
  return 1
}
