#!/usr/bin/env bash
# shellcheck disable=all
# doctolib.sh - Doctolib (Installomator label) helpers
#
# Vendor source: Installomator label doctolib from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::doctolib::suite_installer_url() {
  # TODO: Add actual download URL for Doctolib
  printf '%s\\n' 'https://example.com/doctolib/installer'
}

maclib::productivity::doctolib::latest_version() {
  # TODO: Add version detection for Doctolib
  return 1
}

maclib::productivity::doctolib::is_installed() {
  [[ -d "/Applications/Doctolib.app" ]] || [[ -d "$HOME/Applications/Doctolib.app" ]]
}

maclib::productivity::doctolib::installed_path() {
  if [[ -d "/Applications/Doctolib.app" ]]; then
    printf '%s\\n' "/Applications/Doctolib.app"
  elif [[ -d "$HOME/Applications/Doctolib.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Doctolib.app"
  fi
}

maclib::doctolib::install() {
  local url tmp mp app
  url="$(maclib::doctolib::suite_installer_url)"
  tmp="$(mktemp -d -t "doctolib.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "doctolib::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::productivity::doctolib::update() {
  # No vendor update path documented for "Doctolib".
  maclib::core::log::error "doctolib::update: no update path"
  return 127
}

maclib::productivity::doctolib::uninstall() {
  # No clean uninstall for "Doctolib" (documented constraint).
  maclib::core::log::error "doctolib::uninstall: no clean uninstall"
  return 1
}
