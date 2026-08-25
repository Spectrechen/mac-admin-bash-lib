#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiogx80.sh - "GX-80" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiogx80 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.GX-80Package-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudiogx80::suite_installer_url() {
  https://store.cherryaudio.com/downloads/gx-80-macos-installer?file=GX-80-Installer-macOS.pkg
}

maclib::cherryaudiogx80::latest_version() {
  curl -fs https://cherryaudio.com/products/gx-80/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudiogx80::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.GX-80Package-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudiogx80::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.GX-80Package-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudiogx80::install() {
  local url tmp
  url="$(maclib::cherryaudiogx80::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiogx80.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudiogx80::install: download failed"
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

maclib::cherryaudiogx80::update() {
  # No vendor update path documented for "GX-80".
  maclib::log::error "cherryaudiogx80::update: no update path"
  return 127
}

maclib::cherryaudiogx80::uninstall() {
  # No clean uninstall for "GX-80"; removing package receipt ""com.cherryaudio.pkg.GX-80Package-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.GX-80Package-StandAlone""
  return $?
}
