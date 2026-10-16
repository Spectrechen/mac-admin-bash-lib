#!/usr/bin/env bash
# shellcheck disable=all
# creativeforcehue.sh - Hue (Installomator label) helpers
#
# Vendor source: Installomator label creativeforcehue from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::creativeforcehue::suite_installer_url() {
  # TODO: Add actual download URL for Hue
  printf '%s\\n' 'https://example.com/creativeforcehue/installer'
}

maclib::creative::creativeforcehue::latest_version() {
  # TODO: Add version detection for Hue
  return 1
}

maclib::creative::creativeforcehue::is_installed() {
  [[ -d "/Applications/Hue.app" ]] || [[ -d "$HOME/Applications/Hue.app" ]]
}

maclib::creative::creativeforcehue::installed_path() {
  if [[ -d "/Applications/Hue.app" ]]; then
    printf '%s\\n' "/Applications/Hue.app"
  elif [[ -d "$HOME/Applications/Hue.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Hue.app"
  fi
}

maclib::creativeforcehue::install() {
  local url tmp
  url="$(maclib::creativeforcehue::suite_installer_url)"
  tmp="$(mktemp -t "creativeforcehue_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "creativeforcehue::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::creativeforcehue::update() {
  # No vendor update path documented for "Hue".
  maclib::core::log::error "creativeforcehue::update: no update path"
  return 127
}

maclib::creative::creativeforcehue::uninstall() {
  # No clean uninstall for "Hue" (documented constraint).
  maclib::core::log::error "creativeforcehue::uninstall: no clean uninstall"
  return 1
}
