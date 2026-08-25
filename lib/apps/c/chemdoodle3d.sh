#!/usr/bin/env bash
# shellcheck disable=all
# chemdoodle3d.sh - "ChemDoodle3D" (Installomator label) helpers
#
# Vendor source: Installomator label chemdoodle3d from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "9XP397UW95".
# Installer type: "dmg".
#

maclib::chemdoodle3d::suite_installer_url() {
  https://www.ichemlabs.com$(curl -s -L https://www.ichemlabs.com/download | grep -oE '[^"]*Doodle3D-[^"]*'$cpu_arch'[^"]*\.dmg' | head -1)
}

maclib::chemdoodle3d::latest_version() {
  sed -E 's/.*-(.*).dmg/\1/g' <<<$downloadURL
}

maclib::chemdoodle3d::is_installed() {
  [[ -d "/Applications/ChemDoodle3D.app" ]] || [[ -d "$HOME/Applications/ChemDoodle3D.app" ]]
}

maclib::chemdoodle3d::installed_path() {
  if [[ -d "/Applications/ChemDoodle3D.app" ]]; then
    printf "%s\n" "/Applications/ChemDoodle3D.app"
  elif [[ -d "$HOME/Applications/ChemDoodle3D.app" ]]; then
    printf "%s\n" "$HOME/Applications/ChemDoodle3D.app"
  fi
}

maclib::chemdoodle3d::install() {
  local url tmp
  url="$(maclib::chemdoodle3d::suite_installer_url)"
  tmp="$(mktemp -d -t "chemdoodle3d.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "chemdoodle3d::install: download failed"
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

maclib::chemdoodle3d::update() {
  # No vendor update path documented for "ChemDoodle3D".
  maclib::log::error "chemdoodle3d::update: no update path"
  return 127
}

maclib::chemdoodle3d::uninstall() {
  # No clean uninstall for "ChemDoodle3D" (documented constraint).
  maclib::log::error "chemdoodle3d::uninstall: no clean uninstall"
  return 1
}
