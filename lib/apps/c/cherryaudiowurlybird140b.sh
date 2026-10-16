#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiowurlybird140b.sh - "Wurlybird 140B Electric Piano" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiowurlybird140b from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.Wurlybird140BPackage-StandAlone".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiowurlybird140b::suite_installer_url() {
  https://store.cherryaudio.com/downloads/wurlybird-140b-macos-installer?file=Wurlybird140B-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiowurlybird140b::latest_version() {
  curl -fs https://cherryaudio.com/products/wurlybird140b/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiowurlybird140b::is_installed() {
  pkgutil --pkg-info "com.cherryaudio.pkg.Wurlybird140BPackage-StandAlone" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiowurlybird140b::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.cherryaudio.pkg.Wurlybird140BPackage-StandAlone" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiowurlybird140b::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiowurlybird140b::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiowurlybird140b.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiowurlybird140b::install: download failed"
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

maclib::apps::c::cherryaudiowurlybird140b::update() {
# No vendor update path documented for "Wurlybird 140B Electric Piano".
  maclib::core::log::error "maclib::apps::c::cherryaudiowurlybird140b::update: no update path"
  return 127
}
}

maclib::apps::c::cherryaudiowurlybird140b::uninstall() {
  # No clean uninstall for "Wurlybird 140B Electric Piano"; removing package receipt "com.cherryaudio.pkg.Wurlybird140BPackage-StandAlone".
  pkgutil --forget "com.cherryaudio.pkg.Wurlybird140BPackage-StandAlone"
  return $?
}
}
