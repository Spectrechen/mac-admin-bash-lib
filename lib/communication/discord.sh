#!/usr/bin/env bash
# shellcheck disable=all
# discord.sh - Discord (disk image) helpers
#
# Vendor source: Installomator label discord (github.com/Installomator/Installomator, Installomator.sh).
#   Discord ships a signed .dmg from https://discordapp.com/api/download?platform=osx.
#   The current build is parsed from the redirect Location header of that URL.
#   Apple Developer Team ID: 53Q6R32WPB.

# Print the Discord installer disk-image URL.
maclib::discord::suite_installer_url() {
  printf '%s\n' 'https://discordapp.com/api/download?platform=osx'
}

# Print the current Discord build version.
# Installomator parses the version from the redirect Location header of the
# installer URL (the dotted number in the redirected path).
maclib::discord::latest_version() {
  local url location version
  url="$(maclib::discord::suite_installer_url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Discord app bundle is installed.
maclib::discord::is_installed() {
  [[ -d "/Applications/Discord.app" ]] || [[ -d "$HOME/Applications/Discord.app" ]]
}

# Print the path to the Discord app bundle if present.
maclib::discord::installed_path() {
  if [[ -d "/Applications/Discord.app" ]]; then
    printf '%s\n' "/Applications/Discord.app"
  elif [[ -d "$HOME/Applications/Discord.app" ]]; then
    printf '%s\n' "$HOME/Applications/Discord.app"
  else
    return 1
  fi
}

# Download the Discord disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::discord::install() {
  local url dmg mount
  url="$(maclib::discord::suite_installer_url)"
  dmg="$(mktemp -t "discord_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/discord_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "discord::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "discord::install: failed to mount disk image"
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
  maclib::log::error "discord::install: no .app found in disk image"
  return 1
}

# Discord updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::discord::update() {
  maclib::discord::install "$@"
}

# No clean uninstall (documented constraint).
maclib::discord::uninstall() {
  maclib::log::warn "discord::uninstall: no clean uninstall"
  return 1
}
