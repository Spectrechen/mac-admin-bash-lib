#!/usr/bin/env bash
# shellcheck disable=all
# easeusdatarecoverywizard.sh - EaseUS Data Recovery Wizard (Installomator label) helpers
#
# Vendor source: Installomator label easeusdatarecoverywizard from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/e::easeusdatarecoverywizard::suite_installer_url() {
  # TODO: Add actual download URL for EaseUS Data Recovery Wizard
  printf '%s\\n' 'https://example.com/easeusdatarecoverywizard/installer'
}

maclib::apps/e::easeusdatarecoverywizard::latest_version() {
  # TODO: Add version detection for EaseUS Data Recovery Wizard
  return 1
}

maclib::apps/e::easeusdatarecoverywizard::is_installed() {
  [[ -d "/Applications/Easeus Data Recovery Wizard.app" ]] || [[ -d "$HOME/Applications/Easeus Data Recovery Wizard.app" ]]
}

maclib::apps/e::easeusdatarecoverywizard::installed_path() {
  if [[ -d "/Applications/Easeus Data Recovery Wizard.app" ]]; then
    printf '%s\\n' "/Applications/Easeus Data Recovery Wizard.app"
  elif [[ -d "$HOME/Applications/Easeus Data Recovery Wizard.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Easeus Data Recovery Wizard.app"
  fi
}

maclib::easeusdatarecoverywizard::install() {
  local url tmp mp app
  url="$(maclib::easeusdatarecoverywizard::suite_installer_url)"
  tmp="$(mktemp -d -t "easeusdatarecoverywizard.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "easeusdatarecoverywizard::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::apps/e::easeusdatarecoverywizard::update() {
  # No vendor update path documented for "EaseUS Data Recovery Wizard".
  maclib::core::log::error "easeusdatarecoverywizard::update: no update path"
  return 127
}

maclib::apps/e::easeusdatarecoverywizard::uninstall() {
  # No clean uninstall for "EaseUS Data Recovery Wizard" (documented constraint).
  maclib::core::log::error "easeusdatarecoverywizard::uninstall: no clean uninstall"
  return 1
}
