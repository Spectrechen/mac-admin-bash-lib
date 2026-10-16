#!/usr/bin/env bash
# shellcheck disable=all
# egnytewebedit.sh - EgnyteWebEdit (Installomator label) helpers
#
# Vendor source: Installomator label egnytewebedit from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::cloud_storage::egnytewebedit::suite_installer_url() {
  # TODO: Add actual download URL for EgnyteWebEdit
  printf '%s\\n' 'https://example.com/egnytewebedit/installer'
}

maclib::cloud_storage::egnytewebedit::latest_version() {
  # TODO: Add version detection for EgnyteWebEdit
  return 1
}

maclib::cloud_storage::egnytewebedit::is_installed() {
  [[ -d "/Applications/Egnytewebedit.app" ]] || [[ -d "$HOME/Applications/Egnytewebedit.app" ]]
}

maclib::cloud_storage::egnytewebedit::installed_path() {
  if [[ -d "/Applications/Egnytewebedit.app" ]]; then
    printf '%s\\n' "/Applications/Egnytewebedit.app"
  elif [[ -d "$HOME/Applications/Egnytewebedit.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Egnytewebedit.app"
  fi
}

maclib::egnytewebedit::install() {
  local url tmp
  url="$(maclib::egnytewebedit::suite_installer_url)"
  tmp="$(mktemp -t "egnytewebedit_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "egnytewebedit::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::cloud_storage::egnytewebedit::update() {
  # No vendor update path documented for "EgnyteWebEdit".
  maclib::core::log::error "egnytewebedit::update: no update path"
  return 127
}

maclib::cloud_storage::egnytewebedit::uninstall() {
  # No clean uninstall for "EgnyteWebEdit" (documented constraint).
  maclib::core::log::error "egnytewebedit::uninstall: no clean uninstall"
  return 1
}
