#!/usr/bin/env bash
# shellcheck disable=all
# baseline-nodaemon.sh - "Baseline" (Installomator label) helpers
#
# Vendor source: Installomator label baseline-nodaemon from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "7Q6XP5698G".
# Installer type: "pkg".
#

maclib::baseline-nodaemon::suite_installer_url() {
  downloadURLFromGit secondsonconsulting Baseline
}

maclib::baseline-nodaemon::latest_version() {
  printf '%s\n' 'https://github.com/secondsonconsulting/Baseline/releases/latest/download/Baseline.pkg'
}

maclib::baseline-nodaemon::is_installed() {
  [[ -d "/Applications/Baseline.app" ]] || [[ -d "$HOME/Applications/Baseline.app" ]]
}

maclib::baseline-nodaemon::installed_path() {
  if [[ -d "/Applications/Baseline.app" ]]; then
    printf "%s\n" "/Applications/Baseline.app"
  elif [[ -d "$HOME/Applications/Baseline.app" ]]; then
    printf "%s\n" "$HOME/Applications/Baseline.app"
  fi
}

maclib::baseline-nodaemon::install() {
  local url tmp
  url="$(maclib::baseline-nodaemon::suite_installer_url)"
  tmp="$(mktemp -d -t "baseline-nodaemon.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "baseline-nodaemon::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::baseline-nodaemon::update() {
  # No vendor update path documented for "Baseline".
  maclib::log::error "baseline-nodaemon::update: no update path"
  return 127
}

maclib::baseline-nodaemon::uninstall() {
  # No clean uninstall for "Baseline" (documented constraint).
  maclib::log::error "baseline-nodaemon::uninstall: no clean uninstall"
  return 1
}
