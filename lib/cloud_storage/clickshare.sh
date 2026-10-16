#!/usr/bin/env bash
# shellcheck disable=all
# clickshare.sh - ClickShare Desktop App (Installomator label) helpers
#
# Vendor source: Installomator label clickshare from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
# Vendor: Barco
# App location: /Applications/ClickShare.app
# Latest version: N/A (no versioned releases documented publicly)
# Download page: https://www.barco.com/en/support/software/R3306192
#
# Notes:
#   - ClickShare Desktop App is free to download and use.
#   - Distributed as a ZIP containing the app bundle.
#   - No automatic update mechanism; reinstall latest version to update.
#   - Uninstall: remove app bundle and associated support files.

maclib::cloud_storage::clickshare::suite_installer_url() {
  printf '%s\n' 'https://www.barco.com/en/support/software/R3306192'
}

maclib::cloud_storage::clickshare::latest_version() {
  # No versioned releases documented for ClickShare Desktop App.
  # The app is free and updated silently via the vendor website.
  printf '%s\n' 'latest'
  return 0
}

maclib::cloud_storage::clickshare::is_installed() {
  [[ -d '/Applications/ClickShare.app' ]] || [[ -d "$HOME/Applications/ClickShare.app" ]]
}

maclib::cloud_storage::clickshare::installed_path() {
  if [[ -d '/Applications/ClickShare.app' ]]; then
    printf '%s\n' '/Applications/ClickShare.app'
    return 0
  elif [[ -d "$HOME/Applications/ClickShare.app" ]]; then
    printf '%s\n' "$HOME/Applications/ClickShare.app"
    return 0
  fi
  return 1
}

maclib::clickshare::install() {
  # ClickShare Desktop App ZIP download from vendor website.
  # The download page (https://www.barco.com/en/support/software/R3306192)
  # provides a ZIP download. Requires root for /Applications install.
  local url tmp
  url="https://www.barco.com/en/support/software/R3306192"
  tmp="$(mktemp -d -t "clickshare.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try to download ZIP from vendor page
  if ! curl -fsL "$url" -o "$tmp/clickshare.html" 2>/dev/null; then
    maclib::core::log::error "clickshare::install: failed to fetch download page"
    return 1
  fi

  # Extract ZIP URL from page
  local zip_url
  zip_url=$(grep -oE 'https://[^"]+\.zip' "$tmp/clickshare.html" | head -1)
  if [[ -z "$zip_url" ]]; then
    # Fallback: known direct download URL pattern
    zip_url="https://download.barco.com/clickshare/ClickShareDesktopApp.zip"
  fi

  if ! curl -fsL "$zip_url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "clickshare::install: failed to download ZIP"
    rm -rf "$tmp"
    return 1
  fi

  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}

maclib::cloud_storage::clickshare::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::cloud_storage::clickshare::install "$@"
}

maclib::cloud_storage::clickshare::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/ClickShare.app'
  rm -rf "$HOME/Library/Application Support/ClickShare"
  rm -rf "$HOME/Library/Preferences/com.barco.clickshare.plist"
  rm -rf "$HOME/Library/Caches/com.barco.clickshare"
  maclib::core::log::info "clickshare::uninstall: removed app bundle and support files"
  return 0
}
