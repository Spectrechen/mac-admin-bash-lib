#!/usr/bin/env bash
# shellcheck disable=all
# tortalk_se.sh - TorTalk SE (package installer) helpers
#
# Vendor source: Installomator label `tortalk_se`
#   (github.com/Installomator/Installomator, Installomator.sh).
#   TorTalk ships signed .pkg installers from Azure Blob Storage. The current
#   build is discovered by fetching the student/pupil download page and reading
#   the .pkg link it redirects to:
#     https://tortalk.se/student-elev/
#   resolves to e.g.
#     https://tortalkfiles.blob.core.windows.net/tortalkmac/TorTalk_installer_2.4.3_SV.pkg
#   Apple Developer Team ID: QUT3D5SU72.
#   Installer type: pkg.

# Print the TorTalk SE package installer URL.
# The build is discovered by fetching the download page and reading the .pkg
# link it redirects to.
maclib::communication::tortalk_se::suite_installer_url() {
  local url
  url="$(curl -fsL 'https://tortalk.se/student-elev/' 2>/dev/null \
    | grep -o 'https://.*\.pkg' | head -n1)"
  [[ -n "$url" ]] || return 1
  printf '%s\n' "$url"
}

# Print the current TorTalk SE build version.
# Installomator parses the build from the discovered .pkg file name
# (e.g. TorTalk_installer_2.4.3_SV.pkg -> 2.4.3).
maclib::communication::tortalk_se::latest_version() {
  local url version
  url="$(maclib::communication::tortalk_se::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  version="$(printf '%s' "$url" | grep -oE '_[0-9]+\.[0-9.]+_' | head -n1 | tr -d '_')"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the TorTalk app bundle is installed.
maclib::communication::tortalk_se::is_installed() {
  [[ -d "/Applications/TorTalk.app" ]] || [[ -d "$HOME/Applications/TorTalk.app" ]]
}

# Print the path to the TorTalk app bundle if present.
maclib::communication::tortalk_se::installed_path() {
  if [[ -d "/Applications/TorTalk.app" ]]; then
    printf '%s\n' "/Applications/TorTalk.app"
  elif [[ -d "$HOME/Applications/TorTalk.app" ]]; then
    printf '%s\n' "$HOME/Applications/TorTalk.app"
  else
    return 1
  fi
}

# Download the TorTalk SE package installer and install it (requires root).
maclib::communication::tortalk_se::install() {
  local url tmp
  url="$(maclib::communication::tortalk_se::suite_installer_url)"
  tmp="$(mktemp -t "tortalk_se_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "tortalk_se::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# TorTalk updates are applied by re-installing the latest package (see
# install()). Documented as no separate update path.
maclib::communication::tortalk_se::update() {
  maclib::communication::tortalk_se::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::tortalk_se::uninstall() {
  maclib::core::log::warn "tortalk_se::uninstall: no clean uninstall"
  return 1
}
