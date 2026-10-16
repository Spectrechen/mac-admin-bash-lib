#!/usr/bin/env bash
# shellcheck disable=all
# cryptomator.sh - Cryptomator (Installomator label) helpers
#
# Vendor source: Installomator label cryptomator from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::security::cryptomator::suite_installer_url() {
  # TODO: Add actual download URL for Cryptomator
  printf '%s\\n' 'https://example.com/cryptomator/installer'
}

maclib::security::cryptomator::latest_version() {
  # TODO: Add version detection for Cryptomator
  return 1
}

maclib::security::cryptomator::is_installed() {
  [[ -d "/Applications/Cryptomator.app" ]] || [[ -d "$HOME/Applications/Cryptomator.app" ]]
}

maclib::security::cryptomator::installed_path() {
  if [[ -d "/Applications/Cryptomator.app" ]]; then
    printf '%s\\n' "/Applications/Cryptomator.app"
  elif [[ -d "$HOME/Applications/Cryptomator.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cryptomator.app"
  fi
}

maclib::cryptomator::install() {
  local url tmp mp app
  url="$(maclib::cryptomator::suite_installer_url)"
  tmp="$(mktemp -d -t "cryptomator.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cryptomator::install: download failed"
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


maclib::security::cryptomator::update() {
  # No vendor update path documented for "Cryptomator".
  maclib::core::log::error "cryptomator::update: no update path"
  return 127
}

maclib::security::cryptomator::uninstall() {
  # No clean uninstall for "Cryptomator" (documented constraint).
  maclib::core::log::error "cryptomator::uninstall: no clean uninstall"
  return 1
}
