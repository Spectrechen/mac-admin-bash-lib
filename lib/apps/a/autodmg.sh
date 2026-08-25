#!/usr/bin/env bash
# shellcheck disable=all
# autodmg.sh - "AutoDMG" (Installomator label) helpers
#
# Vendor source: Installomator label autodmg from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "5KQ3D3FG5H".
# Installer type: "dmg".
#

maclib::autodmg::suite_installer_url() {
  downloadURLFromGit MagerValp AutoDMG
}

maclib::autodmg::latest_version() {
  versionFromGit MagerValp AutoDMG
}

maclib::autodmg::is_installed() {
  [[ -d "/Applications/AutoDMG.app" ]] || [[ -d "$HOME/Applications/AutoDMG.app" ]]
}

maclib::autodmg::installed_path() {
  if [[ -d "/Applications/AutoDMG.app" ]]; then
    printf "%s\n" "/Applications/AutoDMG.app"
  elif [[ -d "$HOME/Applications/AutoDMG.app" ]]; then
    printf "%s\n" "$HOME/Applications/AutoDMG.app"
  fi
}

maclib::autodmg::install() {
  local url tmp
  url="$(maclib::autodmg::suite_installer_url)"
  tmp="$(mktemp -d -t "autodmg.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "autodmg::install: download failed"
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

maclib::autodmg::update() {
  # No vendor update path documented for "AutoDMG".
  maclib::log::error "autodmg::update: no update path"
  return 127
}

maclib::autodmg::uninstall() {
  # No clean uninstall for "AutoDMG" (documented constraint).
  maclib::log::error "autodmg::uninstall: no clean uninstall"
  return 1
}
