#!/usr/bin/env bash
# shellcheck disable=all
# microsoftskypeforbusinessremovaltool.sh - Skype for Business Removal Tool (package) helpers
#
# Vendor source: Installomator label microsoftskypeforbusinessremovaltool
#   (github.com/Installomator/Installomator, Installomator.sh).
#   This is a removal tool (package ID com.microsoft.remove.SkypeForBusiness)
#   served from office-reset.com. The installer URL is assembled from the
#   current file listed on https://office-reset.com/macadmins/.
#   Apple Developer Team ID: QGS93ZLCU7.

# Print the Skype for Business Removal Tool installer package URL.
# The URL is assembled from the file listed on the office-reset.com macadmins page.
maclib::microsoftskypeforbusinessremovaltool::suite_installer_url() {
  local base file url
  base='https://office-reset.com'
  file="$(curl -fsL "${base}/macadmins/" 2>/dev/null \
    | grep -ioE 'href="[^"]*SkypeForBusiness_Removal[^"]*\.pkg"' \
    | head -n1 | sed -E 's/href="//; s/"$//')"
  [[ -n "$file" ]] || return 1
  url="${base}${file}"
  printf '%s\n' "$url"
}

# Print the current Skype for Business Removal Tool build version.
# The removal tool has no meaningful version string; report empty.
maclib::microsoftskypeforbusinessremovaltool::latest_version() {
  printf '%s\n' ''
}

# Return 0 if the Skype for Business app bundle is installed (i.e. the removal
# tool still has work to do).
maclib::microsoftskypeforbusinessremovaltool::is_installed() {
  [[ -d "/Applications/Skype for Business.app" ]] || [[ -d "$HOME/Applications/Skype for Business.app" ]]
}

# Print the path to the Skype for Business app bundle if present.
maclib::microsoftskypeforbusinessremovaltool::installed_path() {
  if [[ -d "/Applications/Skype for Business.app" ]]; then
    printf '%s\n' "/Applications/Skype for Business.app"
  elif [[ -d "$HOME/Applications/Skype for Business.app" ]]; then
    printf '%s\n' "$HOME/Applications/Skype for Business.app"
  else
    return 1
  fi
}

# Download the Skype for Business Removal Tool package and install it (requires
# root).
maclib::microsoftskypeforbusinessremovaltool::install() {
  local url tmp
  url="$(maclib::microsoftskypeforbusinessremovaltool::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  tmp="$(mktemp -t "skypeforbusinessremoval_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "microsoftskypeforbusinessremovaltool::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# The removal tool is a one-shot uninstaller; running install() applies it.
maclib::microsoftskypeforbusinessremovaltool::update() {
  maclib::microsoftskypeforbusinessremovaltool::install "$@"
}

# The removal tool performs the uninstall itself (see install()). Documented as
# no separate update path.
maclib::microsoftskypeforbusinessremovaltool::uninstall() {
  maclib::microsoftskypeforbusinessremovaltool::install "$@"
}
