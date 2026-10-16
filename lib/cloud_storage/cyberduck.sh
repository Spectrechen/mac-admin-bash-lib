#!/usr/bin/env bash
# shellcheck disable=all
# cyberduck.sh - Cyberduck (Installomator label) helpers
#
# Vendor source: Installomator label cyberduck from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::cloud_storage::cyberduck::suite_installer_url() {
  # TODO: Add actual download URL for Cyberduck
  printf '%s\\n' 'https://example.com/cyberduck/installer'
}

maclib::cloud_storage::cyberduck::latest_version() {
  # TODO: Add version detection for Cyberduck
  return 1
}

maclib::cloud_storage::cyberduck::is_installed() {
  [[ -d "/Applications/Cyberduck.app" ]] || [[ -d "$HOME/Applications/Cyberduck.app" ]]
}

maclib::cloud_storage::cyberduck::installed_path() {
  if [[ -d "/Applications/Cyberduck.app" ]]; then
    printf '%s\\n' "/Applications/Cyberduck.app"
  elif [[ -d "$HOME/Applications/Cyberduck.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cyberduck.app"
  fi
}

maclib::cyberduck::install() {
  local url tmp
  url="$(maclib::cyberduck::suite_installer_url)"
  tmp="$(mktemp -d -t "cyberduck.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "cyberduck::install: download failed"
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


maclib::cloud_storage::cyberduck::update() {
  # No vendor update path documented for "Cyberduck".
  maclib::core::log::error "cyberduck::update: no update path"
  return 127
}

maclib::cloud_storage::cyberduck::uninstall() {
  # No clean uninstall for "Cyberduck" (documented constraint).
  maclib::core::log::error "cyberduck::uninstall: no clean uninstall"
  return 1
}
