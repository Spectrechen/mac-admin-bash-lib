#!/usr/bin/env bash
# shellcheck disable=all
# aviatrix.sh - "Aviatrix VPN Client" (Installomator label) helpers
#
# Vendor source: Installomator label aviatrix from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "32953Z7NBN".
# Installer type: "pkg".
#

maclib::apps::a::aviatrix::suite_installer_url() {
  printf '%s\n' 'https://s3-us-west-2.amazonaws.com/aviatrix-download/AviatrixVPNClient/AVPNC_mac.pkg'
}

maclib::apps::a::aviatrix::latest_version() {
  printf '%s\n' ''
}

maclib::apps::a::aviatrix::is_installed() {
  [[ -d "/Applications/AviatrixVPNClient.app" ]] || [[ -d "$HOME/Applications/AviatrixVPNClient.app" ]]
}

maclib::apps::a::aviatrix::installed_path() {
  if [[ -d "/Applications/AviatrixVPNClient.app" ]]; then
    printf "%s\n" "/Applications/AviatrixVPNClient.app"
  elif [[ -d "$HOME/Applications/AviatrixVPNClient.app" ]]; then
    printf "%s\n" "$HOME/Applications/AviatrixVPNClient.app"
  fi
}

maclib::apps::a::aviatrix::install() {
  local url tmp
  url="$(maclib::apps::a::aviatrix::suite_installer_url)"
  tmp="$(mktemp -d -t "aviatrix.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "aviatrix::install: download failed"
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

maclib::apps::a::aviatrix::update() {
  # No vendor update path documented for "Aviatrix VPN Client".
  maclib::core::log::error "aviatrix::update: no update path"
  return 127
}

maclib::apps::a::aviatrix::uninstall() {
  # No clean uninstall for "Aviatrix VPN Client" (documented constraint).
  maclib::core::log::error "aviatrix::uninstall: no clean uninstall"
  return 1
}
