#!/usr/bin/env bash
# shellcheck disable=all
# deon-onprem.sh - Deon (Installomator label) helpers
#
# Vendor source: Installomator label deon-onprem from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::apps/d::deon-onprem::suite_installer_url() {
  # TODO: Add actual download URL for Deon
  printf '%s\\n' 'https://example.com/deon-onprem/installer'
}

maclib::apps/d::deon-onprem::latest_version() {
  # TODO: Add version detection for Deon
  return 1
}

maclib::apps/d::deon-onprem::is_installed() {
  [[ -d "/Applications/Deon.app" ]] || [[ -d "$HOME/Applications/Deon.app" ]]
}

maclib::apps/d::deon-onprem::installed_path() {
  if [[ -d "/Applications/Deon.app" ]]; then
    printf '%s\\n' "/Applications/Deon.app"
  elif [[ -d "$HOME/Applications/Deon.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Deon.app"
  fi
}

maclib::deon-onprem::install() {
  local url tmp
  url="$(maclib::deon-onprem::suite_installer_url)"
  tmp="$(mktemp -d -t "deon-onprem.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "deon-onprem::install: download failed"
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


maclib::apps/d::deon-onprem::update() {
  # No vendor update path documented for "Deon".
  maclib::core::log::error "deon-onprem::update: no update path"
  return 127
}

maclib::apps/d::deon-onprem::uninstall() {
  # No clean uninstall for "Deon" (documented constraint).
  maclib::core::log::error "deon-onprem::uninstall: no clean uninstall"
  return 1
}
