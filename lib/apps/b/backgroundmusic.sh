#!/usr/bin/env bash
# shellcheck disable=all
# backgroundmusic.sh - "BackgroundMusic" (Installomator label) helpers
#
# Vendor source: Installomator label backgroundmusic from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "PR7PXC66S5".
# Package ID: "com.bearisdriving.BGM".
# Installer type: "pkg".
#

maclib::backgroundmusic::suite_installer_url() {
  downloadURLFromGit kyleneideck BackgroundMusic
}

maclib::backgroundmusic::latest_version() {
  versionFromGit kyleneideck BackgroundMusic
}

maclib::backgroundmusic::is_installed() {
  pkgutil --pkg-info ""com.bearisdriving.BGM"" >/dev/null 2>&1
}

maclib::backgroundmusic::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.bearisdriving.BGM"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::backgroundmusic::install() {
  local url tmp
  url="$(maclib::backgroundmusic::suite_installer_url)"
  tmp="$(mktemp -d -t "backgroundmusic.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "backgroundmusic::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::backgroundmusic::update() {
  # No vendor update path documented for "BackgroundMusic".
  maclib::log::error "backgroundmusic::update: no update path"
  return 127
}

maclib::backgroundmusic::uninstall() {
  # No clean uninstall for "BackgroundMusic"; removing package receipt ""com.bearisdriving.BGM"".
  pkgutil --forget ""com.bearisdriving.BGM""
  return $?
}
