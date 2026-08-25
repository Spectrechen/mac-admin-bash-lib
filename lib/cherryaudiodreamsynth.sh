#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiodreamsynth.sh - "Dreamsynth" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiodreamsynth from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.DreamsynthPackage-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudiodreamsynth::suite_installer_url() {
  https://store.cherryaudio.com/downloads/dreamsynth-macos-installer?file=Dreamsynth-Installer-macOS.pkg
}

maclib::cherryaudiodreamsynth::latest_version() {
  curl -fs https://cherryaudio.com/products/dreamsynth/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudiodreamsynth::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.DreamsynthPackage-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudiodreamsynth::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.DreamsynthPackage-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudiodreamsynth::install() {
  local url tmp
  url="$(maclib::cherryaudiodreamsynth::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiodreamsynth.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudiodreamsynth::install: download failed"
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

maclib::cherryaudiodreamsynth::update() {
  # No vendor update path documented for "Dreamsynth".
  maclib::log::error "cherryaudiodreamsynth::update: no update path"
  return 127
}

maclib::cherryaudiodreamsynth::uninstall() {
  # No clean uninstall for "Dreamsynth"; removing package receipt ""com.cherryaudio.pkg.DreamsynthPackage-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.DreamsynthPackage-StandAlone""
  return $?
}
