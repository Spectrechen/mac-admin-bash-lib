#!/usr/bin/env bash
# shellcheck disable=all
# chemdoodle2d.sh - "ChemDoodle" (Installomator label) helpers
#
# Vendor source: Installomator label chemdoodle2d from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "9XP397UW95".
# Installer type: "dmg".
#

maclib::chemdoodle2d::suite_installer_url() {
  https://www.ichemlabs.com$(curl -s -L https://www.ichemlabs.com/download | grep -oE '[^"]*Doodle-[^"]*'$cpu_arch'[^"]*\.dmg' | head -1)
}

maclib::chemdoodle2d::latest_version() {
  sed -E 's/.*-(.*).dmg/\1/g' <<<$downloadURL
}

maclib::chemdoodle2d::is_installed() {
  [[ -d "/Applications/ChemDoodle.app" ]] || [[ -d "$HOME/Applications/ChemDoodle.app" ]]
}

maclib::chemdoodle2d::installed_path() {
  if [[ -d "/Applications/ChemDoodle.app" ]]; then
    printf "%s\n" "/Applications/ChemDoodle.app"
  elif [[ -d "$HOME/Applications/ChemDoodle.app" ]]; then
    printf "%s\n" "$HOME/Applications/ChemDoodle.app"
  fi
}

maclib::chemdoodle2d::install() {
  local url tmp
  url="$(maclib::chemdoodle2d::suite_installer_url)"
  tmp="$(mktemp -d -t "chemdoodle2d.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "chemdoodle2d::install: download failed"
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

maclib::chemdoodle2d::update() {
  # No vendor update path documented for "ChemDoodle".
  maclib::log::error "chemdoodle2d::update: no update path"
  return 127
}

maclib::chemdoodle2d::uninstall() {
  # No clean uninstall for "ChemDoodle" (documented constraint).
  maclib::log::error "chemdoodle2d::uninstall: no clean uninstall"
  return 1
}
