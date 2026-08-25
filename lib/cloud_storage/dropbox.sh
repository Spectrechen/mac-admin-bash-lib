#!/usr/bin/env bash
# dropbox.sh - Dropbox (disk image) helpers
#
# Vendor research (see docs/dropbox-vendor-notes.md):
#   Dropbox ships a signed .dmg from https://www.dropbox.com/download?plat=mac.
#   The current build is parsed from the redirect Location header.
#   Apple Developer Team ID: G7HH3F8CAK.
#   Source: Installomator `dropbox` label.

# Print the Dropbox installer disk-image URL.
maclib::dropbox::url() {
  printf '%s\n' 'https://www.dropbox.com/download?plat=mac&full=1'
}

# Print the current Dropbox build version.
# Installomator parses the version from the redirect Location header.
maclib::dropbox::latest_version() {
  local url location version
  url="$(maclib::dropbox::url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | sed -E 's/.*%20([0-9.]*)\.dmg.*/\1/')"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Dropbox app bundle is installed.
maclib::dropbox::is_installed() {
  [[ -d "/Applications/Dropbox.app" ]] || [[ -d "$HOME/Applications/Dropbox.app" ]]
}

# Print the path to the Dropbox app bundle if present.
maclib::dropbox::installed_path() {
  if [[ -d "/Applications/Dropbox.app" ]]; then
    printf '%s\n' "/Applications/Dropbox.app"
  elif [[ -d "$HOME/Applications/Dropbox.app" ]]; then
    printf '%s\n' "$HOME/Applications/Dropbox.app"
  fi
}

# Download the Dropbox disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::dropbox::install() {
  local url dmg mount
  url="$(maclib::dropbox::url)"
  dmg="$(mktemp -t "dropbox_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/dropbox_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "dropbox::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "dropbox::install: failed to mount disk image"
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
  maclib::log::error "dropbox::install: no .app found in disk image"
  return 1
}

# Dropbox updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
