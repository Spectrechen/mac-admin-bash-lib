#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioblue3.sh - "Blue3 Organ" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioblue3 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.Blue3Package-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudioblue3::suite_installer_url() {
  https://store.cherryaudio.com/downloads/blue3-tonewheel-organ-macos-installer?file=Blue3-Organ-Installer-macOS.pkg
}

maclib::cherryaudioblue3::latest_version() {
  curl -fs https://cherryaudio.com/products/blue3-tonewheel-organ/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudioblue3::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.Blue3Package-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudioblue3::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.Blue3Package-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudioblue3::install() {
  local url tmp
  url="$(maclib::cherryaudioblue3::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudioblue3.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudioblue3::install: download failed"
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

maclib::cherryaudioblue3::update() {
  # No vendor update path documented for "Blue3 Organ".
  maclib::log::error "cherryaudioblue3::update: no update path"
  return 127
}

maclib::cherryaudioblue3::uninstall() {
  # No clean uninstall for "Blue3 Organ"; removing package receipt ""com.cherryaudio.pkg.Blue3Package-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.Blue3Package-StandAlone""
  return $?
}
