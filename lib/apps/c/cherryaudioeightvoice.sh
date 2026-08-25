#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioeightvoice.sh - "Eight Voice" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioeightvoice from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.EightVoicePackage-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudioeightvoice::suite_installer_url() {
  https://store.cherryaudio.com/downloads/eight-voice-macos-installer?file=Eight-Voice-Installer-macOS.pkg
}

maclib::cherryaudioeightvoice::latest_version() {
  curl -fs https://cherryaudio.com/products/eight-voice/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudioeightvoice::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.EightVoicePackage-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudioeightvoice::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.EightVoicePackage-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudioeightvoice::install() {
  local url tmp
  url="$(maclib::cherryaudioeightvoice::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudioeightvoice.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudioeightvoice::install: download failed"
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

maclib::cherryaudioeightvoice::update() {
  # No vendor update path documented for "Eight Voice".
  maclib::log::error "cherryaudioeightvoice::update: no update path"
  return 127
}

maclib::cherryaudioeightvoice::uninstall() {
  # No clean uninstall for "Eight Voice"; removing package receipt ""com.cherryaudio.pkg.EightVoicePackage-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.EightVoicePackage-StandAlone""
  return $?
}
