#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiowurlybird140b.sh - Wurlybird 140B (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiowurlybird140b from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiowurlybird140b::suite_installer_url() {
  # TODO: Add actual download URL for Wurlybird 140B
  printf '%s\\n' 'https://example.com/cherryaudiowurlybird140b/installer'
}

maclib::creative::cherryaudiowurlybird140b::latest_version() {
  # TODO: Add version detection for Wurlybird 140B
  return 1
}

maclib::creative::cherryaudiowurlybird140b::is_installed() {
  [[ -d "/Applications/Wurlybird 140B.app" ]] || [[ -d "$HOME/Applications/Wurlybird 140B.app" ]]
}

maclib::creative::cherryaudiowurlybird140b::installed_path() {
  if [[ -d "/Applications/Wurlybird 140B.app" ]]; then
    printf '%s\\n' "/Applications/Wurlybird 140B.app"
  elif [[ -d "$HOME/Applications/Wurlybird 140B.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Wurlybird 140B.app"
  fi
}

maclib::cherryaudiowurlybird140b::install() {
  local url tmp
  url="$(maclib::cherryaudiowurlybird140b::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiowurlybird140b_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiowurlybird140b::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiowurlybird140b::update() {
  # No vendor update path documented for "Wurlybird 140B".
  maclib::core::log::error "cherryaudiowurlybird140b::update: no update path"
  return 127
}

maclib::creative::cherryaudiowurlybird140b::uninstall() {
  # No clean uninstall for "Wurlybird 140B" (documented constraint).
  maclib::core::log::error "cherryaudiowurlybird140b::uninstall: no clean uninstall"
  return 1
}
