#!/usr/bin/env bash
# shellcheck disable=all
# discordcanary.sh - Discord Canary (disk image) helpers
#
# Vendor source: Installomator label discordcanary (github.com/Installomator/Installomator, Installomator.sh).
#   Discord Canary ships a signed .dmg from
#   https://discord.com/api/download/canary?platform=osx.
#   The current build is parsed from the redirect Location header of that URL.
#   Apple Developer Team ID: 53Q6R32WPB.

# Print the Discord Canary installer disk-image URL.
maclib::discordcanary::suite_installer_url() {
  printf '%s\n' 'https://discord.com/api/download/canary?platform=osx'
}

# Print the current Discord Canary build version.
# Installomator parses the version from the redirect Location header of the
# installer URL (the dotted number in the redirected path).
maclib::discordcanary::latest_version() {
  local url location version
  url="$(maclib::discordcanary::suite_installer_url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Discord Canary app bundle is installed.
maclib::discordcanary::is_installed() {
  [[ -d "/Applications/Discord Canary.app" ]] || [[ -d "$HOME/Applications/Discord Canary.app" ]]
}

# Print the path to the Discord Canary app bundle if present.
maclib::discordcanary::installed_path() {
  if [[ -d "/Applications/Discord Canary.app" ]]; then
    printf '%s\n' "/Applications/Discord Canary.app"
  elif [[ -d "$HOME/Applications/Discord Canary.app" ]]; then
    printf '%s\n' "$HOME/Applications/Discord Canary.app"
  else
    return 1
  fi
}

# Download the Discord Canary disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::discordcanary::install() {
  local url dmg mount
  url="$(maclib::discordcanary::suite_installer_url)"
  dmg="$(mktemp -t "discordcanary_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/discordcanary_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "discordcanary::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "discordcanary::install: failed to mount disk image"
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
  maclib::log::error "discordcanary::install: no .app found in disk image"
  return 1
}

# Discord Canary updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::discordcanary::update() {
  maclib::discordcanary::install "$@"
}

# No clean uninstall (documented constraint).
maclib::discordcanary::uninstall() {
  maclib::log::warn "discordcanary::uninstall: no clean uninstall"
  return 1
}
