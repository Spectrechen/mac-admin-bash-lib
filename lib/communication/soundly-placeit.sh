#!/usr/bin/env bash
# shellcheck disable=all
# soundly-placeit.sh - Soundly Placeit (package installer) helpers
#
# Vendor source: Installomator label `soundly-placeit`
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Placeit ships a signed .pkg from Google Cloud Storage:
#     https://storage.googleapis.com/soundly-plugins/Placeit.pkg
#   Apple Developer Team ID: 67Y6N7VTDG.
#   Installer type: pkg.

# Print the Soundly Placeit package installer URL.
maclib::communication::soundly-placeit::suite_installer_url() {
  printf '%s\n' 'https://storage.googleapis.com/soundly-plugins/Placeit.pkg'
}

# Placeit has no vendor version endpoint (the pkg URL carries no build number).
# Returns non-zero; documented as no update path.
maclib::communication::soundly-placeit::latest_version() {
  maclib::core::log::warn "soundly-placeit::latest_version: no vendor version source"
  return 1
}

# Return 0 if the Placeit app bundle is installed.
maclib::communication::soundly-placeit::is_installed() {
  [[ -d "/Applications/Placeit.app" ]] || [[ -d "$HOME/Applications/Placeit.app" ]]
}

# Print the path to the Placeit app bundle if present.
maclib::communication::soundly-placeit::installed_path() {
  if [[ -d "/Applications/Placeit.app" ]]; then
    printf '%s\n' "/Applications/Placeit.app"
  elif [[ -d "$HOME/Applications/Placeit.app" ]]; then
    printf '%s\n' "$HOME/Applications/Placeit.app"
  else
    return 1
  fi
}

# Download the Soundly Placeit package installer and install it (requires root).
maclib::communication::soundly-placeit::install() {
  local url tmp
  url="$(maclib::communication::soundly-placeit::suite_installer_url)"
  tmp="$(mktemp -t "soundly-placeit_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "soundly-placeit::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Placeit has no vendor version endpoint; updates are applied by re-installing
# the latest package (see install()). Documented as no separate update path.
maclib::communication::soundly-placeit::update() {
  maclib::communication::soundly-placeit::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::soundly-placeit::uninstall() {
  maclib::core::log::warn "soundly-placeit::uninstall: no clean uninstall"
  return 1
}
