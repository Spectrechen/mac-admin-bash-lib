#!/usr/bin/env bash
# shellcheck disable=all
# backgrounds.sh - "Backgrounds" (Installomator label) helpers
#
# Vendor source: Installomator label backgrounds from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "7R5ZEU67FQ".
# Installer type: "pkg".
#

maclib::apps::b::backgrounds::suite_installer_url() {
  downloadURLFromGit SAP backgrounds
}

maclib::apps::b::backgrounds::latest_version() {
  versionFromGit SAP backgrounds
}

maclib::apps::b::backgrounds::is_installed() {
  [[ -d "/Applications/Backgrounds.app" ]] || [[ -d "$HOME/Applications/Backgrounds.app" ]]
}

maclib::apps::b::backgrounds::installed_path() {
  if [[ -d "/Applications/Backgrounds.app" ]]; then
    printf "%s\n" "/Applications/Backgrounds.app"
  elif [[ -d "$HOME/Applications/Backgrounds.app" ]]; then
    printf "%s\n" "$HOME/Applications/Backgrounds.app"
  fi
}

maclib::apps::b::backgrounds::install() {
  local url tmp
  url="$(maclib::apps::b::backgrounds::suite_installer_url)"
  tmp="$(mktemp -d -t "backgrounds.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "backgrounds::install: download failed"
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

maclib::apps::b::backgrounds::update() {
  # No vendor update path documented for "Backgrounds".
  maclib::core::log::error "backgrounds::update: no update path"
  return 127
}

maclib::apps::b::backgrounds::uninstall() {
  # No clean uninstall for "Backgrounds" (documented constraint).
  maclib::core::log::error "backgrounds::uninstall: no clean uninstall"
  return 1
}
