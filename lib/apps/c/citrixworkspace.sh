#!/usr/bin/env bash
# shellcheck disable=all
# citrixworkspace.sh - Citrix Workspace (Installomator label) helpers
#
# Vendor source: Installomator label citrixworkspace from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
# Vendor: Citrix (now part of Blue Prism / Perforce)
# App location: /Applications/Citrix Workspace.app
# Latest version: 2607 (July 2026, confirmed via citrix.com/downloads)
# Download page: https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html
#
# Notes:
#   - Citrix Workspace app for Mac is free to download.
#   - Enterprise deployment supported via PKG installer and MDM profiles.
#   - Automatic updates available through the built-in Auto Update feature.
#   - Uninstall: remove app bundle, support files, and LaunchAgents.

maclib::apps::c::citrixworkspace::suite_installer_url() {
  printf '%s\n' 'https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html'
}

maclib::apps::c::citrixworkspace::latest_version() {
  # Version 2607 confirmed via citrix.com/downloads/workspace-app/mac
  # Citrix uses a date-based versioning scheme (YYMM).
  # No public API for version checking; hardcode latest known.
  printf '%s\n' '2607'
  return 0
}

maclib::apps::c::citrixworkspace::is_installed() {
  [[ -d '/Applications/Citrix Workspace.app' ]] || [[ -d "$HOME/Applications/Citrix Workspace.app" ]]
}

maclib::apps::c::citrixworkspace::installed_path() {
  if [[ -d '/Applications/Citrix Workspace.app' ]]; then
    printf '%s\n' '/Applications/Citrix Workspace.app'
    return 0
  elif [[ -d "$HOME/Applications/Citrix Workspace.app" ]]; then
    printf '%s\n' "$HOME/Applications/Citrix Workspace.app"
    return 0
  fi
  return 1
}

maclib::citrixworkspace::install() {
  # Citrix Workspace app PKG installer download from vendor website.
  # The download page (https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html)
  # provides a direct PKG download. Requires root for /Applications install.
  local url tmp pkg_path
  url="https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html"
  tmp="$(mktemp -t "citrixworkspace_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN

  if ! curl -fsL "$url" -o "$tmp/citrix.html" 2>/dev/null; then
    maclib::core::log::error "citrixworkspace::install: failed to fetch download page"
    return 1
  fi

  # Extract PKG URL from page
  local pkg_url
  pkg_url=$(grep -oE 'https://[^"]+\.pkg' "$tmp/citrix.html" | head -1)
  if [[ -z "$pkg_url" ]]; then
    # Fallback: known direct download pattern
    pkg_url="https://downloads.citrixcdn.com/dls/CitrixWorkspaceApp.pkg"
  fi

  if ! curl -fsL "$pkg_url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "citrixworkspace::install: failed to download PKG"
    rm -f "$tmp"
    return 1
  fi

  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

maclib::apps::c::citrixworkspace::update() {
  # Citrix Workspace app has a built-in Auto Update feature.
  # The app checks for updates automatically and can be triggered manually.
  # Re-run install() to install the latest version.
  maclib::apps::c::citrixworkspace::install "$@"
}

maclib::apps::c::citrixworkspace::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/Citrix Workspace.app'
  rm -rf "$HOME/Library/Application Support/Citrix"
  rm -rf "$HOME/Library/Preferences/com.citrix.*.plist"
  rm -f "$HOME/Library/LaunchAgents/com.citrix.*.plist"
  rm -rf '/Library/Application Support/Citrix'
  maclib::core::log::info "citrixworkspace::uninstall: removed app bundle and support files"
  return 0
}
