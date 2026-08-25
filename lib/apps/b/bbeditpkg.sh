#!/usr/bin/env bash
# shellcheck disable=all
# bbeditpkg.sh - "BBEdit" (Installomator label) helpers
#
# Vendor source: Installomator label bbeditpkg from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "W52GZAXT98".
# Installer type: "pkg".
#

maclib::bbeditpkg::suite_installer_url() {
  curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort | tail -n1 | cut -d">" -f2 | cut -d"<" -f1 | sed 's/dmg/pkg/'
}

maclib::bbeditpkg::latest_version() {
  curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort | tail -n1 | sed -E 's/.*BBEdit_([0-9 .]*)\.dmg.*/\1/'
}

maclib::bbeditpkg::is_installed() {
  [[ -d "/Applications/BBEdit.app" ]] || [[ -d "$HOME/Applications/BBEdit.app" ]]
}

maclib::bbeditpkg::installed_path() {
  if [[ -d "/Applications/BBEdit.app" ]]; then
    printf "%s\n" "/Applications/BBEdit.app"
  elif [[ -d "$HOME/Applications/BBEdit.app" ]]; then
    printf "%s\n" "$HOME/Applications/BBEdit.app"
  fi
}

maclib::bbeditpkg::install() {
  local url tmp
  url="$(maclib::bbeditpkg::suite_installer_url)"
  tmp="$(mktemp -d -t "bbeditpkg.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bbeditpkg::install: download failed"
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

maclib::bbeditpkg::update() {
  # No vendor update path documented for "BBEdit".
  maclib::log::error "bbeditpkg::update: no update path"
  return 127
}

maclib::bbeditpkg::uninstall() {
  # No clean uninstall for "BBEdit" (documented constraint).
  maclib::log::error "bbeditpkg::uninstall: no clean uninstall"
  return 1
}
