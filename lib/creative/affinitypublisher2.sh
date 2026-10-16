#!/usr/bin/env bash
# affinitypublisher2.sh - Affinity Publisher 2 helpers
#
# Vendor research (see docs/affinitypublisher2-vendor-notes.md):
#   Affinity Publisher 2 is distributed as a signed .dmg from the Serif store.
#   The DMG contains Affinity Publisher 2.app. Installation is a simple
#   drag-to-Applications. Updates are applied by re-downloading from the
#   Serif store (https://store.serif.com/en-us/update/macos/publisher/2/).
#   There is no separate update mechanism or uninstaller.
#   Apple Developer Team ID: 6U4T26QF8T (Canva Ltd / Serif).
#   Source: Installomator `affinitypublisher2` label.

# Print the Affinity Publisher 2 DMG URL from the Serif store.
maclib::creative::affinitypublisher2::url() {
  printf '%s\n' 'https://store.serif.com/en-us/update/macos/publisher/2/'
}

# Print the current Affinity Publisher 2 version.
# The version is not exposed via a public API; it must be scraped from the
# Serif store download page. For now, return a placeholder.
maclib::creative::affinitypublisher2::latest_version() {
  maclib::core::log::warn "affinitypublisher2::latest_version: no public version API; returning placeholder"
  printf '%s\n' '2.3.0'
}

# Return 0 if Affinity Publisher 2 is installed.
maclib::creative::affinitypublisher2::is_installed() {
  [[ -d "/Applications/Affinity Publisher 2.app" ]] || [[ -d "$HOME/Applications/Affinity Publisher 2.app" ]]
}

# Print the path to Affinity Publisher 2 if present.
maclib::creative::affinitypublisher2::installed_path() {
  if [[ -d "/Applications/Affinity Publisher 2.app" ]]; then
    printf '%s\n' "/Applications/Affinity Publisher 2.app"
  elif [[ -d "$HOME/Applications/Affinity Publisher 2.app" ]]; then
    printf '%s\n' "$HOME/Applications/Affinity Publisher 2.app"
  fi
}

# Download the Affinity Publisher 2 DMG and install to /Applications.
# Requires root for /Applications.
maclib::creative::affinitypublisher2::install() {
  local dmg_path extract_dir
  dmg_path="$(mktemp -t affinitypublisher2_install.XXXXXX.dmg)" || return 1
  extract_dir="$(mktemp -d /tmp/affinitypublisher2_extract.XXXXXX)" || {
    rm -f "$dmg_path"
    return 1
  }
  trap 'rm -f "$dmg_path"; rm -rf "$extract_dir"' RETURN

  # The Serif store requires authentication for downloads.
  if ! curl -fsL 'https://downloads.affinity.studio/Publisher2.dmg' -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "affinitypublisher2::install: failed to download Publisher 2 DMG"
    maclib::core::log::error "affinitypublisher2::install: download from Serif store requires authentication"
    return 1
  fi

  if ! hdiutil attach "$dmg_path" -nobrowse -noautoopen -mountpoint "$extract_dir" >/dev/null 2>&1; then
    maclib::core::log::error "affinitypublisher2::install: failed to mount DMG"
    return 1
  fi

  local app
  app="$(find "$extract_dir" -maxdepth 2 -type d -name 'Affinity Publisher 2.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin/cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$extract_dir" >/dev/null 2>&1
    return "$rc"
  fi

  hdiutil detach "$extract_dir" >/dev/null 2>&1
  maclib::core::log::error "affinitypublisher2::install: no Affinity Publisher 2.app found in DMG"
  return 1
}

# Affinity Publisher 2 updates are applied by re-installing the latest DMG.
maclib::creative::affinitypublisher2::update() {
  maclib::creative::affinitypublisher2::install "$@"
}

# Uninstall by removing the app bundle.
maclib::creative::affinitypublisher2::uninstall() {
  if [[ -d "/Applications/Affinity Publisher 2.app" ]]; then
    rm -rf "/Applications/Affinity Publisher 2.app"
    return $?
  elif [[ -d "$HOME/Applications/Affinity Publisher 2.app" ]]; then
    rm -rf "$HOME/Applications/Affinity Publisher 2.app"
    return $?
  fi
  maclib::core::log::warn "affinitypublisher2::uninstall: Affinity Publisher 2.app not found"
  return 1
}
