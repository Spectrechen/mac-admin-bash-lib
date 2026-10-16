#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosynthesizerexpander.sh - "Synthesizer Expander Module" (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosynthesizerexpander from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A2XFV22B2X".
# Package ID: "com.cherryaudio.pkg.SEMPackage-StandAlone".
# Installer type: "pkg".
#

maclib::apps::c::cherryaudiosynthesizerexpander::suite_installer_url() {
  https://store.cherryaudio.com/downloads/synthesizer-expander-module-macos-installer?file=SEM-Installer-macOS.pkg
}

maclib::apps::c::cherryaudiosynthesizerexpander::latest_version() {
  curl -fs https://cherryaudio.com/products/synthesizer-expander-module/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::cherryaudiosynthesizerexpander::is_installed() {
  pkgutil --pkg-info "com.cherryaudio.pkg.SEMPackage-StandAlone" >/dev/null 2>&1
}

maclib::apps::c::cherryaudiosynthesizerexpander::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.cherryaudio.pkg.SEMPackage-StandAlone" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::cherryaudiosynthesizerexpander::install() {
  local url tmp
  url="$(maclib::apps::c::cherryaudiosynthesizerexpander::suite_installer_url)"
  tmp="$(mktemp -d -t "cherryaudiosynthesizerexpander.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosynthesizerexpander::install: download failed"
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

maclib::apps::c::cherryaudiosynthesizerexpander::update() {
# No vendor update path documented for "Synthesizer Expander Module".
  maclib::core::log::error "maclib::apps::c::cherryaudiosynthesizerexpander::update: no update path"
  return 127
}
}

maclib::apps::c::cherryaudiosynthesizerexpander::uninstall() {
  # No clean uninstall for "Synthesizer Expander Module"; removing package receipt "com.cherryaudio.pkg.SEMPackage-StandAlone".
  pkgutil --forget "com.cherryaudio.pkg.SEMPackage-StandAlone"
  return $?
}
}
