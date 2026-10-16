#!/usr/bin/env bash
# shellcheck disable=all
# drawio.sh - draw.io (Installomator label) helpers
#
# Vendor source: Installomator label drawio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/d::drawio::suite_installer_url() {
  # TODO: Add actual download URL for draw.io
  printf '%s\\n' 'https://example.com/drawio/installer'
}

maclib::apps/d::drawio::latest_version() {
  # TODO: Add version detection for draw.io
  return 1
}

maclib::apps/d::drawio::is_installed() {
  [[ -d "/Applications/Draw.Io.app" ]] || [[ -d "$HOME/Applications/Draw.Io.app" ]]
}

maclib::apps/d::drawio::installed_path() {
  if [[ -d "/Applications/Draw.Io.app" ]]; then
    printf '%s\\n' "/Applications/Draw.Io.app"
  elif [[ -d "$HOME/Applications/Draw.Io.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Draw.Io.app"
  fi
}

maclib::drawio::install() {
  local url tmp mp app
  url="$(maclib::drawio::suite_installer_url)"
  tmp="$(mktemp -d -t "drawio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "drawio::install: download failed"
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


maclib::apps/d::drawio::update() {
  # No vendor update path documented for "draw.io".
  maclib::core::log::error "drawio::update: no update path"
  return 127
}

maclib::apps/d::drawio::uninstall() {
  # No clean uninstall for "draw.io" (documented constraint).
  maclib::core::log::error "drawio::uninstall: no clean uninstall"
  return 1
}
