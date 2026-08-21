#!/usr/bin/env bash
# office.sh - Microsoft Office 365 for Mac helpers
#
# Vendor research (see NOTES.md at repo root / task notes):
#   Office for Mac installs via Apple Installer (.pkg) and is distributed from
#   the Microsoft Office Content Delivery Network (CDN). See:
#     https://learn.microsoft.com/en-us/microsoft-365-apps/mac/deployment-options-for-office-for-mac
#     https://learn.microsoft.com/en-us/microsoft-365-apps/mac/most-current-packages-for-office-for-mac
#   - Suite installer (all apps incl. Teams):
#       https://go.microsoft.com/fwlink/?linkid=525133
#     resolves (fwlink -> CDN) to a package named like:
#       Microsoft_365_and_Office_<version>_Installer.pkg
#     e.g. Microsoft_365_and_Office_16.112.26081720_Installer.pkg
#     Team ID: UBF8T346G9 ; packageID: com.microsoft.pkg.licensing
#   - Updates are delivered through Microsoft AutoUpdate (MAU) via the
#     command-line tool "msupdate" (msupdate --install), or by re-deploying a
#     newer app bundle. See:
#       https://learn.microsoft.com/en-us/microsoft-365-apps/mac/deploy-updates-for-office-for-mac
#   - Side-by-side installs are NOT allowed (only one Office version per Mac).

# Print the Microsoft fwlink that resolves (redirect) to the current Office for
# Mac suite installer package on the Office CDN.
maclib::office::suite_installer_url() {
  printf '%s\n' 'https://go.microsoft.com/fwlink/?linkid=525133'
}

# Print the version string of the current Office for Mac suite installer as
# published on the Office CDN (e.g. 16.112.26081720).
# Resolves the fwlink with a HEAD request and extracts the version embedded in
# the resulting package file name (<version> between the last two underscores).
maclib::office::latest_version() {
  local url location version
  url="$(maclib::office::suite_installer_url)"
  # -s silent, -L follow redirects, -I HEAD request.
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  # Package file name ends in "_<version>_Installer.pkg" (or similar).
  if [[ "$location" =~ ([0-9]+\.[0-9]+(\.[0-9]+)*) ]]; then
    version="${BASH_REMATCH[1]}"
  fi
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if any core Office for Mac application bundle is installed.
maclib::office::is_installed() {
  local app
  for app in Word Excel Outlook PowerPoint OneNote; do
    [[ -d "/Applications/$app.app" ]] && return 0
    [[ -d "$HOME/Applications/$app.app" ]] && return 0
  done
  return 1
}

# Print the path to an installed Office app bundle if present (empty otherwise).
maclib::office::installed_path() {
  local app
  for app in Word Excel PowerPoint OneNote; do
    [[ -d "/Applications/$app.app" ]] && {
      printf '%s\n' "/Applications/$app.app"
      return 0
    }
    [[ -d "$HOME/Applications/$app.app" ]] && {
      printf '%s\n' "$HOME/Applications/$app.app"
      return 0
    }
  done
  return 1
}

# Download the current Office for Mac suite installer to a temporary file and
# install it (requires root). Pass-through options are forwarded to installer.
#
# Requires root (installer writes to /Applications and system locations).
maclib::office::install() {
  local url tmp
  url="$(maclib::office::suite_installer_url)"
  tmp="$(mktemp -t "office365_install.XXXXXX.pkg")" || return 1
  # Ensure cleanup on exit.
  trap 'rm -f "$tmp"' RETURN
  # -L follow redirects (fwlink -> CDN), -f fail on HTTP error, -s silent.
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "office::install: failed to download suite installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Update Office for Mac by invoking Microsoft AutoUpdate's command-line tool.
# Uses the "msupdate" tool bundled with Microsoft AutoUpdate when present;
# otherwise falls back to running `msupdate` on PATH.
maclib::office::update() {
  local tool
  tool='/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate'
  if [[ -x "$tool" ]]; then
    "$tool" --install "$@"
    return $?
  fi
  if command -v msupdate >/dev/null 2>&1; then
    msupdate --install "$@"
    return $?
  fi
  maclib::log::error "office::update: Microsoft AutoUpdate (msupdate) not found"
  return 127
}
