#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosurrealisticmg1plus.sh - "Surrealistic MG-1 Plus" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosurrealisticmg1plus from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.SurrealisticMG1PlusPackage-StandAlone".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiosurrealisticmg1plus::suite_installer_url() {
  https://store.cherryaudio.com/downloads/surrealistic-mg-1-plus-macos-installer?file=SurrealisticMG1Plus-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiosurrealisticmg1plus::latest_version() {
  curl -fs https://cherryaudio.com/products/surrealistic-mg-1-plus/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiosurrealisticmg1plus::is_installed() {
  pkgutil --pkg-info "com.cherryaudio.pkg.SurrealisticMG1PlusPackage-StandAlone" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiosurrealisticmg1plus::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.cherryaudio.pkg.SurrealisticMG1PlusPackage-StandAlone" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiosurrealisticmg1plus::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiosurrealisticmg1plus::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiosurrealisticmg1plus.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosurrealisticmg1plus::install: download failed"
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

maclib::apps::c::cherryaudiosurrealisticmg1plus::update() {
# No vendor update path documented for "Surrealistic MG-1 Plus".
  maclib::core::log::error "maclib::apps::c::cherryaudiosurrealisticmg1plus::update: no update path"
  return 127
}
}

maclib::apps::c::cherryaudiosurrealisticmg1plus::uninstall() {
  # No clean uninstall for "Surrealistic MG-1 Plus"; removing package receipt "com.cherryaudio.pkg.SurrealisticMG1PlusPackage-StandAlone".
  pkgutil --forget "com.cherryaudio.pkg.SurrealisticMG1PlusPackage-StandAlone"
  return $?
}
}
