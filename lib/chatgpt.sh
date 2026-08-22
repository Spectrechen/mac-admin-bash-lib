#!/usr/bin/env bash
# chatgpt.sh - OpenAI ChatGPT (disk image) helpers
#
# Vendor research (see docs/chatgpt-vendor-notes.md):
#   ChatGPT for Mac ships a signed .dmg from a persistent OpenAI CDN URL
#   (Apple Silicon only). The current build is read from the public appcast.
#   Apple Developer Team ID: 2DC432GLL2.
#   Source: Installomator `chatgpt` label.

# Print the ChatGPT installer disk-image URL (Apple Silicon).
maclib::chatgpt::url() {
  printf '%s\n' 'https://persistent.oaistatic.com/sidekick/public/ChatGPT_Desktop_public_latest.dmg'
}

# Print the current ChatGPT build version.
# Reads the version from the public appcast title.
maclib::chatgpt::latest_version() {
  local html version
  html="$(curl -fs 'https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml' 2>/dev/null)"
  [[ -n "$html" ]] || return 1
  version="$(printf '%s' "$html" | sed -nE 's/.*<title>([0-9.]+)<\/title>.*/\1/p' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the ChatGPT app bundle is installed.
maclib::chatgpt::is_installed() {
  [[ -d "/Applications/ChatGPT.app" ]] || [[ -d "$HOME/Applications/ChatGPT.app" ]]
}

# Print the path to the ChatGPT app bundle if present.
maclib::chatgpt::installed_path() {
  if [[ -d "/Applications/ChatGPT.app" ]]; then
    printf '%s\n' "/Applications/ChatGPT.app"
  elif [[ -d "$HOME/Applications/ChatGPT.app" ]]; then
    printf '%s\n' "$HOME/Applications/ChatGPT.app"
  fi
}

# Download the ChatGPT disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::chatgpt::install() {
  local url dmg mount
  url="$(maclib::chatgpt::url)"
  dmg="$(mktemp -t "chatgpt_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/chatgpt_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "chatgpt::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "chatgpt::install: failed to mount disk image"
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
  maclib::log::error "chatgpt::install: no .app found in disk image"
  return 1
}

# ChatGPT updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
