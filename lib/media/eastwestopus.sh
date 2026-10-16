#!/usr/bin/env bash
# shellcheck disable=all
# eastwestopus.sh - Opus (Installomator label) helpers
#
# Vendor source: Installomator label eastwestopus from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInZip".
#

maclib::media::eastwestopus::suite_installer_url() {
  # TODO: Add actual download URL for Opus
  printf '%s\\n' 'https://example.com/eastwestopus/installer'
}

maclib::media::eastwestopus::latest_version() {
  # TODO: Add version detection for Opus
  return 1
}

maclib::media::eastwestopus::is_installed() {
  [[ -d "/Applications/Opus.app" ]] || [[ -d "$HOME/Applications/Opus.app" ]]
}

maclib::media::eastwestopus::installed_path() {
  if [[ -d "/Applications/Opus.app" ]]; then
    printf '%s\\n' "/Applications/Opus.app"
  elif [[ -d "$HOME/Applications/Opus.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Opus.app"
  fi
}

maclib::eastwestopus::install() {
  local url tmp mp app
  url="$(maclib::eastwestopus::suite_installer_url)"
  tmp="$(mktemp -d -t "eastwestopus.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "eastwestopus::install: download failed"
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


maclib::media::eastwestopus::update() {
  # No vendor update path documented for "Opus".
  maclib::core::log::error "eastwestopus::update: no update path"
  return 127
}

maclib::media::eastwestopus::uninstall() {
  # No clean uninstall for "Opus" (documented constraint).
  maclib::core::log::error "eastwestopus::uninstall: no clean uninstall"
  return 1
}
