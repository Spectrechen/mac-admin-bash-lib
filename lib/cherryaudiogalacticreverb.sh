#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiogalacticreverb.sh - "Galactic Reverb" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiogalacticreverb from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.GalacticPackage-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudiogalacticreverb::suite_installer_url() {
  https://store.cherryaudio.com/downloads/galactic-reverb-macos-installer?file=Galactic-Reverb-Installer-macOS.pkg
}

maclib::cherryaudiogalacticreverb::latest_version() {
  curl -fs https://cherryaudio.com/products/galactic-reverb/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudiogalacticreverb::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.GalacticPackage-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudiogalacticreverb::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.GalacticPackage-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudiogalacticreverb::install() {
  local url tmp
  url="$(maclib::cherryaudiogalacticreverb::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiogalacticreverb.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudiogalacticreverb::install: download failed"
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

maclib::cherryaudiogalacticreverb::update() {
  # No vendor update path documented for "Galactic Reverb".
  maclib::log::error "cherryaudiogalacticreverb::update: no update path"
  return 127
}

maclib::cherryaudiogalacticreverb::uninstall() {
  # No clean uninstall for "Galactic Reverb"; removing package receipt ""com.cherryaudio.pkg.GalacticPackage-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.GalacticPackage-StandAlone""
  return $?
}
