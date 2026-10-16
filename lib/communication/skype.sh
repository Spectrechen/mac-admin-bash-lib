#!/usr/bin/env bash
# shellcheck disable=all
# skype.sh - Skype (disk image) helpers
#
# Vendor source: Installomator label skype
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Skype ships a signed .dmg from get.skype.com/go/getskype-skypeformac. The
#   current build is parsed from the redirect Location header of that URL (the
#   dotted number embedded in the archive file name).
#   Apple Developer Team ID: AL798K98FX.

# Print the Skype installer disk-image URL.
maclib::communication::skype::suite_installer_url() {
  local url
  url="$(curl -sfi 'https://get.skype.com/go/getskype-skypeformac' 2>/dev/null \
    | awk 'BEGIN{IGNORECASE=1} /location:/ {gsub(/\r/,"",$2); print $2}' | head -n1)"
  [[ -n "$url" ]] || return 1
  printf '%s\n' "$url"
}

# Print the current Skype build version.
# Installomator parses the version from the redirect Location header of the
# installer URL (the dotted number embedded in the archive file name).
maclib::communication::skype::latest_version() {
  local url archiveName version
  url="$(maclib::communication::skype::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  archiveName="$(basename "$url")"
  version="$(printf '%s' "$archiveName" | awk -F'[-.]' '{print $2"."$3"."$4"."$5}' | grep -oE '[0-9]+\.[0-9.]+' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Skype app bundle is installed.
maclib::communication::skype::is_installed() {
  [[ -d "/Applications/Skype.app" ]] || [[ -d "$HOME/Applications/Skype.app" ]]
}

# Print the path to the Skype app bundle if present.
maclib::communication::skype::installed_path() {
  if [[ -d "/Applications/Skype.app" ]]; then
    printf '%s\n' "/Applications/Skype.app"
  elif [[ -d "$HOME/Applications/Skype.app" ]]; then
    printf '%s\n' "$HOME/Applications/Skype.app"
  else
    return 1
  fi
}

# Download the Skype disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::communication::skype::install() {
  local url dmg mount
  url="$(maclib::communication::skype::suite_installer_url)"
  dmg="$(mktemp -t "skype_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/skype_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::core::log::error "skype::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::core::log::error "skype::install: failed to mount disk image"
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
  maclib::core::log::error "skype::install: no .app found in disk image"
  return 1
}

# Skype updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::communication::skype::update() {
  maclib::communication::skype::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::skype::uninstall() {
  maclib::core::log::warn "skype::uninstall: no clean uninstall"
  return 1
}
