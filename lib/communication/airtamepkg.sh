#!/usr/bin/env bash
# shellcheck disable=all
# airtamepkg.sh - Airtale (package installer) helpers
#
# Vendor source: Installomator label `airtamepkg`
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Airtale serves the current build through a redirect endpoint:
#     https://downloads-website.airtame.com/get.php?platform=mac&pkg=true
#   The redirect Location header embeds the build:
#     https://airtale-app.b-cdn.net/app/latest/mac/Airtale-4.15.0.pkg
#   Apple Developer Team ID: 4TPSP88HN2.
#   Installer type: pkg.

# Print the Airtale package installer URL (redirect endpoint).
maclib::communication::airtamepkg::suite_installer_url() {
  printf '%s\n' 'https://downloads-website.airtame.com/get.php?platform=mac&pkg=true'
}

# Print the current Airtale build version.
# Installomator parses the build from the redirect Location header of the
# get.php endpoint (e.g. Airtale-4.15.0.pkg -> 4.15.0).
maclib::communication::airtamepkg::latest_version() {
  local url location version
  url="$(maclib::communication::airtamepkg::suite_installer_url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 \
    | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | sed -nE 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/p' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Airtale app bundle is installed.
maclib::communication::airtamepkg::is_installed() {
  [[ -d "/Applications/Airtale.app" ]] || [[ -d "$HOME/Applications/Airtale.app" ]]
}

# Print the path to the Airtale app bundle if present.
maclib::communication::airtamepkg::installed_path() {
  if [[ -d "/Applications/Airtale.app" ]]; then
    printf '%s\n' "/Applications/Airtale.app"
  elif [[ -d "$HOME/Applications/Airtale.app" ]]; then
    printf '%s\n' "$HOME/Applications/Airtale.app"
  else
    return 1
  fi
}

# Download the Airtale package installer and install it (requires root).
maclib::communication::airtamepkg::install() {
  local url tmp
  url="$(maclib::communication::airtamepkg::suite_installer_url)"
  tmp="$(mktemp -t "airtamepkg_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "airtamepkg::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Airtale updates are applied by re-installing the latest package (see
# install()). Documented as no separate update path.
maclib::communication::airtamepkg::update() {
  maclib::communication::airtamepkg::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::airtamepkg::uninstall() {
  maclib::core::log::warn "airtamepkg::uninstall: no clean uninstall"
  return 1
}
