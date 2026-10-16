#!/usr/bin/env bash
# aquamacs.sh - Aquamacs Emacs helpers
#
# Vendor research:
#   Aquamacs is the Emacs distribution for macOS.
#   Source: https://aquamacs.org/
#   - Latest stable version: 3.6 (Mac OS 10.11+ El Capitan or later)
#   - Download page: https://aquamacs.org/downloads/
#   - DMG download URL (stable 3.6):
#       https://aquamacs.org/file_download/aquamacs-emacs-3.6.dmg
#   - Alpha 4 (based on Emacs 29.4) also available.
#   - Team ID: DTBC5BX3L9
#   - App location: /Applications/Aquamacs Emacs.app
#   - Installs via DMG (app bundle copy).

# Print the Aquamacs downloads page URL.
maclib::apps::aquamacs::suite_installer_url() {
  printf '%s\n' 'https://aquamacs.org/downloads/'
}

# Print the latest version string.
maclib::apps::aquamacs::latest_version() {
  local ver
  # Try to extract from downloads page
  ver=$(curl -fsSL 'https://aquamacs.org/downloads/' 2>/dev/null | \
    grep -oE 'Aquamacs Emacs [0-9]+\.[0-9]+' | head -1 | grep -oE '[0-9]+\.[0-9]+')
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  # Fallback: known latest
  printf '%s\n' '3.6'
  return 0
}

# Return 0 if Aquamacs is installed.
maclib::apps::aquamacs::is_installed() {
  [[ -d '/Applications/Aquamacs Emacs.app' ]]
  return $?
}

# Print the installed app path if present.
maclib::apps::aquamacs::installed_path() {
  if [[ -d '/Applications/Aquamacs Emacs.app' ]]; then
    printf '%s\n' '/Applications/Aquamacs Emacs.app'
    return 0
  fi
  return 1
}

# Download and install Aquamacs from the DMG.
# Requires root to write to /Applications.
maclib::apps::aquamacs::install() {
  local ver dmg_path tmp_dir
  ver="$(maclib::apps::aquamacs::latest_version)"
  dmg_path="https://aquamacs.org/file_download/aquamacs-emacs-${ver}.dmg"

  tmp_dir="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp_dir"' RETURN

  local dmg_file="$tmp_dir/aquamacs.dmg"
  if ! curl -fsL "$dmg_path" -o "$dmg_file" 2>/dev/null; then
    maclib::core::log::error "aquamacs::install: failed to download DMG"
    return 1
  fi

  local mount_point="$tmp_dir/mount"
  mkdir -p "$mount_point"
  if ! hdiutil attach "$dmg_file" -mountpoint "$mount_point" -nobrowse -quiet 2>/dev/null; then
    maclib::core::log::error "aquamacs::install: failed to mount DMG"
    return 1
  fi

  # Find the Aquamacs app in the DMG
  local app_path
  app_path="$(find "$mount_point" -name 'Aquamacs Emacs.app' -type d | head -1)"
  if [[ -z "$app_path" ]]; then
    maclib::core::log::error "aquamacs::install: no Aquamacs Emacs.app found in DMG"
    hdiutil detach "$mount_point" -quiet 2>/dev/null
    return 1
  fi

  # Copy to /Applications (remove existing first)
  rm -rf '/Applications/Aquamacs Emacs.app'
  cp -R "$app_path" '/Applications/'
  local rc=$?
  hdiutil detach "$mount_point" -quiet 2>/dev/null
  return "$rc"
}

# Update: same as install (reinstalls latest from DMG).
maclib::apps::aquamacs::update() {
  maclib::apps::aquamacs::install "$@"
}

# Uninstall: remove app bundle and preferences.
maclib::apps::aquamacs::uninstall() {
  rm -rf '/Applications/Aquamacs Emacs.app'
  rm -rf "$HOME/Library/Preferences/org.gnu.Aquamacs*"
  rm -rf "$HOME/Library/Caches/org.gnu.Aquamacs*"
  rm -rf "$HOME/Library/Saved Application State/org.gnu.Aquamacs.*"
}
