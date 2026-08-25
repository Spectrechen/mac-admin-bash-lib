#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioca2600.sh - "CA2600" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioca2600 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.CA2600Package-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudioca2600::suite_installer_url() {
  https://store.cherryaudio.com/downloads/ca2600-macos-installer?file=CA2600-Installer-macOS.pkg
}

maclib::cherryaudioca2600::latest_version() {
  curl -fs https://cherryaudio.com/products/ca2600/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudioca2600::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.CA2600Package-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudioca2600::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.CA2600Package-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudioca2600::install() {
  local url tmp
  url="$(maclib::cherryaudioca2600::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudioca2600.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudioca2600::install: download failed"
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

maclib::cherryaudioca2600::update() {
  # No vendor update path documented for "CA2600".
  maclib::log::error "cherryaudioca2600::update: no update path"
  return 127
}

maclib::cherryaudioca2600::uninstall() {
  # No clean uninstall for "CA2600"; removing package receipt ""com.cherryaudio.pkg.CA2600Package-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.CA2600Package-StandAlone""
  return $?
}
