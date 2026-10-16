#!/usr/bin/env bash
# shellcheck disable=all
# epicgameslauncher.sh - Epic Games Launcher (Installomator label) helpers
#
# Vendor source: Installomator label epicgameslauncher from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/e::epicgameslauncher::suite_installer_url() {
  # TODO: Add actual download URL for Epic Games Launcher
  printf '%s\\n' 'https://example.com/epicgameslauncher/installer'
}

maclib::apps/e::epicgameslauncher::latest_version() {
  # TODO: Add version detection for Epic Games Launcher
  return 1
}

maclib::apps/e::epicgameslauncher::is_installed() {
  [[ -d "/Applications/Epic Games Launcher.app" ]] || [[ -d "$HOME/Applications/Epic Games Launcher.app" ]]
}

maclib::apps/e::epicgameslauncher::installed_path() {
  if [[ -d "/Applications/Epic Games Launcher.app" ]]; then
    printf '%s\\n' "/Applications/Epic Games Launcher.app"
  elif [[ -d "$HOME/Applications/Epic Games Launcher.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Epic Games Launcher.app"
  fi
}

maclib::epicgameslauncher::install() {
  local url tmp mp app
  url="$(maclib::epicgameslauncher::suite_installer_url)"
  tmp="$(mktemp -d -t "epicgameslauncher.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "epicgameslauncher::install: download failed"
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


maclib::apps/e::epicgameslauncher::update() {
  # No vendor update path documented for "Epic Games Launcher".
  maclib::core::log::error "epicgameslauncher::update: no update path"
  return 127
}

maclib::apps/e::epicgameslauncher::uninstall() {
  # No clean uninstall for "Epic Games Launcher" (documented constraint).
  maclib::core::log::error "epicgameslauncher::uninstall: no clean uninstall"
  return 1
}
