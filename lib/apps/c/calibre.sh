#!/usr/bin/env bash
# shellcheck disable=all
# calibre.sh - "calibre" (Installomator label) helpers
#
# Vendor source: Installomator label calibre from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "NTY7FVCEKP".
# Installer type: "dmg".
#

maclib::apps::c::calibre::suite_installer_url() {
  downloadURLFromGit kovidgoyal calibre
}

maclib::apps::c::calibre::latest_version() {
  versionFromGit kovidgoyal calibre
}

maclib::apps::c::calibre::is_installed() {
  [[ -d "/Applications/calibre.app" ]] || [[ -d "$HOME/Applications/calibre.app" ]]
}

maclib::apps::c::calibre::installed_path() {
  if [[ -d "/Applications/calibre.app" ]]; then
    printf "%s\n" "/Applications/calibre.app"
  elif [[ -d "$HOME/Applications/calibre.app" ]]; then
    printf "%s\n" "$HOME/Applications/calibre.app"
  fi
}

maclib::apps::c::calibre::install() {
  local url tmp
  url="$(maclib::apps::c::calibre::suite_installer_url)"
  tmp="$(mktemp -d -t "calibre.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "calibre::install: download failed"
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

maclib::apps::c::calibre::update() {
  # No vendor update path documented for "calibre".
  maclib::core::log::error "calibre::update: no update path"
  return 127
}

maclib::apps::c::calibre::uninstall() {
  # No clean uninstall for "calibre" (documented constraint).
  maclib::core::log::error "calibre::uninstall: no clean uninstall"
  return 1
}
