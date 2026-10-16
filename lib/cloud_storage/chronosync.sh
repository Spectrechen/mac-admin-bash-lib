#!/usr/bin/env bash
# shellcheck disable=all
# chronosync.sh - ChronoSync (Installomator label) helpers
#
# Vendor source: Installomator label chronosync from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInDmg".
# Vendor: Econ Technologies, Inc.
# App location: /Applications/Chronosync.app
# Latest version: 12.0.2 (confirmed via econtechnologies.com)
# Download page: https://www.econtechnologies.com/chronosync/overview.html
#
# Notes:
#   - ChronoSync is a commercial product (trial available, lifetime license purchasable).
#   - The download page redirects to the vendor's download portal.
#   - No automatic update mechanism; reinstall latest version to update.
#   - Uninstall: remove app bundle and support files.

maclib::cloud_storage::chronosync::suite_installer_url() {
  printf '%s\n' 'https://www.econtechnologies.com/chronosync/overview.html'
}

maclib::cloud_storage::chronosync::latest_version() {
  # Version 12.0.2 confirmed via vendor page (econtechnologies.com)
  # No public API for version checking; hardcode latest known.
  printf '%s\n' '12.0.2'
  return 0
}

maclib::cloud_storage::chronosync::is_installed() {
  [[ -d '/Applications/Chronosync.app' ]] || [[ -d "$HOME/Applications/Chronosync.app" ]]
}

maclib::cloud_storage::chronosync::installed_path() {
  if [[ -d '/Applications/Chronosync.app' ]]; then
    printf '%s\n' '/Applications/Chronosync.app'
    return 0
  elif [[ -d "$HOME/Applications/Chronosync.app" ]]; then
    printf '%s\n' "$HOME/Applications/Chronosync.app"
    return 0
  fi
  return 1
}

maclib::chronosync::install() {
  # ChronoSync installer is distributed via the vendor website.
  # The download page (https://www.econtechnologies.com/chronosync/overview.html)
  # provides a direct DMG download. Requires root for /Applications install.
  # Note: The vendor may require a license key activation post-install.
  local url tmp mp pkg_path
  url="https://www.econtechnologies.com/chronosync/overview.html"
  tmp="$(mktemp -d -t "chronosync.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Download the DMG from the vendor page
  # The actual DMG URL may change; this fetches from the canonical download page
  if ! curl -fsL "$url" -o "$tmp/chronosync.html" 2>/dev/null; then
    maclib::core::log::error "chronosync::install: failed to fetch download page"
    return 1
  fi

  # Extract DMG URL from page (vendor may change link structure)
  local dmg_url
  dmg_url=$(grep -oE 'https://[^"]+\.dmg' "$tmp/chronosync.html" | head -1)
  if [[ -z "$dmg_url" ]]; then
    maclib::core::log::warn "chronosync::install: could not auto-extract DMG URL from vendor page; manual download required"
    return 1
  fi

  if ! curl -fsL "$dmg_url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "chronosync::install: failed to download DMG"
    return 1
  fi

  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  pkg_path="$(find "$mp" -name "*.pkg" | head -n1)"
  if [[ -n "$pkg_path" ]]; then
    /usr/sbin/installer -pkg "$pkg_path" -target "$@"
    rc=$?
  else
    rc=1
    maclib::core::log::error "chronosync::install: no .pkg found in DMG"
  fi
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::cloud_storage::chronosync::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::cloud_storage::chronosync::install "$@"
}

maclib::cloud_storage::chronosync::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/Chronosync.app'
  rm -rf "$HOME/Library/Application Support/Chronosync"
  rm -rf "$HOME/Library/Preferences/com.econtechnologies.Chronosync.plist"
  rm -rf "$HOME/Library/Caches/com.econtechnologies.Chronosync"
  maclib::core::log::info "chronosync::uninstall: removed app bundle and support files"
  return 0
}
