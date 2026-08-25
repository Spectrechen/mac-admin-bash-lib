#!/usr/bin/env bash
# shellcheck disable=all
# axurerp10.sh - "Axure RP 10" (Installomator label) helpers
#
# Vendor source: Installomator label axurerp10 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "HUMW6UU796".
# Installer type: "dmg".
#

maclib::axurerp10::suite_installer_url() {
  curl -s https://www.axure.com/release-history/rp10 | grep -oE 'https://[^ ]+.dmg' | grep -v arm64 | head -n 1
}

maclib::axurerp10::latest_version() {
  curl -sL https://www.axure.com/release-history/rp10 | grep -oE '[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}' | head -n 1
}

maclib::axurerp10::is_installed() {
  [[ -d "/Applications/AxureRP10.app" ]] || [[ -d "$HOME/Applications/AxureRP10.app" ]]
}

maclib::axurerp10::installed_path() {
  if [[ -d "/Applications/AxureRP10.app" ]]; then
    printf "%s\n" "/Applications/AxureRP10.app"
  elif [[ -d "$HOME/Applications/AxureRP10.app" ]]; then
    printf "%s\n" "$HOME/Applications/AxureRP10.app"
  fi
}

maclib::axurerp10::install() {
  local url tmp
  url="$(maclib::axurerp10::suite_installer_url)"
  tmp="$(mktemp -d -t "axurerp10.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "axurerp10::install: download failed"
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

maclib::axurerp10::update() {
  # No vendor update path documented for "Axure RP 10".
  maclib::log::error "axurerp10::update: no update path"
  return 127
}

maclib::axurerp10::uninstall() {
  # No clean uninstall for "Axure RP 10" (documented constraint).
  maclib::log::error "axurerp10::uninstall: no clean uninstall"
  return 1
}
