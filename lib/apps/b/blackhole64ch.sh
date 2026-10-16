#!/usr/bin/env bash
# shellcheck disable=all
# blackhole64ch.sh - "BlackHole" (Installomator label) helpers
#
# Vendor source: Installomator label blackhole64ch from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "Q5C99V536K".
# Package ID: "audio.existential.BlackHole64ch".
# Installer type: "pkg".
#

maclib::apps::b::blackhole64ch::suite_installer_url() {
  getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-64ch.json)" "url"
}

maclib::apps::b::blackhole64ch::latest_version() {
  $(getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-64ch.json)" "version")
}

maclib::apps::b::blackhole64ch::is_installed() {
  pkgutil --pkg-info ""audio.existential.BlackHole64ch"" >/dev/null 2>&1
}

maclib::apps::b::blackhole64ch::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""audio.existential.BlackHole64ch"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::b::blackhole64ch::install() {
  local url tmp
  url="$(maclib::apps::b::blackhole64ch::suite_installer_url)"
  tmp="$(mktemp -d -t "blackhole64ch.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "blackhole64ch::install: download failed"
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

maclib::apps::b::blackhole64ch::update() {
  # No vendor update path documented for "BlackHole".
  maclib::core::log::error "blackhole64ch::update: no update path"
  return 127
}

maclib::apps::b::blackhole64ch::uninstall() {
  # No clean uninstall for "BlackHole"; removing package receipt ""audio.existential.BlackHole64ch"".
  pkgutil --forget ""audio.existential.BlackHole64ch""
  return $?
}
