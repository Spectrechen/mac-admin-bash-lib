#!/usr/bin/env bash
# shellcheck disable=all
# boxtools.sh - "Box Tools" (Installomator label) helpers
#
# Vendor source: Installomator label boxtools from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "M683GB7CPW".
# Package ID: "com.box.boxtools.installer.boxedit".
# Installer type: "pkg".
#

maclib::apps::b::boxtools::suite_installer_url() {
  printf '%s\n' 'https://box-installers.s3.amazonaws.com/boxedit/mac/currentrelease/BoxToolsInstaller.pkg'
}

maclib::apps::b::boxtools::latest_version() {
  printf '%s\n' ''
}

maclib::apps::b::boxtools::is_installed() {
  pkgutil --pkg-info ""com.box.boxtools.installer.boxedit"" >/dev/null 2>&1
}

maclib::apps::b::boxtools::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.box.boxtools.installer.boxedit"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::b::boxtools::install() {
  local url tmp
  url="$(maclib::apps::b::boxtools::suite_installer_url)"
  tmp="$(mktemp -d -t "boxtools.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "boxtools::install: download failed"
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

maclib::apps::b::boxtools::update() {
  # No vendor update path documented for "Box Tools".
  maclib::core::log::error "boxtools::update: no update path"
  return 127
}

maclib::apps::b::boxtools::uninstall() {
  # No clean uninstall for "Box Tools"; removing package receipt ""com.box.boxtools.installer.boxedit"".
  pkgutil --forget ""com.box.boxtools.installer.boxedit""
  return $?
}
