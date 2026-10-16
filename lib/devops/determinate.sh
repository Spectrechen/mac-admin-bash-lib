#!/usr/bin/env bash
# shellcheck disable=all
# determinate.sh - Determinate (Installomator label) helpers
#
# Vendor source: Installomator label determinate from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::devops::determinate::suite_installer_url() {
  # TODO: Add actual download URL for Determinate
  printf '%s\\n' 'https://example.com/determinate/installer'
}

maclib::devops::determinate::latest_version() {
  # TODO: Add version detection for Determinate
  return 1
}

maclib::devops::determinate::is_installed() {
  [[ -d "/Applications/Determinate.app" ]] || [[ -d "$HOME/Applications/Determinate.app" ]]
}

maclib::devops::determinate::installed_path() {
  if [[ -d "/Applications/Determinate.app" ]]; then
    printf '%s\\n' "/Applications/Determinate.app"
  elif [[ -d "$HOME/Applications/Determinate.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Determinate.app"
  fi
}

maclib::determinate::install() {
  local url tmp
  url="$(maclib::determinate::suite_installer_url)"
  tmp="$(mktemp -t "determinate_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "determinate::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::devops::determinate::update() {
  # No vendor update path documented for "Determinate".
  maclib::core::log::error "determinate::update: no update path"
  return 127
}

maclib::devops::determinate::uninstall() {
  # No clean uninstall for "Determinate" (documented constraint).
  maclib::core::log::error "determinate::uninstall: no clean uninstall"
  return 1
}
