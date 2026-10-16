#!/usr/bin/env bash
# shellcheck disable=all
# microsoftteamsnew.sh - Microsoft Teams (new) (package installer) helpers
#
# Vendor source: Installomator label microsoftteamsnew
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Microsoft Teams (new) ships a signed .pkg whose location is resolved from a
#   Microsoft AutoUpdate XML manifest at
#   https://res.public.onecdn.static.microsoft/mro1cdnstorage/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409TEAMS21.xml
#   (Application ID TEAMS21). Package ID: com.microsoft.teams2. Apple Developer
#   Team ID: UBF8T346G9.

# Print the Microsoft Teams (new) installer package URL.
# The URL is resolved from the Microsoft AutoUpdate XML manifest.
maclib::communication::microsoftteamsnew::suite_installer_url() {
  local mauXML url
  mauXML="$(curl -fsL 'https://res.public.onecdn.static.microsoft/mro1cdnstorage/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409TEAMS21.xml' 2>/dev/null)"
  [[ -n "$mauXML" ]] || return 1
  url="$(printf '%s' "$mauXML" \
    | xmllint --xpath 'string(//dict[key[text()="Application ID"]/following-sibling::string[1]="TEAMS21" and key[text()="Location"]/following-sibling::string[1][contains(.,"/MicrosoftTeams.pkg")]]/key[text()="Location"]/following-sibling::string[1])' - 2>/dev/null)"
  [[ -n "$url" ]] || return 1
  printf '%s\n' "$url"
}

# Print the current Microsoft Teams (new) build version.
# Installomator parses the version from the Microsoft AutoUpdate XML manifest.
maclib::communication::microsoftteamsnew::latest_version() {
  local mauXML version
  mauXML="$(curl -fsL 'https://res.public.onecdn.static.microsoft/mro1cdnstorage/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409TEAMS21.xml' 2>/dev/null)"
  [[ -n "$mauXML" ]] || return 1
  version="$(printf '%s' "$mauXML" \
    | xmllint --xpath 'string(//dict[key[text()="Application ID"]/following-sibling::string[1]="TEAMS21" and key[text()="Location"]/following-sibling::string[1][contains(.,"/MicrosoftTeams.pkg")]]/key[text()="Update Version"]/following-sibling::string[1])' - 2>/dev/null)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Microsoft Teams app bundle is installed.
maclib::communication::microsoftteamsnew::is_installed() {
  [[ -d "/Applications/Microsoft Teams.app" ]] || [[ -d "$HOME/Applications/Microsoft Teams.app" ]]
}

# Print the path to the Microsoft Teams app bundle if present.
maclib::communication::microsoftteamsnew::installed_path() {
  if [[ -d "/Applications/Microsoft Teams.app" ]]; then
    printf '%s\n' "/Applications/Microsoft Teams.app"
  elif [[ -d "$HOME/Applications/Microsoft Teams.app" ]]; then
    printf '%s\n' "$HOME/Applications/Microsoft Teams.app"
  else
    return 1
  fi
}

# Download the Microsoft Teams (new) installer package and install it (requires
# root).
maclib::communication::microsoftteamsnew::install() {
  local url tmp
  url="$(maclib::communication::microsoftteamsnew::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  tmp="$(mktemp -t "microsoftteamsnew_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "microsoftteamsnew::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Microsoft Teams (new) updates are delivered through Microsoft Auto Update's
# msupdate tool (apps TEAMS21) when present, otherwise by re-installing the
# latest package (see install()).
maclib::communication::microsoftteamsnew::update() {
  local tool
  tool='/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate'
  if [[ -x "$tool" ]]; then
    "$tool" --install --apps TEAMS21 "$@"
    return $?
  fi
  if command -v msupdate >/dev/null 2>&1; then
    msupdate --install --apps TEAMS21 "$@"
    return $?
  fi
  maclib::communication::microsoftteamsnew::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::microsoftteamsnew::uninstall() {
  maclib::core::log::warn "microsoftteamsnew::uninstall: no clean uninstall"
  return 1
}
