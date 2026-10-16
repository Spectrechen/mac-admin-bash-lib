#!/usr/bin/env bash
# shellcheck disable=all
# easyfind.sh - EasyFind (Installomator label) helpers
#
# Vendor source: Installomator label easyfind from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::apps/e::easyfind::suite_installer_url() {
  # TODO: Add actual download URL for EasyFind
  printf '%s\\n' 'https://example.com/easyfind/installer'
}

maclib::apps/e::easyfind::latest_version() {
  # TODO: Add version detection for EasyFind
  return 1
}

maclib::apps/e::easyfind::is_installed() {
  [[ -d "/Applications/Easyfind.app" ]] || [[ -d "$HOME/Applications/Easyfind.app" ]]
}

maclib::apps/e::easyfind::installed_path() {
  if [[ -d "/Applications/Easyfind.app" ]]; then
    printf '%s\\n' "/Applications/Easyfind.app"
  elif [[ -d "$HOME/Applications/Easyfind.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Easyfind.app"
  fi
}

maclib::easyfind::install() {
  local url tmp
  url="$(maclib::easyfind::suite_installer_url)"
  tmp="$(mktemp -d -t "easyfind.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "easyfind::install: download failed"
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


maclib::apps/e::easyfind::update() {
  # No vendor update path documented for "EasyFind".
  maclib::core::log::error "easyfind::update: no update path"
  return 127
}

maclib::apps/e::easyfind::uninstall() {
  # No clean uninstall for "EasyFind" (documented constraint).
  maclib::core::log::error "easyfind::uninstall: no clean uninstall"
  return 1
}
