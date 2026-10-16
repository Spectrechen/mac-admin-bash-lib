#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiorackmode.sh - "Rackmode Signal Processors" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiorackmode from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.RackmodePackage-StandAlone".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiorackmode::suite_installer_url() {
  https://store.cherryaudio.com/downloads/rackmode-macos-installer?file=Rackmode-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiorackmode::latest_version() {
  curl -fs https://cherryaudio.com/products/rackmode/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiorackmode::is_installed() {
  pkgutil --pkg-info "com.cherryaudio.pkg.RackmodePackage-StandAlone" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiorackmode::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.cherryaudio.pkg.RackmodePackage-StandAlone" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiorackmode::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiorackmode::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiorackmode.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiorackmode::install: download failed"
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

maclib::apps::c::cherryaudiorackmode::update() {
# No vendor update path documented for "Rackmode Signal Processors".
  maclib::core::log::error "maclib::apps::c::cherryaudiorackmode::update: no update path"
  return 127
}
}

maclib::apps::c::cherryaudiorackmode::uninstall() {
  # No clean uninstall for "Rackmode Signal Processors"; removing package receipt "com.cherryaudio.pkg.RackmodePackage-StandAlone".
  pkgutil --forget "com.cherryaudio.pkg.RackmodePackage-StandAlone"
  return $?
}
}
