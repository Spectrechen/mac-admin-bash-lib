#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiostardust201.sh - "Stardust 201 Tape Echo" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiostardust201 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.Stardust201Package-StandAlone".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiostardust201::suite_installer_url() {
  https://store.cherryaudio.com/downloads/stardust-201-macos-installer?file=Stardust201-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiostardust201::latest_version() {
  curl -fs https://cherryaudio.com/products/stardust-201/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiostardust201::is_installed() {
  pkgutil --pkg-info "com.cherryaudio.pkg.Stardust201Package-StandAlone" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiostardust201::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.cherryaudio.pkg.Stardust201Package-StandAlone" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiostardust201::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiostardust201::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiostardust201.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiostardust201::install: download failed"
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

maclib::apps::c::cherryaudiostardust201::update() {
# No vendor update path documented for "Stardust 201 Tape Echo".
  maclib::core::log::error "maclib::apps::c::cherryaudiostardust201::update: no update path"
  return 127
}
}

maclib::apps::c::cherryaudiostardust201::uninstall() {
  # No clean uninstall for "Stardust 201 Tape Echo"; removing package receipt "com.cherryaudio.pkg.Stardust201Package-StandAlone".
  pkgutil --forget "com.cherryaudio.pkg.Stardust201Package-StandAlone"
  return $?
}
}
