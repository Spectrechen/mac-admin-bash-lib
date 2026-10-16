#!/usr/bin/env bash
# shellcheck disable=all
# azuredatastudio.sh - "Azure Data Studio" (Installomator label) helpers
#
# Vendor source: Installomator label azuredatastudio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "UBF8T346G9".
# Installer type: "zip".
#

maclib::apps::a::azuredatastudio::suite_installer_url() {
  curl -sL https://github.com/microsoft/azuredatastudio/releases/latest | grep 'Universal' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | head -1
}

maclib::apps::a::azuredatastudio::latest_version() {
  versionFromGit microsoft azuredatastudio
}

maclib::apps::a::azuredatastudio::is_installed() {
  [[ -d "/Applications/AzureDataStudio.app" ]] || [[ -d "$HOME/Applications/AzureDataStudio.app" ]]
}

maclib::apps::a::azuredatastudio::installed_path() {
  if [[ -d "/Applications/AzureDataStudio.app" ]]; then
    printf "%s\n" "/Applications/AzureDataStudio.app"
  elif [[ -d "$HOME/Applications/AzureDataStudio.app" ]]; then
    printf "%s\n" "$HOME/Applications/AzureDataStudio.app"
  fi
}

maclib::apps::a::azuredatastudio::install() {
  local url tmp
  url="$(maclib::apps::a::azuredatastudio::suite_installer_url)"
  tmp="$(mktemp -d -t "azuredatastudio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "azuredatastudio::install: download failed"
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

maclib::apps::a::azuredatastudio::update() {
  # No vendor update path documented for "Azure Data Studio".
  maclib::core::log::error "azuredatastudio::update: no update path"
  return 127
}

maclib::apps::a::azuredatastudio::uninstall() {
  # No clean uninstall for "Azure Data Studio" (documented constraint).
  maclib::core::log::error "azuredatastudio::uninstall: no clean uninstall"
  return 1
}
