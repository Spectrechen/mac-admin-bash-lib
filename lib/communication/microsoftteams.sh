#!/usr/bin/env bash
# shellcheck disable=all
# microsoftteams.sh - Microsoft Teams classic (package installer) helpers
#
# Vendor source: Installomator label microsoftteamsclassic|microsoftteams
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Microsoft Teams classic ships a signed .pkg from the Microsoft fwlink
#   https://go.microsoft.com/fwlink/?linkid=869428. The current build is parsed
#   from the redirect Location header. Updates are delivered through Microsoft
#   AutoUpdate's msupdate tool (apps TEAMS10).
#   Apple Developer Team ID: UBF8T346G9.

# Print the Microsoft Teams classic installer package URL.
maclib::microsoftteams::suite_installer_url() {
  printf '%s\n' 'https://go.microsoft.com/fwlink/?linkid=869428'
}

# Print the current Microsoft Teams classic build version.
# Installomator parses the version from the redirect Location header of the
# fwlink (the fifth path segment).
maclib::microsoftteams::latest_version() {
  local url location version
  url="$(maclib::microsoftteams::suite_installer_url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | cut -d '/' -f5 | grep -oE '[0-9]+\.[0-9.]+' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Microsoft Teams classic app bundle is installed.
maclib::microsoftteams::is_installed() {
  [[ -d "/Applications/Microsoft Teams.app" ]] || [[ -d "$HOME/Applications/Microsoft Teams.app" ]]
}

# Print the path to the Microsoft Teams classic app bundle if present.
maclib::microsoftteams::installed_path() {
  if [[ -d "/Applications/Microsoft Teams.app" ]]; then
    printf '%s\n' "/Applications/Microsoft Teams.app"
  elif [[ -d "$HOME/Applications/Microsoft Teams.app" ]]; then
    printf '%s\n' "$HOME/Applications/Microsoft Teams.app"
  else
    return 1
  fi
}

# Download the Microsoft Teams classic installer package and install it (requires
# root).
maclib::microsoftteams::install() {
  local url tmp
  url="$(maclib::microsoftteams::suite_installer_url)"
  tmp="$(mktemp -t "microsoftteams_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "microsoftteams::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Microsoft Teams classic updates are delivered through Microsoft AutoUpdate's
# msupdate tool (apps TEAMS10) when present, otherwise by re-installing the
# latest package (see install()).
maclib::microsoftteams::update() {
  local tool
  tool='/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate'
  if [[ -x "$tool" ]]; then
    "$tool" --install --apps TEAMS10 "$@"
    return $?
  fi
  if command -v msupdate >/dev/null 2>&1; then
    msupdate --install --apps TEAMS10 "$@"
    return $?
  fi
  maclib::microsoftteams::install "$@"
}

# No clean uninstall (documented constraint).
maclib::microsoftteams::uninstall() {
  maclib::log::warn "microsoftteams::uninstall: no clean uninstall"
  return 1
}
