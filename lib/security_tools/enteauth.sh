#!/usr/bin/env bash
# shellcheck disable=all
# enteauth.sh - Ente Auth (Installomator label) helpers
#
# Vendor source: Installomator label enteauth from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::security_tools::enteauth::suite_installer_url() {
  # TODO: Add actual download URL for Ente Auth
  printf '%s\\n' 'https://example.com/enteauth/installer'
}

maclib::security_tools::enteauth::latest_version() {
  # TODO: Add version detection for Ente Auth
  return 1
}

maclib::security_tools::enteauth::is_installed() {
  [[ -d "/Applications/Ente Auth.app" ]] || [[ -d "$HOME/Applications/Ente Auth.app" ]]
}

maclib::security_tools::enteauth::installed_path() {
  if [[ -d "/Applications/Ente Auth.app" ]]; then
    printf '%s\\n' "/Applications/Ente Auth.app"
  elif [[ -d "$HOME/Applications/Ente Auth.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Ente Auth.app"
  fi
}

maclib::enteauth::install() {
  local url tmp mp app
  url="$(maclib::enteauth::suite_installer_url)"
  tmp="$(mktemp -d -t "enteauth.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "enteauth::install: download failed"
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


maclib::security_tools::enteauth::update() {
  # No vendor update path documented for "Ente Auth".
  maclib::core::log::error "enteauth::update: no update path"
  return 127
}

maclib::security_tools::enteauth::uninstall() {
  # No clean uninstall for "Ente Auth" (documented constraint).
  maclib::core::log::error "enteauth::uninstall: no clean uninstall"
  return 1
}
