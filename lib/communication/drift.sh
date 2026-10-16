#!/usr/bin/env bash
# shellcheck disable=all
# drift.sh - Drift (Installomator label) helpers
#
# Vendor source: Installomator label drift from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::communication::drift::suite_installer_url() {
  # TODO: Add actual download URL for Drift
  printf '%s\\n' 'https://example.com/drift/installer'
}

maclib::communication::drift::latest_version() {
  # TODO: Add version detection for Drift
  return 1
}

maclib::communication::drift::is_installed() {
  [[ -d "/Applications/Drift.app" ]] || [[ -d "$HOME/Applications/Drift.app" ]]
}

maclib::communication::drift::installed_path() {
  if [[ -d "/Applications/Drift.app" ]]; then
    printf '%s\\n' "/Applications/Drift.app"
  elif [[ -d "$HOME/Applications/Drift.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Drift.app"
  fi
}

maclib::drift::install() {
  local url tmp mp app
  url="$(maclib::drift::suite_installer_url)"
  tmp="$(mktemp -d -t "drift.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "drift::install: download failed"
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


maclib::communication::drift::update() {
  # No vendor update path documented for "Drift".
  maclib::core::log::error "drift::update: no update path"
  return 127
}

maclib::communication::drift::uninstall() {
  # No clean uninstall for "Drift" (documented constraint).
  maclib::core::log::error "drift::uninstall: no clean uninstall"
  return 1
}
