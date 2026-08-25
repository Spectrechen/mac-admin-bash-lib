#!/usr/bin/env bash
# notion.sh - Notion (disk image) helpers
#
# Vendor research (see docs/notion-vendor-notes.md):
#   Notion ships a signed .dmg from https://www.notion.so/desktop/mac/download.
#   The current build is parsed from the redirect Location header.
#   Apple Developer Team ID: LBQJ96FQ8D.
#   Source: Installomator `notion` label.

# Print the Notion installer disk-image URL.
maclib::notion::url() {
  printf '%s\n' 'https://www.notion.so/desktop/mac/download'
}

# Print the current Notion build version.
# Installomator parses the version from the redirect Location header.
maclib::notion::latest_version() {
  local url location version
  url="$(maclib::notion::url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | sed -E 's/.*Notion-([0-9.]*)\.dmg.*/\1/; s/.*%20([0-9.]*)\.dmg.*/\1/')"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Notion app bundle is installed.
maclib::notion::is_installed() {
  [[ -d "/Applications/Notion.app" ]] || [[ -d "$HOME/Applications/Notion.app" ]]
}

# Print the path to the Notion app bundle if present.
maclib::notion::installed_path() {
  if [[ -d "/Applications/Notion.app" ]]; then
    printf '%s\n' "/Applications/Notion.app"
  elif [[ -d "$HOME/Applications/Notion.app" ]]; then
    printf '%s\n' "$HOME/Applications/Notion.app"
  fi
}

# Download the Notion disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::notion::install() {
  local url dmg mount
  url="$(maclib::notion::url)"
  dmg="$(mktemp -t "notion_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/notion_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "notion::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "notion::install: failed to mount disk image"
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
  maclib::log::error "notion::install: no .app found in disk image"
  return 1
}

# Notion updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
