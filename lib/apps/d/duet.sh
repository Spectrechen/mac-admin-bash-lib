#!/usr/bin/env bash
# shellcheck disable=all
# duet.sh - duet (Installomator label) helpers
#
# Vendor source: Installomator label duet from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/d::duet::suite_installer_url() {
  # TODO: Add actual download URL for duet
  printf '%s\\n' 'https://example.com/duet/installer'
}

maclib::apps/d::duet::latest_version() {
  # TODO: Add version detection for duet
  return 1
}

maclib::apps/d::duet::is_installed() {
  [[ -d "/Applications/Duet.app" ]] || [[ -d "$HOME/Applications/Duet.app" ]]
}

maclib::apps/d::duet::installed_path() {
  if [[ -d "/Applications/Duet.app" ]]; then
    printf '%s\\n' "/Applications/Duet.app"
  elif [[ -d "$HOME/Applications/Duet.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Duet.app"
  fi
}

maclib::duet::install() {
  local url tmp mp app
  url="$(maclib::duet::suite_installer_url)"
  tmp="$(mktemp -d -t "duet.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "duet::install: download failed"
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


maclib::apps/d::duet::update() {
  # No vendor update path documented for "duet".
  maclib::core::log::error "duet::update: no update path"
  return 127
}

maclib::apps/d::duet::uninstall() {
  # No clean uninstall for "duet" (documented constraint).
  maclib::core::log::error "duet::uninstall: no clean uninstall"
  return 1
}
