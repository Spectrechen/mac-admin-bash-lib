#!/usr/bin/env bash
# shellcheck disable=all
# autopkgr.sh - "AutoPkgr" (Installomator label) helpers
#
# Vendor source: Installomator label autopkgr from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "JVY2ZR6SEF".
# Installer type: "dmg".
#

maclib::autopkgr::suite_installer_url() {
  downloadURLFromGit lindegroup autopkgr
}

maclib::autopkgr::latest_version() {
  versionFromGit lindegroup autopkgr
}

maclib::autopkgr::is_installed() {
  [[ -d "/Applications/AutoPkgr.app" ]] || [[ -d "$HOME/Applications/AutoPkgr.app" ]]
}

maclib::autopkgr::installed_path() {
  if [[ -d "/Applications/AutoPkgr.app" ]]; then
    printf "%s\n" "/Applications/AutoPkgr.app"
  elif [[ -d "$HOME/Applications/AutoPkgr.app" ]]; then
    printf "%s\n" "$HOME/Applications/AutoPkgr.app"
  fi
}

maclib::autopkgr::install() {
  local url tmp
  url="$(maclib::autopkgr::suite_installer_url)"
  tmp="$(mktemp -d -t "autopkgr.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "autopkgr::install: download failed"
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

maclib::autopkgr::update() {
  # No vendor update path documented for "AutoPkgr".
  maclib::log::error "autopkgr::update: no update path"
  return 127
}

maclib::autopkgr::uninstall() {
  # No clean uninstall for "AutoPkgr" (documented constraint).
  maclib::log::error "autopkgr::uninstall: no clean uninstall"
  return 1
}
