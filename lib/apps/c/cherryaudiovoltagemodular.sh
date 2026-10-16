#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiovoltagemodular.sh - "Voltage Modular" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiovoltagemodular from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.VoltageModularPackage".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiovoltagemodular::suite_installer_url() {
  https://store.cherryaudio.com/downloads/voltage-modular-macos-installer?file=VoltageModular-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiovoltagemodular::latest_version() {
  curl -fs https://cherryaudio.com/products/voltage-modular/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiovoltagemodular::is_installed() {
  pkgutil --pkg-info "com.cherryaudio.pkg.VoltageModularPackage" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiovoltagemodular::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.cherryaudio.pkg.VoltageModularPackage" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiovoltagemodular::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiovoltagemodular::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiovoltagemodular.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiovoltagemodular::install: download failed"
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

maclib::apps::c::cherryaudiovoltagemodular::update() {
# Update: download latest from store page and install.
  maclib::core::log::info "maclib::apps::c::cherryaudiovoltagemodular::update: download from https://store.cherryaudio.com/downloads/voltage-modular-macos-installer?file=VoltageModular-Installer-macOS.pkg"
  # Update via install() which fetches latest from suite_installer_url.
  maclib::core::log::info "maclib::apps::c::cherryaudiovoltagemodular::update: run install() to get latest"
  maclib::apps::c::cherryaudiovoltagemodular::install
}
}

maclib::apps::c::cherryaudiovoltagemodular::uninstall() {
  # No clean uninstall for "Voltage Modular"; removing package receipt "com.cherryaudio.pkg.VoltageModularPackage".
  pkgutil --forget "com.cherryaudio.pkg.VoltageModularPackage"
  return $?
}
}
