#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosines.sh - "Sines Synthesizer" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosines from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.SinesPackage-StandAlone".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiosines::suite_installer_url() {
  https://store.cherryaudio.com/downloads/sines-macos-installer?file=Sines-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiosines::latest_version() {
  curl -fs https://cherryaudio.com/products/sines/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiosines::is_installed() {
  pkgutil --pkg-info "com.cherryaudio.pkg.SinesPackage-StandAlone" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiosines::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.cherryaudio.pkg.SinesPackage-StandAlone" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiosines::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiosines::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiosines.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosines::install: download failed"
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

maclib::apps::c::cherryaudiosines::update() {
# No vendor update path documented for "Sines Synthesizer".
  maclib::core::log::error "maclib::apps::c::cherryaudiosines::update: no update path"
  return 127
}
}

maclib::apps::c::cherryaudiosines::uninstall() {
  # No clean uninstall for "Sines Synthesizer"; removing package receipt "com.cherryaudio.pkg.SinesPackage-StandAlone".
  pkgutil --forget "com.cherryaudio.pkg.SinesPackage-StandAlone"
  return $?
}
}
