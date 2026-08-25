#!/usr/bin/env bash
# shellcheck disable=all
# betterzip.sh - "BetterZip" (Installomator label) helpers
#
# Vendor source: Installomator label betterzip from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "79RR9LPM2N".
# Installer type: "zip".
#

maclib::betterzip::suite_installer_url() {
  https://macitbetter.com/BetterZip.zip
}

maclib::betterzip::latest_version() {
  curl -Ls https://macitbetter.com/version-history/ | awk 'match($0,/Version[[:space:]]+[0-9]+(\.[0-9]+)+/){print substr($0,RSTART,RLENGTH)}' | head -n1 | awk '{print $2}'
}

maclib::betterzip::is_installed() {
  [[ -d "/Applications/BetterZip.app" ]] || [[ -d "$HOME/Applications/BetterZip.app" ]]
}

maclib::betterzip::installed_path() {
  if [[ -d "/Applications/BetterZip.app" ]]; then
    printf "%s\n" "/Applications/BetterZip.app"
  elif [[ -d "$HOME/Applications/BetterZip.app" ]]; then
    printf "%s\n" "$HOME/Applications/BetterZip.app"
  fi
}

maclib::betterzip::install() {
  local url tmp
  url="$(maclib::betterzip::suite_installer_url)"
  tmp="$(mktemp -d -t "betterzip.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "betterzip::install: download failed"
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

maclib::betterzip::update() {
  # No vendor update path documented for "BetterZip".
  maclib::log::error "betterzip::update: no update path"
  return 127
}

maclib::betterzip::uninstall() {
  # No clean uninstall for "BetterZip" (documented constraint).
  maclib::log::error "betterzip::uninstall: no clean uninstall"
  return 1
}
