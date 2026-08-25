#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiocr78.sh - "CR-78" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiocr78 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.CR-78Package-StandAlone".
# Installer type: "pkg".
#

maclib::cherryaudiocr78::suite_installer_url() {
  https://store.cherryaudio.com/downloads/cr-78-macos-installer?file=CR-78-Installer-macOS.pkg
}

maclib::cherryaudiocr78::latest_version() {
  curl -fs https://cherryaudio.com/products/cr-78/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::cherryaudiocr78::is_installed() {
  pkgutil --pkg-info ""com.cherryaudio.pkg.CR-78Package-StandAlone"" >/dev/null 2>&1
}

maclib::cherryaudiocr78::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.cherryaudio.pkg.CR-78Package-StandAlone"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::cherryaudiocr78::install() {
  local url tmp
  url="$(maclib::cherryaudiocr78::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiocr78.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cherryaudiocr78::install: download failed"
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

maclib::cherryaudiocr78::update() {
  # No vendor update path documented for "CR-78".
  maclib::log::error "cherryaudiocr78::update: no update path"
  return 127
}

maclib::cherryaudiocr78::uninstall() {
  # No clean uninstall for "CR-78"; removing package receipt ""com.cherryaudio.pkg.CR-78Package-StandAlone"".
  pkgutil --forget ""com.cherryaudio.pkg.CR-78Package-StandAlone""
  return $?
}
