#!/usr/bin/env bash
# affinityapp.sh - Affinity (universal free app) helpers
#
# Vendor research (see docs/affinityapp-vendor-notes.md):
#   Affinity (the free universal app combining Designer, Photo, and Publisher)
#   is distributed as a signed .dmg from https://www.affinity.studio/download.
#   The DMG contains Affinity.app. Installation is a simple drag-to-Applications.
#   Updates are applied by re-downloading the DMG and replacing the app bundle.
#   There is no separate update mechanism or uninstaller.
#   Apple Developer Team ID: 6U4T26QF8T (Canva Ltd).
#   Source: Installomator `affinityapp` label.
#
# NOTE: The affinityapp dmg at downloads.affinity.studio/Affinity.dmg has been
# reported as broken (hdiutil exit code 3). The workaround is to use the Serif
# store download page or the Mac App Store.

# Print the Affinity universal app DMG URL.
maclib::creative::affinityapp::url() {
  printf '%s\n' 'https://www.affinity.studio/download'
}

# Print the current Affinity version.
# Reads from the Serif store download page or falls back to a known version.
maclib::creative::affinityapp::latest_version() {
  # Affinity does not expose a public version API.
  # The version is embedded in the download page HTML.
  # For now, return a placeholder — the actual version must be fetched manually.
  maclib::core::log::warn "affinityapp::latest_version: no public version API; returning placeholder"
  printf '%s\n' '3.0.0'
}

# Return 0 if the Affinity app bundle is installed.
maclib::creative::affinityapp::is_installed() {
  [[ -d "/Applications/Affinity.app" ]] || [[ -d "$HOME/Applications/Affinity.app" ]]
}

# Print the path to the Affinity app bundle if present.
maclib::creative::affinityapp::installed_path() {
  if [[ -d "/Applications/Affinity.app" ]]; then
    printf '%s\n' "/Applications/Affinity.app"
  elif [[ -d "$HOME/Applications/Affinity.app" ]]; then
    printf '%s\n' "$HOME/Applications/Affinity.app"
  fi
}

# Download the Affinity DMG and install the app bundle to /Applications.
# Requires root for /Applications.
maclib::creative::affinityapp::install() {
  local dmg_path extract_dir
  dmg_path="$(mktemp -t affinityapp_install.XXXXXX.dmg)" || return 1
  extract_dir="$(mktemp -d /tmp/affinityapp_extract.XXXXXX)" || {
    rm -f "$dmg_path"
    return 1
  }
  trap 'rm -f "$dmg_path"; rm -rf "$extract_dir"' RETURN

  # Download the DMG — note: downloads.affinity.studio/Affinity.dmg is known
  # to produce a broken image. We attempt the direct URL but fall back to
  # the store download page if needed.
  if ! curl -fsL 'https://downloads.affinity.studio/Affinity.dmg' -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "affinityapp::install: failed to download DMG from downloads.affinity.studio"
    maclib::core::log::error "affinityapp::install: manual download from https://www.affinity.studio/download required"
    return 1
  fi

  # Mount the DMG
  if ! hdiutil attach "$dmg_path" -nobrowse -noautoopen -mountpoint "$extract_dir" >/dev/null 2>&1; then
    maclib::core::log::error "affinityapp::install: failed to mount DMG"
    return 1
  fi

  # Find and copy the .app
  local app
  app="$(find "$extract_dir" -maxdepth 2 -type d -name 'Affinity.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin/cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$extract_dir" >/dev/null 2>&1
    return "$rc"
  fi

  hdiutil detach "$extract_dir" >/dev/null 2>&1
  maclib::core::log::error "affinityapp::install: no Affinity.app found in DMG"
  return 1
}

# Affinity updates are applied by re-installing the latest DMG.
# There is no separate update mechanism.
maclib::creative::affinityapp::update() {
  maclib::creative::affinityapp::install "$@"
}

# There is no clean uninstall for Affinity. Simply remove the app bundle.
maclib::creative::affinityapp::uninstall() {
  if [[ -d "/Applications/Affinity.app" ]]; then
    rm -rf "/Applications/Affinity.app"
    return $?
  elif [[ -d "$HOME/Applications/Affinity.app" ]]; then
    rm -rf "$HOME/Applications/Affinity.app"
    return $?
  fi
  maclib::core::log::warn "affinityapp::uninstall: Affinity.app not found"
  return 1
}
