#!/usr/bin/env bash
# shellcheck disable=all
# craftmanagerforsketch.sh - CraftManager (Installomator label) helpers
#
# Vendor source: Installomator label craftmanagerforsketch from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::creative::craftmanagerforsketch::suite_installer_url() {
  # TODO: Add actual download URL for CraftManager
  printf '%s\\n' 'https://example.com/craftmanagerforsketch/installer'
}

maclib::creative::craftmanagerforsketch::latest_version() {
  # TODO: Add version detection for CraftManager
  return 1
}

maclib::creative::craftmanagerforsketch::is_installed() {
  [[ -d "/Applications/Craftmanager.app" ]] || [[ -d "$HOME/Applications/Craftmanager.app" ]]
}

maclib::creative::craftmanagerforsketch::installed_path() {
  if [[ -d "/Applications/Craftmanager.app" ]]; then
    printf '%s\\n' "/Applications/Craftmanager.app"
  elif [[ -d "$HOME/Applications/Craftmanager.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Craftmanager.app"
  fi
}

maclib::craftmanagerforsketch::install() {
  local url tmp
  url="$(maclib::craftmanagerforsketch::suite_installer_url)"
  tmp="$(mktemp -d -t "craftmanagerforsketch.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "craftmanagerforsketch::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}


maclib::creative::craftmanagerforsketch::update() {
  # No vendor update path documented for "CraftManager".
  maclib::core::log::error "craftmanagerforsketch::update: no update path"
  return 127
}

maclib::creative::craftmanagerforsketch::uninstall() {
  # No clean uninstall for "CraftManager" (documented constraint).
  maclib::core::log::error "craftmanagerforsketch::uninstall: no clean uninstall"
  return 1
}
