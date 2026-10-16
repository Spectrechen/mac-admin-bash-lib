#!/usr/bin/env bash
# shellcheck disable=all
# mmhmm-desktop.sh - mmhmm desktop (package installer) helpers
#
# Vendor source: Installomator labels mmhmm|mmhmm-desktop
#   (github.com/Installomator/Installomator, Installomator.sh).
#   mmhmm desktop ships a signed .pkg from https://updates.mmhmm.app/mac/hybrid/mmhmm.pkg.
#   Apple Developer Team ID: M3KUT44L48.

# Print the mmhmm desktop installer package URL.
maclib::communication::mmhmm-desktop::suite_installer_url() {
  printf '%s\n' 'https://updates.mmhmm.app/mac/hybrid/mmhmm.pkg'
}

# Print the current mmhmm desktop build version.
# mmhmm has no published version string (Installomator appNewVersion=""); report
# empty rather than guessing.
maclib::communication::mmhmm-desktop::latest_version() {
  printf '%s\n' ''
}

# Return 0 if the mmhmm app bundle is installed.
maclib::communication::mmhmm-desktop::is_installed() {
  [[ -d "/Applications/mmhmm.app" ]] || [[ -d "$HOME/Applications/mmhmm.app" ]]
}

# Print the path to the mmhmm app bundle if present.
maclib::communication::mmhmm-desktop::installed_path() {
  if [[ -d "/Applications/mmhmm.app" ]]; then
    printf '%s\n' "/Applications/mmhmm.app"
  elif [[ -d "$HOME/Applications/mmhmm.app" ]]; then
    printf '%s\n' "$HOME/Applications/mmhmm.app"
  else
    return 1
  fi
}

# Download the mmhmm desktop installer package and install it (requires root).
maclib::communication::mmhmm-desktop::install() {
  local url tmp
  url="$(maclib::communication::mmhmm-desktop::suite_installer_url)"
  tmp="$(mktemp -t "mmhmm-desktop_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "mmhmm-desktop::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# mmhmm desktop updates are applied by re-installing the latest package (see
# install()). Documented as no separate update path.
maclib::communication::mmhmm-desktop::update() {
  maclib::communication::mmhmm-desktop::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::mmhmm-desktop::uninstall() {
  maclib::core::log::warn "mmhmm-desktop::uninstall: no clean uninstall"
  return 1
}
