#!/usr/bin/env bash
# shellcheck disable=all
# calcservice.sh - "CalcService" (Installomator label) helpers
#
# Vendor source: Installomator label calcservice from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "679S2QUWR8".
# Installer type: "zip".
#

maclib::calcservice::suite_installer_url() {
  curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" "https://www.devontechnologies.com/support/download" | tr '"' "\n" | grep -o "http.*download.*.zip" | grep -i calcservice | head -1
}

maclib::calcservice::latest_version() {
  echo $downloadURL | sed -E 's/.*\/([0-9.]*)\/.*/\1/g'
}

maclib::calcservice::is_installed() {
  [[ -d "/Applications/CalcService.app" ]] || [[ -d "$HOME/Applications/CalcService.app" ]]
}

maclib::calcservice::installed_path() {
  if [[ -d "/Applications/CalcService.app" ]]; then
    printf "%s\n" "/Applications/CalcService.app"
  elif [[ -d "$HOME/Applications/CalcService.app" ]]; then
    printf "%s\n" "$HOME/Applications/CalcService.app"
  fi
}

maclib::calcservice::install() {
  local url tmp
  url="$(maclib::calcservice::suite_installer_url)"
  tmp="$(mktemp -d -t "calcservice.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "calcservice::install: download failed"
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

maclib::calcservice::update() {
  # No vendor update path documented for "CalcService".
  maclib::log::error "calcservice::update: no update path"
  return 127
}

maclib::calcservice::uninstall() {
  # No clean uninstall for "CalcService" (documented constraint).
  maclib::log::error "calcservice::uninstall: no clean uninstall"
  return 1
}
