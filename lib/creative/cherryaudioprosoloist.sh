#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioprosoloist.sh - Pro Soloist (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioprosoloist from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudioprosoloist::suite_installer_url() {
  # TODO: Add actual download URL for Pro Soloist
  printf '%s\\n' 'https://example.com/cherryaudioprosoloist/installer'
}

maclib::creative::cherryaudioprosoloist::latest_version() {
  # TODO: Add version detection for Pro Soloist
  return 1
}

maclib::creative::cherryaudioprosoloist::is_installed() {
  [[ -d "/Applications/Pro Soloist.app" ]] || [[ -d "$HOME/Applications/Pro Soloist.app" ]]
}

maclib::creative::cherryaudioprosoloist::installed_path() {
  if [[ -d "/Applications/Pro Soloist.app" ]]; then
    printf '%s\\n' "/Applications/Pro Soloist.app"
  elif [[ -d "$HOME/Applications/Pro Soloist.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Pro Soloist.app"
  fi
}

maclib::cherryaudioprosoloist::install() {
  local url tmp
  url="$(maclib::cherryaudioprosoloist::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudioprosoloist_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudioprosoloist::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudioprosoloist::update() {
  # No vendor update path documented for "Pro Soloist".
  maclib::core::log::error "cherryaudioprosoloist::update: no update path"
  return 127
}

maclib::creative::cherryaudioprosoloist::uninstall() {
  # No clean uninstall for "Pro Soloist" (documented constraint).
  maclib::core::log::error "cherryaudioprosoloist::uninstall: no clean uninstall"
  return 1
}
