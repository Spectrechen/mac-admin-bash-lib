#!/usr/bin/env bash
# shellcheck disable=all
# archiwarepst.sh - "P5" (Installomator label) helpers
#
# Vendor source: Installomator label archiwarepst from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "5H5EU6F965".
# Package ID: "com.archiware.presstore".
# Installer type: "pkgInDmg".
#

maclib::archiwarepst::suite_installer_url() {
  appNrVersion=$(sed 's/[^0-9]//g' <<<$appNewVersion) && echo https://p5-downloads.s3.amazonaws.com/awpst"$appNrVersion"-darwin.dmg
}

maclib::archiwarepst::latest_version() {
  curl -sf https://www.archiware.com/download-p5 | grep -m 1 "ARCHIWARE P5 Version" | sed "s|.*Version \(.*\) -.*|\\1|"
}

maclib::archiwarepst::is_installed() {
  pkgutil --pkg-info ""com.archiware.presstore"" >/dev/null 2>&1
}

maclib::archiwarepst::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.archiware.presstore"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::archiwarepst::install() {
  local url tmp
  url="$(maclib::archiwarepst::suite_installer_url)"
  tmp="$(mktemp -d -t "archiwarepst.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "archiwarepst::install: download failed"
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

maclib::archiwarepst::update() {
  # No vendor update path documented for "P5".
  maclib::log::error "archiwarepst::update: no update path"
  return 127
}

maclib::archiwarepst::uninstall() {
  # No clean uninstall for "P5"; removing package receipt ""com.archiware.presstore"".
  pkgutil --forget ""com.archiware.presstore""
  return $?
}
