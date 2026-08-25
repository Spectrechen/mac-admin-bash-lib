#!/usr/bin/env bash
# shellcheck disable=all
# calibre.sh - "calibre" (Installomator label) helpers
#
# Vendor source: Installomator label calibre from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "NTY7FVCEKP".
# Installer type: "dmg".
#

maclib::calibre::suite_installer_url() {
  downloadURLFromGit kovidgoyal calibre
}

maclib::calibre::latest_version() {
  versionFromGit kovidgoyal calibre
}

maclib::calibre::is_installed() {
  [[ -d "/Applications/calibre.app" ]] || [[ -d "$HOME/Applications/calibre.app" ]]
}

maclib::calibre::installed_path() {
  if [[ -d "/Applications/calibre.app" ]]; then
    printf "%s\n" "/Applications/calibre.app"
  elif [[ -d "$HOME/Applications/calibre.app" ]]; then
    printf "%s\n" "$HOME/Applications/calibre.app"
  fi
}

maclib::calibre::install() {
  local url tmp
  url="$(maclib::calibre::suite_installer_url)"
  tmp="$(mktemp -d -t "calibre.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "calibre::install: download failed"
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

maclib::calibre::update() {
  # No vendor update path documented for "calibre".
  maclib::log::error "calibre::update: no update path"
  return 127
}

maclib::calibre::uninstall() {
  # No clean uninstall for "calibre" (documented constraint).
  maclib::log::error "calibre::uninstall: no clean uninstall"
  return 1
}
