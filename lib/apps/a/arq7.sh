#!/usr/bin/env bash
# shellcheck disable=all
# arq7.sh - "Arq7" (Installomator label) helpers
#
# Vendor source: Installomator label arq7 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "48ZCSDVL96".
# Package ID: "com.haystacksoftware.Arq".
# Installer type: "pkg".
#

maclib::arq7::suite_installer_url() {
  https://arqbackup.com/download/arqbackup/Arq7.pkg
}

maclib::arq7::latest_version() {
  curl -fs "https://arqbackup.com" | grep -io "version .*[0-9.]*.* for macOS" | cut -d ">" -f2 | cut -d "<" -f1
}

maclib::arq7::is_installed() {
  pkgutil --pkg-info ""com.haystacksoftware.Arq"" >/dev/null 2>&1
}

maclib::arq7::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.haystacksoftware.Arq"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::arq7::install() {
  local url tmp
  url="$(maclib::arq7::suite_installer_url)"
  tmp="$(mktemp -d -t "arq7.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "arq7::install: download failed"
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

maclib::arq7::update() {
  # No vendor update path documented for "Arq7".
  maclib::log::error "arq7::update: no update path"
  return 127
}

maclib::arq7::uninstall() {
  # No clean uninstall for "Arq7"; removing package receipt ""com.haystacksoftware.Arq"".
  pkgutil --forget ""com.haystacksoftware.Arq""
  return $?
}
