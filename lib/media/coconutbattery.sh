#!/usr/bin/env bash
# shellcheck disable=all
# coconutbattery.sh - coconutBattery (Installomator label) helpers
#
# Vendor source: Installomator label coconutbattery from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::media::coconutbattery::suite_installer_url() {
  # TODO: Add actual download URL for coconutBattery
  printf '%s\\n' 'https://example.com/coconutbattery/installer'
}

maclib::media::coconutbattery::latest_version() {
  # TODO: Add version detection for coconutBattery
  return 1
}

maclib::media::coconutbattery::is_installed() {
  [[ -d "/Applications/Coconutbattery.app" ]] || [[ -d "$HOME/Applications/Coconutbattery.app" ]]
}

maclib::media::coconutbattery::installed_path() {
  if [[ -d "/Applications/Coconutbattery.app" ]]; then
    printf '%s\\n' "/Applications/Coconutbattery.app"
  elif [[ -d "$HOME/Applications/Coconutbattery.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Coconutbattery.app"
  fi
}

maclib::coconutbattery::install() {
  local url tmp
  url="$(maclib::coconutbattery::suite_installer_url)"
  tmp="$(mktemp -d -t "coconutbattery.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "coconutbattery::install: download failed"
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


maclib::media::coconutbattery::update() {
  # No vendor update path documented for "coconutBattery".
  maclib::core::log::error "coconutbattery::update: no update path"
  return 127
}

maclib::media::coconutbattery::uninstall() {
  # No clean uninstall for "coconutBattery" (documented constraint).
  maclib::core::log::error "coconutbattery::uninstall: no clean uninstall"
  return 1
}
