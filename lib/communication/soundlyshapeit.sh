#!/usr/bin/env bash
# shellcheck disable=all
# soundlyshapeit.sh - Soundly Shapeit (AU plugin, package installer) helpers
#
# Vendor source: Installomator label `soundlyshapeit`
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Shapeit (an AU plugin) ships a signed .pkg from Google Cloud Storage:
#     https://storage.googleapis.com/soundly-plugins/Shapeit.pkg
#   Package ID: com.soundly.pkg.au.shapeit
#   Apple Developer Team ID: 67Y6N7VTDG.
#   Installer type: pkg.

# Print the Soundly Shapeit package installer URL.
maclib::communication::soundlyshapeit::suite_installer_url() {
  printf '%s\n' 'https://storage.googleapis.com/soundly-plugins/Shapeit.pkg'
}

# Shapeit has no vendor version endpoint (the pkg URL carries no build number).
# Returns non-zero; documented as no update path.
maclib::communication::soundlyshapeit::latest_version() {
  maclib::core::log::warn "soundlyshapeit::latest_version: no vendor version source"
  return 1
}

# Return 0 if the Shapeit AU plugin is installed (checked via package receipt).
maclib::communication::soundlyshapeit::is_installed() {
  pkgutil --pkg-info com.soundly.pkg.au.shapeit >/dev/null 2>&1
}

# Print the installed version of the Shapeit AU plugin (package receipt), or
# non-zero if not installed.
maclib::communication::soundlyshapeit::installed_path() {
  local version
  version="$(pkgutil --pkg-info com.soundly.pkg.au.shapeit 2>/dev/null \
    | sed -nE 's/^version:[[:space:]]+//p')"
  [[ -n "$version" ]] && printf '%s\n' "$version"
}

# Download the Soundly Shapeit package installer and install it (requires root).
maclib::communication::soundlyshapeit::install() {
  local url tmp
  url="$(maclib::communication::soundlyshapeit::suite_installer_url)"
  tmp="$(mktemp -t "soundlyshapeit_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "soundlyshapeit::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Shapeit has no vendor version endpoint; updates are applied by re-installing
# the latest package (see install()). Documented as no separate update path.
maclib::communication::soundlyshapeit::update() {
  maclib::communication::soundlyshapeit::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::soundlyshapeit::uninstall() {
  maclib::core::log::warn "soundlyshapeit::uninstall: no clean uninstall"
  return 1
}
