#!/usr/bin/env bash
# shellcheck disable=all
# arturiasoftwarecenter.sh - "Arturia Software Center" (Installomator label) helpers
#
# Vendor source: Installomator label arturiasoftwarecenter from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "T53ZHSF36C".
# Package ID: "com.Arturia.ArturiaSoftwareCenter.resources".
# Installer type: "pkg".
#

maclib::apps::a::arturiasoftwarecenter::suite_installer_url() {
  getJSONValue "$arturiaDetails" "[$arturiaCount].permalink"
}

maclib::apps::a::arturiasoftwarecenter::latest_version() {
  getJSONValue "$arturiaDetails" "[$arturiaCount].version"
}

maclib::apps::a::arturiasoftwarecenter::is_installed() {
  pkgutil --pkg-info ""com.Arturia.ArturiaSoftwareCenter.resources"" >/dev/null 2>&1
}

maclib::apps::a::arturiasoftwarecenter::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.Arturia.ArturiaSoftwareCenter.resources"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::a::arturiasoftwarecenter::install() {
  local url tmp
  url="$(maclib::apps::a::arturiasoftwarecenter::suite_installer_url)"
  tmp="$(mktemp -d -t "arturiasoftwarecenter.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "arturiasoftwarecenter::install: download failed"
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

maclib::apps::a::arturiasoftwarecenter::update() {
  # No vendor update path documented for "Arturia Software Center".
  maclib::core::log::error "arturiasoftwarecenter::update: no update path"
  return 127
}

maclib::apps::a::arturiasoftwarecenter::uninstall() {
  # No clean uninstall for "Arturia Software Center"; removing package receipt ""com.Arturia.ArturiaSoftwareCenter.resources"".
  pkgutil --forget ""com.Arturia.ArturiaSoftwareCenter.resources""
  return $?
}
