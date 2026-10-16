#!/usr/bin/env bash
# shellcheck disable=all
# detectxswift.sh - DetectX Swift (Installomator label) helpers
#
# Vendor source: Installomator label detectxswift from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::security::detectxswift::suite_installer_url() {
  # TODO: Add actual download URL for DetectX Swift
  printf '%s\\n' 'https://example.com/detectxswift/installer'
}

maclib::security::detectxswift::latest_version() {
  # TODO: Add version detection for DetectX Swift
  return 1
}

maclib::security::detectxswift::is_installed() {
  [[ -d "/Applications/Detectx Swift.app" ]] || [[ -d "$HOME/Applications/Detectx Swift.app" ]]
}

maclib::security::detectxswift::installed_path() {
  if [[ -d "/Applications/Detectx Swift.app" ]]; then
    printf '%s\\n' "/Applications/Detectx Swift.app"
  elif [[ -d "$HOME/Applications/Detectx Swift.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Detectx Swift.app"
  fi
}

maclib::detectxswift::install() {
  local url tmp
  url="$(maclib::detectxswift::suite_installer_url)"
  tmp="$(mktemp -d -t "detectxswift.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "detectxswift::install: download failed"
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


maclib::security::detectxswift::update() {
  # No vendor update path documented for "DetectX Swift".
  maclib::core::log::error "detectxswift::update: no update path"
  return 127
}

maclib::security::detectxswift::uninstall() {
  # No clean uninstall for "DetectX Swift" (documented constraint).
  maclib::core::log::error "detectxswift::uninstall: no clean uninstall"
  return 1
}
