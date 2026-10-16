#!/usr/bin/env bash
# shellcheck disable=all
# tortalk_en.sh - TorTalk EN (package installer) helpers
#
# Vendor source: Installomator label `tortalk_en`
#   (github.com/Installomator/Installomator, Installomator.sh).
#   TorTalk ships signed .pkg installers from Azure Blob Storage. The current
#   build is discovered by fetching the student/pupil download page and reading
#   the .pkg link it redirects to:
#     https://tortalk.se/student-or-pupil/?lang=en
#   resolves to e.g.
#     https://tortalkfiles.blob.core.windows.net/tortalkmac/TorTalk_installer_2.4.2_EN.pkg
#   Apple Developer Team ID: QUT3D5SU72.
#   Installer type: pkg.

# Print the TorTalk EN package installer URL.
# The build is discovered by fetching the download page and reading the .pkg
# link it redirects to.
maclib::communication::tortalk_en::suite_installer_url() {
  local url
  url="$(curl -fsL 'https://tortalk.se/student-or-pupil/?lang=en' 2>/dev/null \
    | grep -o 'https://.*\.pkg' | head -n1)"
  [[ -n "$url" ]] || return 1
  printf '%s\n' "$url"
}

# Print the current TorTalk EN build version.
# Installomator parses the build from the discovered .pkg file name
# (e.g. TorTalk_installer_2.4.2_EN.pkg -> 2.4.2).
maclib::communication::tortalk_en::latest_version() {
  local url version
  url="$(maclib::communication::tortalk_en::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  version="$(printf '%s' "$url" | grep -oE '_[0-9]+\.[0-9.]+_' | head -n1 | tr -d '_')"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the TorTalk app bundle is installed.
maclib::communication::tortalk_en::is_installed() {
  [[ -d "/Applications/TorTalk.app" ]] || [[ -d "$HOME/Applications/TorTalk.app" ]]
}

# Print the path to the TorTalk app bundle if present.
maclib::communication::tortalk_en::installed_path() {
  if [[ -d "/Applications/TorTalk.app" ]]; then
    printf '%s\n' "/Applications/TorTalk.app"
  elif [[ -d "$HOME/Applications/TorTalk.app" ]]; then
    printf '%s\n' "$HOME/Applications/TorTalk.app"
  else
    return 1
  fi
}

# Download the TorTalk EN package installer and install it (requires root).
maclib::communication::tortalk_en::install() {
  local url tmp
  url="$(maclib::communication::tortalk_en::suite_installer_url)"
  tmp="$(mktemp -t "tortalk_en_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "tortalk_en::install: failed to download installer"
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
maclib::communication::tortalk_en::update() {
  maclib::communication::tortalk_en::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::tortalk_en::uninstall() {
  maclib::core::log::warn "tortalk_en::uninstall: no clean uninstall"
  return 1
}
