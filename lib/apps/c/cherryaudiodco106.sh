#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiodco106.sh - "DCO-106" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiodco106 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.DCO106Package-StandAlone".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiodco106::suite_installer_url() {
  https://store.cherryaudio.com/downloads/dco-106-macos-installer?file=DCO-106-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiodco106::latest_version() {
  curl -fs https://cherryaudio.com/products/dco-106/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiodco106::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.DCO106Package-StandAlone"" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiodco106::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.DCO106Package-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiodco106::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiodco106::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiodco106.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiodco106::install: download failed"
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

maclib::apps::c::cherryaudiodco106::update() {
  # No vendor update path documented for "DCO-106".
  maclib::core::log::error "cherryaudiodco106::update: no update path"
  return 127
}

maclib::apps::c::cherryaudiodco106::uninstall() {
  # No clean uninstall for "DCO-106"; removing package receipt ""com.cherryaudio.pkg.DCO106Package-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.DCO106Package-StandAlone""
  return $?
}
