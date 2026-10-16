#!/usr/bin/env bash
# shellcheck disable=all
# dbvisualizer.sh - DbVisualizer (Installomator label) helpers
#
# Vendor source: Installomator label dbvisualizer from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::devops::dbvisualizer::suite_installer_url() {
  # TODO: Add actual download URL for DbVisualizer
  printf '%s\\n' 'https://example.com/dbvisualizer/installer'
}

maclib::devops::dbvisualizer::latest_version() {
  # TODO: Add version detection for DbVisualizer
  return 1
}

maclib::devops::dbvisualizer::is_installed() {
  [[ -d "/Applications/Dbvisualizer.app" ]] || [[ -d "$HOME/Applications/Dbvisualizer.app" ]]
}

maclib::devops::dbvisualizer::installed_path() {
  if [[ -d "/Applications/Dbvisualizer.app" ]]; then
    printf '%s\\n' "/Applications/Dbvisualizer.app"
  elif [[ -d "$HOME/Applications/Dbvisualizer.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dbvisualizer.app"
  fi
}

maclib::dbvisualizer::install() {
  local url tmp mp app
  url="$(maclib::dbvisualizer::suite_installer_url)"
  tmp="$(mktemp -d -t "dbvisualizer.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dbvisualizer::install: download failed"
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


maclib::devops::dbvisualizer::update() {
  # No vendor update path documented for "DbVisualizer".
  maclib::core::log::error "dbvisualizer::update: no update path"
  return 127
}

maclib::devops::dbvisualizer::uninstall() {
  # No clean uninstall for "DbVisualizer" (documented constraint).
  maclib::core::log::error "dbvisualizer::uninstall: no clean uninstall"
  return 1
}
