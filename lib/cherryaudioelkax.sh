#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioelkax.sh - "Elka-X" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioelkax from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.Elka-XPackage-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudioelkax::suite_installer_url() {
  https://store.cherryaudio.com/downloads/elka-x-macos-installer?file=Elka-X-Installer-macOS.pkg
}

maclib::cherryaudioelkax::latest_version() {
  curl -fs https://cherryaudio.com/products/elka-x/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudioelkax::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.Elka-XPackage-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudioelkax::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.Elka-XPackage-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudioelkax::install() {
  local url tmp
  url="$(maclib::cherryaudioelkax::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudioelkax.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudioelkax::install: download failed"
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

maclib::cherryaudioelkax::update() {
  # No vendor update path documented for "Elka-X".
  maclib::log::error "cherryaudioelkax::update: no update path"
  return 127
}

maclib::cherryaudioelkax::uninstall() {
  # No clean uninstall for "Elka-X"; removing package receipt ""com.cherryaudio.pkg.Elka-XPackage-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.Elka-XPackage-StandAlone""
  return $?
}
