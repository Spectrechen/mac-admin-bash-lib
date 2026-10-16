#!/usr/bin/env bash
# affinitydesigner2.sh - Affinity Designer 2 helpers
#
# Vendor research (see docs/affinitydesigner2-vendor-notes.md):
#   Affinity Designer 2 is distributed as a signed .dmg from the Serif store.
#   The DMG contains Affinity Designer 2.app. Installation is a simple
#   drag-to-Applications. Updates are applied by re-downloading from the
#   Serif store (https://store.serif.com/en-us/update/macos/designer/2/).
#   There is no separate update mechanism or uninstaller.
#   Apple Developer Team ID: 6U4T26QF8T (Canva Ltd / Serif).
#   Source: Installomator `affinitydesigner2` label.

# Print the Affinity Designer 2 DMG URL from the Serif store.
maclib::creative::affinitydesigner2::url() {
  printf '%s\n' 'https://store.serif.com/en-us/update/macos/designer/2/'
}

# Print the current Affinity Designer 2 version.
# The version is not exposed via a public API; it must be scraped from the
# Serif store download page. For now, return a placeholder.
maclib::creative::affinitydesigner2::latest_version() {
  maclib::core::log::warn "affinitydesigner2::latest_version: no public version API; returning placeholder"
  printf '%s\n' '2.3.0'
}

# Return 0 if Affinity Designer 2 is installed.
maclib::creative::affinitydesigner2::is_installed() {
  [[ -d "/Applications/Affinity Designer 2.app" ]] || [[ -d "$HOME/Applications/Affinity Designer 2.app" ]]
}

# Print the path to Affinity Designer 2 if present.
maclib::creative::affinitydesigner2::installed_path() {
  if [[ -d "/Applications/Affinity Designer 2.app" ]]; then
    printf '%s\n' "/Applications/Affinity Designer 2.app"
  elif [[ -d "$HOME/Applications/Affinity Designer 2.app" ]]; then
    printf '%s\n' "$HOME/Applications/Affinity Designer 2.app"
  fi
}

# Download the Affinity Designer 2 DMG and install to /Applications.
# Requires root for /Applications.
maclib::creative::affinitydesigner2::install() {
  local dmg_path extract_dir
  dmg_path="$(mktemp -t affinitydesigner2_install.XXXXXX.dmg)" || return 1
  extract_dir="$(mktemp -d /tmp/affinitydesigner2_extract.XXXXXX)" || {
    rm -f "$dmg_path"
    return 1
  }
  trap 'rm -f "$dmg_path"; rm -rf "$extract_dir"' RETURN

  # The Serif store requires authentication for downloads.
  # For unauthenticated deployments, use the Mac App Store or the
  # universal license download page.
  if ! curl -fsL 'https://downloads.affinity.studio/Designer2.dmg' -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "affinitydesigner2::install: failed to download Designer 2 DMG"
    maclib::core::log::error "affinitydesigner2::install: download from Serif store requires authentication"
    return 1
  fi

  if ! hdiutil attach "$dmg_path" -nobrowse -noautoopen -mountpoint "$extract_dir" >/dev/null 2>&1; then
    maclib::core::log::error "affinitydesigner2::install: failed to mount DMG"
    return 1
  fi

  local app
  app="$(find "$extract_dir" -maxdepth 2 -type d -name 'Affinity Designer 2.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin/cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$extract_dir" >/dev/null 2>&1
    return "$rc"
  fi

  hdiutil detach "$extract_dir" >/dev/null 2>&1
  maclib::core::log::error "affinitydesigner2::install: no Affinity Designer 2.app found in DMG"
  return 1
}

# Affinity Designer 2 updates are applied by re-installing the latest DMG.
maclib::creative::affinitydesigner2::update() {
  maclib::creative::affinitydesigner2::install "$@"
}

# Uninstall by removing the app bundle.
maclib::creative::affinitydesigner2::uninstall() {
  if [[ -d "/Applications/Affinity Designer 2.app" ]]; then
    rm -rf "/Applications/Affinity Designer 2.app"
    return $?
  elif [[ -d "$HOME/Applications/Affinity Designer 2.app" ]]; then
    rm -rf "$HOME/Applications/Affinity Designer 2.app"
    return $?
  fi
  maclib::core::log::warn "affinitydesigner2::uninstall: Affinity Designer 2.app not found"
  return 1
}
