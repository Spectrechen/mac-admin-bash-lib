#!/usr/bin/env bash
# shellcheck disable=all
# mmhmm-studio.sh - mmhmm Studio (package installer) helpers
#
# Vendor source: Installomator label mmhmm-studio
#   (github.com/Installomator/Installomator, Installomator.sh).
#   mmhmm Studio ships a signed .pkg from https://updates.mmhmm.app/mac/mmhmmStudio.pkg.
#   The current build is parsed from the mmhmm Studio help/release page.
#   Apple Developer Team ID: M3KUT44L48.

# Print the mmhmm Studio installer package URL.
maclib::communication::mmhmm-studio::suite_installer_url() {
  printf '%s\n' 'https://updates.mmhmm.app/mac/mmhmmStudio.pkg'
}

# Print the current mmhmm Studio build version.
# Installomator parses the version from the mmhmm Studio help/release page
# (the value after "The latest version of mmhmm Studio is").
maclib::communication::mmhmm-studio::latest_version() {
  local version
  version="$(curl -fsL 'https://help.mmhmm.app/hc/en-us/articles/4420969712151-mmhmm-Studio-Mac-only-' 2>/dev/null \
    | grep 'The latest version of mmhmm Studio is <strong>*' \
    | sed -E 's/.*<strong>(.*)<\/strong>.*/\1/' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the mmhmm Studio app bundle is installed.
maclib::communication::mmhmm-studio::is_installed() {
  [[ -d "/Applications/mmhmm Studio.app" ]] || [[ -d "$HOME/Applications/mmhmm Studio.app" ]]
}

# Print the path to the mmhmm Studio app bundle if present.
maclib::communication::mmhmm-studio::installed_path() {
  if [[ -d "/Applications/mmhmm Studio.app" ]]; then
    printf '%s\n' "/Applications/mmhmm Studio.app"
  elif [[ -d "$HOME/Applications/mmhmm Studio.app" ]]; then
    printf '%s\n' "$HOME/Applications/mmhmm Studio.app"
  else
    return 1
  fi
}

# Download the mmhmm Studio installer package and install it (requires root).
maclib::communication::mmhmm-studio::install() {
  local url tmp
  url="$(maclib::communication::mmhmm-studio::suite_installer_url)"
  tmp="$(mktemp -t "mmhmm-studio_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "mmhmm-studio::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# mmhmm Studio updates are applied by re-installing the latest package (see
# install()). Documented as no separate update path.
maclib::communication::mmhmm-studio::update() {
  maclib::communication::mmhmm-studio::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::mmhmm-studio::uninstall() {
  maclib::core::log::warn "mmhmm-studio::uninstall: no clean uninstall"
  return 1
}
