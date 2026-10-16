#!/usr/bin/env bash
# shellcheck disable=all
# defaultfolderx.sh - Default Folder X (Installomator label) helpers
#
# Vendor source: Installomator label defaultfolderx from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::defaultfolderx::suite_installer_url() {
  # TODO: Add actual download URL for Default Folder X
  printf '%s\\n' 'https://example.com/defaultfolderx/installer'
}

maclib::productivity::defaultfolderx::latest_version() {
  # TODO: Add version detection for Default Folder X
  return 1
}

maclib::productivity::defaultfolderx::is_installed() {
  [[ -d "/Applications/Default Folder X.app" ]] || [[ -d "$HOME/Applications/Default Folder X.app" ]]
}

maclib::productivity::defaultfolderx::installed_path() {
  if [[ -d "/Applications/Default Folder X.app" ]]; then
    printf '%s\\n' "/Applications/Default Folder X.app"
  elif [[ -d "$HOME/Applications/Default Folder X.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Default Folder X.app"
  fi
}

maclib::defaultfolderx::install() {
  local url tmp mp app
  url="$(maclib::defaultfolderx::suite_installer_url)"
  tmp="$(mktemp -d -t "defaultfolderx.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "defaultfolderx::install: download failed"
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


maclib::productivity::defaultfolderx::update() {
  # No vendor update path documented for "Default Folder X".
  maclib::core::log::error "defaultfolderx::update: no update path"
  return 127
}

maclib::productivity::defaultfolderx::uninstall() {
  # No clean uninstall for "Default Folder X" (documented constraint).
  maclib::core::log::error "defaultfolderx::uninstall: no clean uninstall"
  return 1
}
