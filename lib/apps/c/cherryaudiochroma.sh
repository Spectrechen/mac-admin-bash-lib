#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiochroma.sh - "Chroma" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiochroma from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.ChromaPackage-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudiochroma::suite_installer_url() {
  https://store.cherryaudio.com/downloads/chroma-macos-installer?file=Chroma-Installer-macOS.pkg
}

maclib::cherryaudiochroma::latest_version() {
  curl -fs https://cherryaudio.com/products/chroma/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudiochroma::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.ChromaPackage-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudiochroma::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.ChromaPackage-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudiochroma::install() {
  local url tmp
  url="$(maclib::cherryaudiochroma::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiochroma.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudiochroma::install: download failed"
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

maclib::cherryaudiochroma::update() {
  # No vendor update path documented for "Chroma".
  maclib::log::error "cherryaudiochroma::update: no update path"
  return 127
}

maclib::cherryaudiochroma::uninstall() {
  # No clean uninstall for "Chroma"; removing package receipt ""com.cherryaudio.pkg.ChromaPackage-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.ChromaPackage-StandAlone""
  return $?
}
