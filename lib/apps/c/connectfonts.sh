#!/usr/bin/env bash
# shellcheck disable=all
# connectfonts.sh - Connect Fonts (Installomator label) helpers
#
# Vendor source: Installomator label connectfonts from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/c::connectfonts::suite_installer_url() {
  # TODO: Add actual download URL for Connect Fonts
  printf '%s\\n' 'https://example.com/connectfonts/installer'
}

maclib::apps/c::connectfonts::latest_version() {
  # TODO: Add version detection for Connect Fonts
  return 1
}

maclib::apps/c::connectfonts::is_installed() {
  [[ -d "/Applications/Connect Fonts.app" ]] || [[ -d "$HOME/Applications/Connect Fonts.app" ]]
}

maclib::apps/c::connectfonts::installed_path() {
  if [[ -d "/Applications/Connect Fonts.app" ]]; then
    printf '%s\\n' "/Applications/Connect Fonts.app"
  elif [[ -d "$HOME/Applications/Connect Fonts.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Connect Fonts.app"
  fi
}

maclib::connectfonts::install() {
  local url tmp mp app
  url="$(maclib::connectfonts::suite_installer_url)"
  tmp="$(mktemp -d -t "connectfonts.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "connectfonts::install: download failed"
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


maclib::apps/c::connectfonts::update() {
  # No vendor update path documented for "Connect Fonts".
  maclib::core::log::error "connectfonts::update: no update path"
  return 127
}

maclib::apps/c::connectfonts::uninstall() {
  # No clean uninstall for "Connect Fonts" (documented constraint).
  maclib::core::log::error "connectfonts::uninstall: no clean uninstall"
  return 1
}
