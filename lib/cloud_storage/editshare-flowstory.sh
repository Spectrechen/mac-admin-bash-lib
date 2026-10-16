#!/usr/bin/env bash
# shellcheck disable=all
# editshare-flowstory.sh - FLOW Story (Installomator label) helpers
#
# Vendor source: Installomator label editshare-flowstory from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::cloud_storage::editshare-flowstory::suite_installer_url() {
  # TODO: Add actual download URL for FLOW Story
  printf '%s\\n' 'https://example.com/editshare-flowstory/installer'
}

maclib::cloud_storage::editshare-flowstory::latest_version() {
  # TODO: Add version detection for FLOW Story
  return 1
}

maclib::cloud_storage::editshare-flowstory::is_installed() {
  [[ -d "/Applications/Flow Story.app" ]] || [[ -d "$HOME/Applications/Flow Story.app" ]]
}

maclib::cloud_storage::editshare-flowstory::installed_path() {
  if [[ -d "/Applications/Flow Story.app" ]]; then
    printf '%s\\n' "/Applications/Flow Story.app"
  elif [[ -d "$HOME/Applications/Flow Story.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Flow Story.app"
  fi
}

maclib::editshare-flowstory::install() {
  local url tmp mp app
  url="$(maclib::editshare-flowstory::suite_installer_url)"
  tmp="$(mktemp -d -t "editshare-flowstory.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "editshare-flowstory::install: download failed"
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


maclib::cloud_storage::editshare-flowstory::update() {
  # No vendor update path documented for "FLOW Story".
  maclib::core::log::error "editshare-flowstory::update: no update path"
  return 127
}

maclib::cloud_storage::editshare-flowstory::uninstall() {
  # No clean uninstall for "FLOW Story" (documented constraint).
  maclib::core::log::error "editshare-flowstory::uninstall: no clean uninstall"
  return 1
}
