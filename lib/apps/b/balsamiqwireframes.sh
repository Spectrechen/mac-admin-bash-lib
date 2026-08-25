#!/usr/bin/env bash
# shellcheck disable=all
# balsamiqwireframes.sh - "Balsamiq Wireframes" (Installomator label) helpers
#
# Vendor source: Installomator label balsamiqwireframes from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "3DPKD72KQ7".
# Installer type: "dmg".
#

maclib::balsamiqwireframes::suite_installer_url() {
  printf '%s\n' 'https://builds.balsamiq.com/bwd/$(curl -fs "https://builds.balsamiq.com" | awk -F "<Key>bwd/" "/dmg/ {print \$3}" | awk -F "</Key>" "{print \$1}" | sed "s/ /%20/g")'
}

maclib::balsamiqwireframes::latest_version() {
  printf '%s\n' ''
}

maclib::balsamiqwireframes::is_installed() {
  [[ -d "/Applications/BalsamiqWireframes.app" ]] || [[ -d "$HOME/Applications/BalsamiqWireframes.app" ]]
}

maclib::balsamiqwireframes::installed_path() {
  if [[ -d "/Applications/BalsamiqWireframes.app" ]]; then
    printf "%s\n" "/Applications/BalsamiqWireframes.app"
  elif [[ -d "$HOME/Applications/BalsamiqWireframes.app" ]]; then
    printf "%s\n" "$HOME/Applications/BalsamiqWireframes.app"
  fi
}

maclib::balsamiqwireframes::install() {
  local url tmp
  url="$(maclib::balsamiqwireframes::suite_installer_url)"
  tmp="$(mktemp -d -t "balsamiqwireframes.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "balsamiqwireframes::install: download failed"
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

maclib::balsamiqwireframes::update() {
  # No vendor update path documented for "Balsamiq Wireframes".
  maclib::log::error "balsamiqwireframes::update: no update path"
  return 127
}

maclib::balsamiqwireframes::uninstall() {
  # No clean uninstall for "Balsamiq Wireframes" (documented constraint).
  maclib::log::error "balsamiqwireframes::uninstall: no clean uninstall"
  return 1
}
