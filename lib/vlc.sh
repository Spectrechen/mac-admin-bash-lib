#!/usr/bin/env bash
# vlc.sh - VLC media player (disk image) helpers
#
# Vendor research (see docs/vlc-vendor-notes.md):
#   VLC ships signed .dmg installers from https://get.videolan.org/vlc/<version>/macosx/.
#   The current build is read from the VLC download page.
#   Apple Developer Team ID: 75GAHG3SZQ.
#   Source: Installomator `vlc` label.

# Print the VLC installer disk-image URL for the current version.
maclib::vlc::url() {
  local version
  version="$(maclib::vlc::latest_version)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "https://get.videolan.org/vlc/${version}/macosx/vlc-${version}-universal.dmg"
}

# Print the current VLC build version.
# Reads the latest version from the VLC download page.
maclib::vlc::latest_version() {
  local html version
  html="$(curl -fsL 'https://www.videolan.org/vlc/' 2>/dev/null)"
  [[ -n "$html" ]] || return 1
  version="$(printf '%s' "$html" | sed -nE 's/.*"latestVersion":"([^"]+)".*/\1/p' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the VLC app bundle is installed.
maclib::vlc::is_installed() {
  [[ -d "/Applications/VLC.app" ]] || [[ -d "$HOME/Applications/VLC.app" ]]
}

# Print the path to the VLC app bundle if present.
maclib::vlc::installed_path() {
  if [[ -d "/Applications/VLC.app" ]]; then
    printf '%s\n' "/Applications/VLC.app"
  elif [[ -d "$HOME/Applications/VLC.app" ]]; then
    printf '%s\n' "$HOME/Applications/VLC.app"
  fi
}

# Download the VLC disk image, mount it and copy the app bundle to /Applications
# (requires root).
maclib::vlc::install() {
  local url dmg mount
  url="$(maclib::vlc::url)"
  [[ -n "$url" ]] || return 1
  dmg="$(mktemp -t "vlc_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/vlc_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "vlc::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "vlc::install: failed to mount disk image"
    return 1
  fi
  local app
  app="$(find "$mount" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$mount" >/dev/null 2>&1
    return "$rc"
  fi
  hdiutil detach "$mount" >/dev/null 2>&1
  maclib::log::error "vlc::install: no .app found in disk image"
  return 1
}

# VLC updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
