#!/usr/bin/env bash
# shellcheck disable=all
# dynalist.sh - Dynalist (Installomator label) helpers
#
# Vendor source: Installomator label dynalist from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::dynalist::suite_installer_url() {
  # TODO: Add actual download URL for Dynalist
  printf '%s\\n' 'https://example.com/dynalist/installer'
}

maclib::productivity::dynalist::latest_version() {
  # TODO: Add version detection for Dynalist
  return 1
}

maclib::productivity::dynalist::is_installed() {
  [[ -d "/Applications/Dynalist.app" ]] || [[ -d "$HOME/Applications/Dynalist.app" ]]
}

maclib::productivity::dynalist::installed_path() {
  if [[ -d "/Applications/Dynalist.app" ]]; then
    printf '%s\\n' "/Applications/Dynalist.app"
  elif [[ -d "$HOME/Applications/Dynalist.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dynalist.app"
  fi
}

maclib::dynalist::install() {
  local url tmp mp app
  url="$(maclib::dynalist::suite_installer_url)"
  tmp="$(mktemp -d -t "dynalist.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dynalist::install: download failed"
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


maclib::productivity::dynalist::update() {
  # No vendor update path documented for "Dynalist".
  maclib::core::log::error "dynalist::update: no update path"
  return 127
}

maclib::productivity::dynalist::uninstall() {
  # No clean uninstall for "Dynalist" (documented constraint).
  maclib::core::log::error "dynalist::uninstall: no clean uninstall"
  return 1
}
