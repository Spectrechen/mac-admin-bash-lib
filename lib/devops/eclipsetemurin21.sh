#!/usr/bin/env bash
# shellcheck disable=all
# eclipsetemurin21.sh - Temurin 21 (Installomator label) helpers
#
# Vendor source: Installomator label eclipsetemurin21 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::devops::eclipsetemurin21::suite_installer_url() {
  # TODO: Add actual download URL for Temurin 21
  printf '%s\\n' 'https://example.com/eclipsetemurin21/installer'
}

maclib::devops::eclipsetemurin21::latest_version() {
  # TODO: Add version detection for Temurin 21
  return 1
}

maclib::devops::eclipsetemurin21::is_installed() {
  [[ -d "/Applications/Temurin 21.app" ]] || [[ -d "$HOME/Applications/Temurin 21.app" ]]
}

maclib::devops::eclipsetemurin21::installed_path() {
  if [[ -d "/Applications/Temurin 21.app" ]]; then
    printf '%s\\n' "/Applications/Temurin 21.app"
  elif [[ -d "$HOME/Applications/Temurin 21.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Temurin 21.app"
  fi
}

maclib::eclipsetemurin21::install() {
  local url tmp
  url="$(maclib::eclipsetemurin21::suite_installer_url)"
  tmp="$(mktemp -t "eclipsetemurin21_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "eclipsetemurin21::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::devops::eclipsetemurin21::update() {
  # No vendor update path documented for "Temurin 21".
  maclib::core::log::error "eclipsetemurin21::update: no update path"
  return 127
}

maclib::devops::eclipsetemurin21::uninstall() {
  # No clean uninstall for "Temurin 21" (documented constraint).
  maclib::core::log::error "eclipsetemurin21::uninstall: no clean uninstall"
  return 1
}
