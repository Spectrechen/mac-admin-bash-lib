#!/usr/bin/env bash
# shellcheck disable=all
# enpass.sh - Enpass (Installomator label) helpers
#
# Vendor source: Installomator label enpass from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::productivity::enpass::suite_installer_url() {
  # TODO: Add actual download URL for Enpass
  printf '%s\\n' 'https://example.com/enpass/installer'
}

maclib::productivity::enpass::latest_version() {
  # TODO: Add version detection for Enpass
  return 1
}

maclib::productivity::enpass::is_installed() {
  [[ -d "/Applications/Enpass.app" ]] || [[ -d "$HOME/Applications/Enpass.app" ]]
}

maclib::productivity::enpass::installed_path() {
  if [[ -d "/Applications/Enpass.app" ]]; then
    printf '%s\\n' "/Applications/Enpass.app"
  elif [[ -d "$HOME/Applications/Enpass.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Enpass.app"
  fi
}

maclib::enpass::install() {
  local url tmp
  url="$(maclib::enpass::suite_installer_url)"
  tmp="$(mktemp -t "enpass_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "enpass::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::productivity::enpass::update() {
  # No vendor update path documented for "Enpass".
  maclib::core::log::error "enpass::update: no update path"
  return 127
}

maclib::productivity::enpass::uninstall() {
  # No clean uninstall for "Enpass" (documented constraint).
  maclib::core::log::error "enpass::uninstall: no clean uninstall"
  return 1
}
