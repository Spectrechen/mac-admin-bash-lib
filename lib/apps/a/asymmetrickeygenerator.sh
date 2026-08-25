#!/usr/bin/env bash
# shellcheck disable=all
# asymmetrickeygenerator.sh - "AsymmetricKeyGenerator" (Installomator label) helpers
#
# Vendor source: Installomator label asymmetrickeygenerator from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "89H83DPVB8".
# Installer type: "dmg".
#

maclib::asymmetrickeygenerator::suite_installer_url() {
  downloadURLFromGit binance asymmetric-key-generator
}

maclib::asymmetrickeygenerator::latest_version() {
  versionFromGit binance asymmetric-key-generator
}

maclib::asymmetrickeygenerator::is_installed() {
  [[ -d "/Applications/AsymmetricKeyGenerator.app" ]] || [[ -d "$HOME/Applications/AsymmetricKeyGenerator.app" ]]
}

maclib::asymmetrickeygenerator::installed_path() {
  if [[ -d "/Applications/AsymmetricKeyGenerator.app" ]]; then
    printf "%s\n" "/Applications/AsymmetricKeyGenerator.app"
  elif [[ -d "$HOME/Applications/AsymmetricKeyGenerator.app" ]]; then
    printf "%s\n" "$HOME/Applications/AsymmetricKeyGenerator.app"
  fi
}

maclib::asymmetrickeygenerator::install() {
  local url tmp
  url="$(maclib::asymmetrickeygenerator::suite_installer_url)"
  tmp="$(mktemp -d -t "asymmetrickeygenerator.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "asymmetrickeygenerator::install: download failed"
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

maclib::asymmetrickeygenerator::update() {
  # No vendor update path documented for "AsymmetricKeyGenerator".
  maclib::log::error "asymmetrickeygenerator::update: no update path"
  return 127
}

maclib::asymmetrickeygenerator::uninstall() {
  # No clean uninstall for "AsymmetricKeyGenerator" (documented constraint).
  maclib::log::error "asymmetrickeygenerator::uninstall: no clean uninstall"
  return 1
}
