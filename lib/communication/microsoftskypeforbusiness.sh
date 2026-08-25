#!/usr/bin/env bash
# shellcheck disable=all
# microsoftskypeforbusiness.sh - Skype for Business (package installer) helpers
#
# Vendor source: Installomator label microsoftskypeforbusiness
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Skype for Business ships a signed .pkg from the Microsoft fwlink
#   https://go.microsoft.com/fwlink/?linkid=832978. The current build is parsed
#   from the redirect Location header. Updates are delivered through Microsoft
#   AutoUpdate's msupdate tool (apps MSFB16).
#   Apple Developer Team ID: UBF8T346G9.

# Print the Skype for Business installer package URL.
maclib::microsoftskypeforbusiness::suite_installer_url() {
  printf '%s\n' 'https://go.microsoft.com/fwlink/?linkid=832978'
}

# Print the current Skype for Business build version.
# Installomator parses the version from the redirect Location header of the
# fwlink (the dotted number before the .pkg).
maclib::microsoftskypeforbusiness::latest_version() {
  local url location version
  url="$(maclib::microsoftskypeforbusiness::suite_installer_url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | grep -oE '[0-9]+\.[0-9.]+' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Skype for Business app bundle is installed.
maclib::microsoftskypeforbusiness::is_installed() {
  [[ -d "/Applications/Skype for Business.app" ]] || [[ -d "$HOME/Applications/Skype for Business.app" ]]
}

# Print the path to the Skype for Business app bundle if present.
maclib::microsoftskypeforbusiness::installed_path() {
  if [[ -d "/Applications/Skype for Business.app" ]]; then
    printf '%s\n' "/Applications/Skype for Business.app"
  elif [[ -d "$HOME/Applications/Skype for Business.app" ]]; then
    printf '%s\n' "$HOME/Applications/Skype for Business.app"
  else
    return 1
  fi
}

# Download the Skype for Business installer package and install it (requires
# root).
maclib::microsoftskypeforbusiness::install() {
  local url tmp
  url="$(maclib::microsoftskypeforbusiness::suite_installer_url)"
  tmp="$(mktemp -t "skypeforbusiness_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "microsoftskypeforbusiness::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Skype for Business updates are delivered through Microsoft AutoUpdate's
# msupdate tool (apps MSFB16) when present, otherwise by re-installing the
# latest package (see install()).
maclib::microsoftskypeforbusiness::update() {
  local tool
  tool='/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate'
  if [[ -x "$tool" ]]; then
    "$tool" --install --apps MSFB16 "$@"
    return $?
  fi
  if command -v msupdate >/dev/null 2>&1; then
    msupdate --install --apps MSFB16 "$@"
    return $?
  fi
  maclib::microsoftskypeforbusiness::install "$@"
}

# No clean uninstall (documented constraint).
maclib::microsoftskypeforbusiness::uninstall() {
  maclib::log::warn "microsoftskypeforbusiness::uninstall: no clean uninstall"
  return 1
}
