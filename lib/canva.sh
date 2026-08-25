#!/usr/bin/env bash
# shellcheck disable=all
# canva.sh - "Canva" (Installomator label) helpers
#
# Vendor source: Installomator label canva from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "5HD2ARTBFS".
# Installer type: "dmg".
#

maclib::canva::suite_installer_url() {
  https://desktop-release.canva.com/Canva-latest.dmg
}

maclib::canva::latest_version() {
  curl -fsLI -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -H "accept-encoding: gzip, deflate, br" -H "Referrer Policy: strict-origin-when-cross-origin" -H "upgrade-insecure-requests: 1" -H "sec-fetch-dest: document" -H "sec-gpc: 1" -H "sec-fetch-user: ?1" -H "accept-language: en-US,en;q=0.9" -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" -H "sec-fetch-mode: navigate" "https://www.canva.com/download/mac/intel/canva-desktop/" | grep -i "^location" | cut -d " " -f2 | tr -d '\r' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-*.*\.dmg/\1/g'
}

maclib::canva::is_installed() {
  [[ -d "/Applications/Canva.app" ]] || [[ -d "$HOME/Applications/Canva.app" ]]
}

maclib::canva::installed_path() {
  if [[ -d "/Applications/Canva.app" ]]; then
    printf "%s\n" "/Applications/Canva.app"
  elif [[ -d "$HOME/Applications/Canva.app" ]]; then
    printf "%s\n" "$HOME/Applications/Canva.app"
  fi
}

maclib::canva::install() {
  local url tmp
  url="$(maclib::canva::suite_installer_url)"
  tmp="$(mktemp -d -t "canva.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "canva::install: download failed"
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

maclib::canva::update() {
  # No vendor update path documented for "Canva".
  maclib::log::error "canva::update: no update path"
  return 127
}

maclib::canva::uninstall() {
  # No clean uninstall for "Canva" (documented constraint).
  maclib::log::error "canva::uninstall: no clean uninstall"
  return 1
}
