#!/usr/bin/env bash
# shellcheck disable=all
# microsoftteamsreset.sh - Microsoft Teams Reset (package) helpers
#
# Vendor source: Installomator label microsoftteamsreset
#   (github.com/Installomator/Installomator, Installomator.sh).
#   This is a reset/removal tool (package ID com.microsoft.reset.Teams) served
#   from office-reset.com. The installer URL is assembled from the current file
#   listed on https://office-reset.com/macadmins/.
#   Apple Developer Team ID: QGS93ZLCU7.

# Print the Microsoft Teams Reset installer package URL.
# The URL is assembled from the file listed on the office-reset.com macadmins page.
maclib::communication::microsoftteamsreset::suite_installer_url() {
  local base file url
  base='https://office-reset.com'
  file="$(curl -fsL "${base}/macadmins/" 2>/dev/null \
    | grep -ioE 'href="[^"]*Teams_Reset[^"]*\.pkg"' \
    | head -n1 | sed -E 's/href="//; s/"$//')"
  [[ -n "$file" ]] || return 1
  url="${base}${file}"
  printf '%s\n' "$url"
}

# Print the current Microsoft Teams Reset build version.
# The reset tool has no meaningful version string; report empty.
maclib::communication::microsoftteamsreset::latest_version() {
  printf '%s\n' ''
}

# Return 0 if the Microsoft Teams app bundle is installed (i.e. the reset tool
# still has work to do).
maclib::communication::microsoftteamsreset::is_installed() {
  [[ -d "/Applications/Microsoft Teams.app" ]] || [[ -d "$HOME/Applications/Microsoft Teams.app" ]]
}

# Print the path to the Microsoft Teams app bundle if present.
maclib::communication::microsoftteamsreset::installed_path() {
  if [[ -d "/Applications/Microsoft Teams.app" ]]; then
    printf '%s\n' "/Applications/Microsoft Teams.app"
  elif [[ -d "$HOME/Applications/Microsoft Teams.app" ]]; then
    printf '%s\n' "$HOME/Applications/Microsoft Teams.app"
  else
    return 1
  fi
}

# Download the Microsoft Teams Reset package and install it (requires root).
maclib::communication::microsoftteamsreset::install() {
  local url tmp
  url="$(maclib::communication::microsoftteamsreset::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  tmp="$(mktemp -t "microsoftteamsreset_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "microsoftteamsreset::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# The reset tool is a one-shot uninstaller; running install() applies it.
maclib::communication::microsoftteamsreset::update() {
  maclib::communication::microsoftteamsreset::install "$@"
}

# The reset tool performs the uninstall itself (see install()). Documented as no
# separate update path.
maclib::communication::microsoftteamsreset::uninstall() {
  maclib::communication::microsoftteamsreset::install "$@"
}
