#!/usr/bin/env bash
# shellcheck disable=all
# dia.sh - Dia (Installomator label) helpers
#
# Vendor source: Installomator label dia from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/d::dia::suite_installer_url() {
  # TODO: Add actual download URL for Dia
  printf '%s\\n' 'https://example.com/dia/installer'
}

maclib::apps/d::dia::latest_version() {
  # TODO: Add version detection for Dia
  return 1
}

maclib::apps/d::dia::is_installed() {
  [[ -d "/Applications/Dia.app" ]] || [[ -d "$HOME/Applications/Dia.app" ]]
}

maclib::apps/d::dia::installed_path() {
  if [[ -d "/Applications/Dia.app" ]]; then
    printf '%s\\n' "/Applications/Dia.app"
  elif [[ -d "$HOME/Applications/Dia.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dia.app"
  fi
}

maclib::dia::install() {
  local url tmp mp app
  url="$(maclib::dia::suite_installer_url)"
  tmp="$(mktemp -d -t "dia.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dia::install: download failed"
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


maclib::apps/d::dia::update() {
  # No vendor update path documented for "Dia".
  maclib::core::log::error "dia::update: no update path"
  return 127
}

maclib::apps/d::dia::uninstall() {
  # No clean uninstall for "Dia" (documented constraint).
  maclib::core::log::error "dia::uninstall: no clean uninstall"
  return 1
}
