#!/usr/bin/env bash
# shellcheck disable=all
# blackhole16ch.sh - "BlackHole" (Installomator label) helpers
#
# Vendor source: Installomator label blackhole16ch from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "Q5C99V536K".
# Package ID: "audio.existential.BlackHole16ch".
# Installer type: "pkg".
#

maclib::blackhole16ch::suite_installer_url() {
  getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-16ch.json)" "url"
}

maclib::blackhole16ch::latest_version() {
  $(getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-16ch.json)" "version")
}

maclib::blackhole16ch::is_installed() {
  pkgutil --pkg-info ""audio.existential.BlackHole16ch"" >/dev/null 2>&1
}

maclib::blackhole16ch::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""audio.existential.BlackHole16ch"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::blackhole16ch::install() {
  local url tmp
  url="$(maclib::blackhole16ch::suite_installer_url)"
  tmp="$(mktemp -d -t "blackhole16ch.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "blackhole16ch::install: download failed"
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

maclib::blackhole16ch::update() {
  # No vendor update path documented for "BlackHole".
  maclib::log::error "blackhole16ch::update: no update path"
  return 127
}

maclib::blackhole16ch::uninstall() {
  # No clean uninstall for "BlackHole"; removing package receipt ""audio.existential.BlackHole16ch"".
  pkgutil --forget ""audio.existential.BlackHole16ch""
  return $?
}
