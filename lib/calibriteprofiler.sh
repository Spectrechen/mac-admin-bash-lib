#!/usr/bin/env bash
# shellcheck disable=all
# calibriteprofiler.sh - "calibrite PROFILER" (Installomator label) helpers
#
# Vendor source: Installomator label calibriteprofiler from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "5C392763F5".
# Installer type: "dmg".
#

maclib::calibriteprofiler::suite_installer_url() {
  downloadURLFromGit LUMESCA calibrite-profiler-releases
}

maclib::calibriteprofiler::latest_version() {
  versionFromGit LUMESCA calibrite-profiler-releases
}

maclib::calibriteprofiler::is_installed() {
  [[ -d "/Applications/calibritePROFILER.app" ]] || [[ -d "$HOME/Applications/calibritePROFILER.app" ]]
}

maclib::calibriteprofiler::installed_path() {
  if [[ -d "/Applications/calibritePROFILER.app" ]]; then
    printf "%s\n" "/Applications/calibritePROFILER.app"
  elif [[ -d "$HOME/Applications/calibritePROFILER.app" ]]; then
    printf "%s\n" "$HOME/Applications/calibritePROFILER.app"
  fi
}

maclib::calibriteprofiler::install() {
  local url tmp
  url="$(maclib::calibriteprofiler::suite_installer_url)"
  tmp="$(mktemp -d -t "calibriteprofiler.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "calibriteprofiler::install: download failed"
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

maclib::calibriteprofiler::update() {
  # No vendor update path documented for "calibrite PROFILER".
  maclib::log::error "calibriteprofiler::update: no update path"
  return 127
}

maclib::calibriteprofiler::uninstall() {
  # No clean uninstall for "calibrite PROFILER" (documented constraint).
  maclib::log::error "calibriteprofiler::uninstall: no clean uninstall"
  return 1
}
