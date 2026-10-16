#!/usr/bin/env bash
# affinityphoto2.sh - Affinity Photo 2 helpers
#
# Vendor research (see docs/affinityphoto2-vendor-notes.md):
#   Affinity Photo 2 is distributed as a signed .dmg from the Serif store.
#   The DMG contains Affinity Photo 2.app. Installation is a simple
#   drag-to-Applications. Updates are applied by re-downloading from the
#   Serif store (https://store.serif.com/en-us/update/macos/photo/2/).
#   There is no separate update mechanism or uninstaller.
#   Apple Developer Team ID: 6U4T26QF8T (Canva Ltd / Serif).
#   Source: Installomator `affinityphoto2` label.

# Print the Affinity Photo 2 DMG URL from the Serif store.
maclib::creative::affinityphoto2::url() {
  printf '%s\n' 'https://store.serif.com/en-us/update/macos/photo/2/'
}

# Print the current Affinity Photo 2 version.
# The version is not exposed via a public API; it must be scraped from the
# Serif store download page. For now, return a placeholder.
maclib::creative::affinityphoto2::latest_version() {
  maclib::core::log::warn "affinityphoto2::latest_version: no public version API; returning placeholder"
  printf '%s\n' '2.3.0'
}

# Return 0 if Affinity Photo 2 is installed.
maclib::creative::affinityphoto2::is_installed() {
  [[ -d "/Applications/Affinity Photo 2.app" ]] || [[ -d "$HOME/Applications/Affinity Photo 2.app" ]]
}

# Print the path to Affinity Photo 2 if present.
maclib::creative::affinityphoto2::installed_path() {
  if [[ -d "/Applications/Affinity Photo 2.app" ]]; then
    printf '%s\n' "/Applications/Affinity Photo 2.app"
  elif [[ -d "$HOME/Applications/Affinity Photo 2.app" ]]; then
    printf '%s\n' "$HOME/Applications/Affinity Photo 2.app"
  fi
}

# Download the Affinity Photo 2 DMG and install to /Applications.
# Requires root for /Applications.
maclib::creative::affinityphoto2::install() {
  local dmg_path extract_dir
  dmg_path="$(mktemp -t affinityphoto2_install.XXXXXX.dmg)" || return 1
  extract_dir="$(mktemp -d /tmp/affinityphoto2_extract.XXXXXX)" || {
    rm -f "$dmg_path"
    return 1
  }
  trap 'rm -f "$dmg_path"; rm -rf "$extract_dir"' RETURN

  # The Serif store requires authentication for downloads.
  if ! curl -fsL 'https://downloads.affinity.studio/Photo2.dmg' -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "affinityphoto2::install: failed to download Photo 2 DMG"
    maclib::core::log::error "affinityphoto2::install: download from Serif store requires authentication"
    return 1
  fi

  if ! hdiutil attach "$dmg_path" -nobrowse -noautoopen -mountpoint "$extract_dir" >/dev/null 2>&1; then
    maclib::core::log::error "affinityphoto2::install: failed to mount DMG"
    return 1
  fi

  local app
  app="$(find "$extract_dir" -maxdepth 2 -type d -name 'Affinity Photo 2.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin/cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$extract_dir" >/dev/null 2>&1
    return "$rc"
  fi

  hdiutil detach "$extract_dir" >/dev/null 2>&1
  maclib::core::log::error "affinityphoto2::install: no Affinity Photo 2.app found in DMG"
  return 1
}

# Affinity Photo 2 updates are applied by re-installing the latest DMG.
maclib::creative::affinityphoto2::update() {
  maclib::creative::affinityphoto2::install "$@"
}

# Uninstall by removing the app bundle.
maclib::creative::affinityphoto2::uninstall() {
  if [[ -d "/Applications/Affinity Photo 2.app" ]]; then
    rm -rf "/Applications/Affinity Photo 2.app"
    return $?
  elif [[ -d "$HOME/Applications/Affinity Photo 2.app" ]]; then
    rm -rf "$HOME/Applications/Affinity Photo 2.app"
    return $?
  fi
  maclib::core::log::warn "affinityphoto2::uninstall: Affinity Photo 2.app not found"
  return 1
}
