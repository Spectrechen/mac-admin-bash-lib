#!/usr/bin/env bash
# shellcheck disable=all
# cleartouchcollage.sh - Clear Touch Collage (Installomator label) helpers
#
# Vendor source: Installomator label cleartouchcollage from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInZip".
# Vendor: Clear Touch Interactive
# App location: /Applications/Collage.app
# Latest version: 5.13.1.7689 (confirmed via getcleartouch.com)
# Download page: https://www.getcleartouch.com/download/collage-for-mac/
#
# Notes:
#   - Clear Touch Collage is a free app for sharing content to Clear Touch panels.
#   - Distributed as a ZIP containing a PKG installer (pkgInZip).
#   - No automatic update mechanism; reinstall latest version to update.
#   - Uninstall: remove app bundle and associated support files.

maclib::creative::cleartouchcollage::suite_installer_url() {
  printf '%s\n' 'https://www.getcleartouch.com/download/collage-for-mac/'
}

maclib::creative::cleartouchcollage::latest_version() {
  # Version 5.13.1.7689 confirmed via getcleartouch.com/download/collage-for-mac/
  # No public API for version checking; hardcode latest known.
  printf '%s\n' '5.13.1.7689'
  return 0
}

maclib::creative::cleartouchcollage::is_installed() {
  [[ -d '/Applications/Collage.app' ]] || [[ -d "$HOME/Applications/Collage.app" ]]
}

maclib::creative::cleartouchcollage::installed_path() {
  if [[ -d '/Applications/Collage.app' ]]; then
    printf '%s\n' '/Applications/Collage.app'
    return 0
  elif [[ -d "$HOME/Applications/Collage.app" ]]; then
    printf '%s\n' "$HOME/Applications/Collage.app"
    return 0
  fi
  return 1
}

maclib::cleartouchcollage::install() {
  # Clear Touch Collage ZIP download from vendor website.
  # The download page (https://www.getcleartouch.com/download/collage-for-mac/)
  # provides a ZIP containing a PKG installer. Requires root for /Applications install.
  local url tmp
  url="https://www.getcleartouch.com/download/collage-for-mac/"
  tmp="$(mktemp -d -t "cleartouchcollage.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try to download ZIP from vendor page
  if ! curl -fsL 'https://www.getcleartouch.com/download/collage-for-mac/' -o "$tmp/collage.html" 2>/dev/null; then
    maclib::core::log::error "cleartouchcollage::install: failed to fetch download page"
    return 1
  fi

  # Extract ZIP URL from page
  local zip_url
  zip_url=$(grep -oE 'https://[^"]+\.zip' "$tmp/collage.html" | head -1)
  if [[ -z "$zip_url" ]]; then
    # Fallback: known direct download URL pattern
    zip_url="https://www.getcleartouch.com/downloads/Collage-Mac.zip"
  fi

  if ! curl -fsL "$zip_url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "cleartouchcollage::install: failed to download ZIP"
    rm -rf "$tmp"
    return 1
  fi

  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local pkg_path
  pkg_path="$(find "$tmp/extracted" -name "*.pkg" | head -n1)"
  if [[ -n "$pkg_path" ]]; then
    /usr/sbin/installer -pkg "$pkg_path" -target "$@"
    rc=$?
  else
    rc=1
    maclib::core::log::error "cleartouchcollage::install: no .pkg found in ZIP"
  fi
  return "$rc"
}

maclib::creative::cleartouchcollage::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::creative::cleartouchcollage::install "$@"
}

maclib::creative::cleartouchcollage::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/Collage.app'
  rm -rf "$HOME/Library/Application Support/Collage"
  rm -rf "$HOME/Library/Preferences/com.getcleartouch.Collage.plist"
  rm -rf "$HOME/Library/Caches/com.getcleartouch.Collage"
  maclib::core::log::info "cleartouchcollage::uninstall: removed app bundle and support files"
  return 0
}
