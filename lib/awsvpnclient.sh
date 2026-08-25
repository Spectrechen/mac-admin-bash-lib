#!/usr/bin/env bash
# shellcheck disable=all
# awsvpnclient.sh - "AWS VPN Client" (Installomator label) helpers
#
# Vendor source: Installomator label awsvpnclient from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "94KV3E626L".
# Installer type: "pkg".
#

maclib::awsvpnclient::suite_installer_url() {
  local appNewVersion
  appNewVersion=curl -s "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-user-guide.rss" | grep -o 'AWS provided client ([0-9]*\.[0-9]*\.[0-9]*) for macOS' | head -1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*'
  ${baseURL}/${appNewVersion}/AWS_VPN_Client.pkg
}

maclib::awsvpnclient::latest_version() {
  curl -s "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-user-guide.rss" | grep -o 'AWS provided client ([0-9]*\.[0-9]*\.[0-9]*) for macOS' | head -1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*'
}

maclib::awsvpnclient::is_installed() {
  [[ -d "/Applications/AWSVPNClient.app" ]] || [[ -d "$HOME/Applications/AWSVPNClient.app" ]]
}

maclib::awsvpnclient::installed_path() {
  if [[ -d "/Applications/AWSVPNClient.app" ]]; then
    printf "%s\n" "/Applications/AWSVPNClient.app"
  elif [[ -d "$HOME/Applications/AWSVPNClient.app" ]]; then
    printf "%s\n" "$HOME/Applications/AWSVPNClient.app"
  fi
}

maclib::awsvpnclient::install() {
  local url tmp
  url="$(maclib::awsvpnclient::suite_installer_url)"
  tmp="$(mktemp -d -t "awsvpnclient.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "awsvpnclient::install: download failed"
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

maclib::awsvpnclient::update() {
  # No vendor update path documented for "AWS VPN Client".
  maclib::log::error "awsvpnclient::update: no update path"
  return 127
}

maclib::awsvpnclient::uninstall() {
  # No clean uninstall for "AWS VPN Client" (documented constraint).
  maclib::log::error "awsvpnclient::uninstall: no clean uninstall"
  return 1
}
