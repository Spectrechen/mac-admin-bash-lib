#!/usr/bin/env bash
# shellcheck disable=all
# escrowbuddy.sh - Escrow Buddy (Installomator label) helpers
#
# Vendor source: Installomator label escrowbuddy from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::productivity::escrowbuddy::suite_installer_url() {
  # TODO: Add actual download URL for Escrow Buddy
  printf '%s\\n' 'https://example.com/escrowbuddy/installer'
}

maclib::productivity::escrowbuddy::latest_version() {
  # TODO: Add version detection for Escrow Buddy
  return 1
}

maclib::productivity::escrowbuddy::is_installed() {
  [[ -d "/Applications/Escrow Buddy.app" ]] || [[ -d "$HOME/Applications/Escrow Buddy.app" ]]
}

maclib::productivity::escrowbuddy::installed_path() {
  if [[ -d "/Applications/Escrow Buddy.app" ]]; then
    printf '%s\\n' "/Applications/Escrow Buddy.app"
  elif [[ -d "$HOME/Applications/Escrow Buddy.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Escrow Buddy.app"
  fi
}

maclib::escrowbuddy::install() {
  local url tmp
  url="$(maclib::escrowbuddy::suite_installer_url)"
  tmp="$(mktemp -t "escrowbuddy_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "escrowbuddy::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::productivity::escrowbuddy::update() {
  # No vendor update path documented for "Escrow Buddy".
  maclib::core::log::error "escrowbuddy::update: no update path"
  return 127
}

maclib::productivity::escrowbuddy::uninstall() {
  # No clean uninstall for "Escrow Buddy" (documented constraint).
  maclib::core::log::error "escrowbuddy::uninstall: no clean uninstall"
  return 1
}
