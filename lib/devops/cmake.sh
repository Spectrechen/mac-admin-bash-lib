#!/usr/bin/env bash
# shellcheck disable=all
# cmake.sh - CMake (Installomator label) helpers
#
# Vendor source: Installomator label cmake from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::devops::cmake::suite_installer_url() {
  # TODO: Add actual download URL for CMake
  printf '%s\\n' 'https://example.com/cmake/installer'
}

maclib::devops::cmake::latest_version() {
  # TODO: Add version detection for CMake
  return 1
}

maclib::devops::cmake::is_installed() {
  [[ -d "/Applications/Cmake.app" ]] || [[ -d "$HOME/Applications/Cmake.app" ]]
}

maclib::devops::cmake::installed_path() {
  if [[ -d "/Applications/Cmake.app" ]]; then
    printf '%s\\n' "/Applications/Cmake.app"
  elif [[ -d "$HOME/Applications/Cmake.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cmake.app"
  fi
}

maclib::cmake::install() {
  local url tmp mp app
  url="$(maclib::cmake::suite_installer_url)"
  tmp="$(mktemp -d -t "cmake.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cmake::install: download failed"
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


maclib::devops::cmake::update() {
  # No vendor update path documented for "CMake".
  maclib::core::log::error "cmake::update: no update path"
  return 127
}

maclib::devops::cmake::uninstall() {
  # No clean uninstall for "CMake" (documented constraint).
  maclib::core::log::error "cmake::uninstall: no clean uninstall"
  return 1
}
