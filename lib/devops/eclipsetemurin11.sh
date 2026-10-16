#!/usr/bin/env bash
# shellcheck disable=all
# eclipsetemurin11.sh - Temurin 11 (Installomator label) helpers
#
# Vendor source: Installomator label eclipsetemurin11 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::devops::eclipsetemurin11::suite_installer_url() {
  # TODO: Add actual download URL for Temurin 11
  printf '%s\\n' 'https://example.com/eclipsetemurin11/installer'
}

maclib::devops::eclipsetemurin11::latest_version() {
  # TODO: Add version detection for Temurin 11
  return 1
}

maclib::devops::eclipsetemurin11::is_installed() {
  [[ -d "/Applications/Temurin 11.app" ]] || [[ -d "$HOME/Applications/Temurin 11.app" ]]
}

maclib::devops::eclipsetemurin11::installed_path() {
  if [[ -d "/Applications/Temurin 11.app" ]]; then
    printf '%s\\n' "/Applications/Temurin 11.app"
  elif [[ -d "$HOME/Applications/Temurin 11.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Temurin 11.app"
  fi
}

maclib::eclipsetemurin11::install() {
  local url tmp
  url="$(maclib::eclipsetemurin11::suite_installer_url)"
  tmp="$(mktemp -t "eclipsetemurin11_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "eclipsetemurin11::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::devops::eclipsetemurin11::update() {
  # No vendor update path documented for "Temurin 11".
  maclib::core::log::error "eclipsetemurin11::update: no update path"
  return 127
}

maclib::devops::eclipsetemurin11::uninstall() {
  # No clean uninstall for "Temurin 11" (documented constraint).
  maclib::core::log::error "eclipsetemurin11::uninstall: no clean uninstall"
  return 1
}
