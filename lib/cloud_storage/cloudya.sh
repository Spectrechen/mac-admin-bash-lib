#!/usr/bin/env bash
# shellcheck disable=all
# cloudya.sh - Cloudya (Installomator label) helpers
#
# Vendor source: Installomator label cloudya from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "appInDmgInZip".
#

maclib::cloud_storage::cloudya::suite_installer_url() {
  # TODO: Add actual download URL for Cloudya
  printf '%s\\n' 'https://example.com/cloudya/installer'
}

maclib::cloud_storage::cloudya::latest_version() {
  # TODO: Add version detection for Cloudya
  return 1
}

maclib::cloud_storage::cloudya::is_installed() {
  [[ -d "/Applications/Cloudya.app" ]] || [[ -d "$HOME/Applications/Cloudya.app" ]]
}

maclib::cloud_storage::cloudya::installed_path() {
  if [[ -d "/Applications/Cloudya.app" ]]; then
    printf '%s\\n' "/Applications/Cloudya.app"
  elif [[ -d "$HOME/Applications/Cloudya.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cloudya.app"
  fi
}

maclib::cloudya::install() {
  local url tmp mp app
  url="$(maclib::cloudya::suite_installer_url)"
  tmp="$(mktemp -d -t "cloudya.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cloudya::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::cloud_storage::cloudya::update() {
  # No vendor update path documented for "Cloudya".
  maclib::core::log::error "cloudya::update: no update path"
  return 127
}

maclib::cloud_storage::cloudya::uninstall() {
  # No clean uninstall for "Cloudya" (documented constraint).
  maclib::core::log::error "cloudya::uninstall: no clean uninstall"
  return 1
}
