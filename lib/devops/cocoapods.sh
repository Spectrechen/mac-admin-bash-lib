#!/usr/bin/env bash
# shellcheck disable=all
# cocoapods.sh - CocoaPods (Installomator label) helpers
#
# Vendor source: Installomator label cocoapods from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "bz2".
#

maclib::devops::cocoapods::suite_installer_url() {
  # TODO: Add actual download URL for CocoaPods
  printf '%s\\n' 'https://example.com/cocoapods/installer'
}

maclib::devops::cocoapods::latest_version() {
  # TODO: Add version detection for CocoaPods
  return 1
}

maclib::devops::cocoapods::is_installed() {
  [[ -d "/Applications/Cocoapods.app" ]] || [[ -d "$HOME/Applications/Cocoapods.app" ]]
}

maclib::devops::cocoapods::installed_path() {
  if [[ -d "/Applications/Cocoapods.app" ]]; then
    printf '%s\\n' "/Applications/Cocoapods.app"
  elif [[ -d "$HOME/Applications/Cocoapods.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cocoapods.app"
  fi
}

maclib::cocoapods::install() {
  local url tmp mp app
  url="$(maclib::cocoapods::suite_installer_url)"
  tmp="$(mktemp -d -t "cocoapods.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cocoapods::install: download failed"
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


maclib::devops::cocoapods::update() {
  # No vendor update path documented for "CocoaPods".
  maclib::core::log::error "cocoapods::update: no update path"
  return 127
}

maclib::devops::cocoapods::uninstall() {
  # No clean uninstall for "CocoaPods" (documented constraint).
  maclib::core::log::error "cocoapods::uninstall: no clean uninstall"
  return 1
}
