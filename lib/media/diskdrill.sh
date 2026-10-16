#!/usr/bin/env bash
# shellcheck disable=all
# diskdrill.sh - Disk Drill (Installomator label) helpers
#
# Vendor source: Installomator label diskdrill from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::media::diskdrill::suite_installer_url() {
  # TODO: Add actual download URL for Disk Drill
  printf '%s\\n' 'https://example.com/diskdrill/installer'
}

maclib::media::diskdrill::latest_version() {
  # TODO: Add version detection for Disk Drill
  return 1
}

maclib::media::diskdrill::is_installed() {
  [[ -d "/Applications/Disk Drill.app" ]] || [[ -d "$HOME/Applications/Disk Drill.app" ]]
}

maclib::media::diskdrill::installed_path() {
  if [[ -d "/Applications/Disk Drill.app" ]]; then
    printf '%s\\n' "/Applications/Disk Drill.app"
  elif [[ -d "$HOME/Applications/Disk Drill.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Disk Drill.app"
  fi
}

maclib::diskdrill::install() {
  local url tmp mp app
  url="$(maclib::diskdrill::suite_installer_url)"
  tmp="$(mktemp -d -t "diskdrill.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "diskdrill::install: download failed"
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


maclib::media::diskdrill::update() {
  # No vendor update path documented for "Disk Drill".
  maclib::core::log::error "diskdrill::update: no update path"
  return 127
}

maclib::media::diskdrill::uninstall() {
  # No clean uninstall for "Disk Drill" (documented constraint).
  maclib::core::log::error "diskdrill::uninstall: no clean uninstall"
  return 1
}
