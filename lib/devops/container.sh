#!/usr/bin/env bash
# shellcheck disable=all
# container.sh - container (Installomator label) helpers
#
# Vendor source: Installomator label container from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::devops::container::suite_installer_url() {
  # TODO: Add actual download URL for container
  printf '%s\\n' 'https://example.com/container/installer'
}

maclib::devops::container::latest_version() {
  # TODO: Add version detection for container
  return 1
}

maclib::devops::container::is_installed() {
  [[ -d "/Applications/Container.app" ]] || [[ -d "$HOME/Applications/Container.app" ]]
}

maclib::devops::container::installed_path() {
  if [[ -d "/Applications/Container.app" ]]; then
    printf '%s\\n' "/Applications/Container.app"
  elif [[ -d "$HOME/Applications/Container.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Container.app"
  fi
}

maclib::container::install() {
  local url tmp
  url="$(maclib::container::suite_installer_url)"
  tmp="$(mktemp -t "container_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "container::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::devops::container::update() {
  # No vendor update path documented for "container".
  maclib::core::log::error "container::update: no update path"
  return 127
}

maclib::devops::container::uninstall() {
  # No clean uninstall for "container" (documented constraint).
  maclib::core::log::error "container::uninstall: no clean uninstall"
  return 1
}
