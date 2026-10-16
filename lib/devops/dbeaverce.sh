#!/usr/bin/env bash
# shellcheck disable=all
# dbeaverce.sh - DBeaver (Installomator label) helpers
#
# Vendor source: Installomator label dbeaverce from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::devops::dbeaverce::suite_installer_url() {
  # TODO: Add actual download URL for DBeaver
  printf '%s\\n' 'https://example.com/dbeaverce/installer'
}

maclib::devops::dbeaverce::latest_version() {
  # TODO: Add version detection for DBeaver
  return 1
}

maclib::devops::dbeaverce::is_installed() {
  [[ -d "/Applications/Dbeaver.app" ]] || [[ -d "$HOME/Applications/Dbeaver.app" ]]
}

maclib::devops::dbeaverce::installed_path() {
  if [[ -d "/Applications/Dbeaver.app" ]]; then
    printf '%s\\n' "/Applications/Dbeaver.app"
  elif [[ -d "$HOME/Applications/Dbeaver.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dbeaver.app"
  fi
}

maclib::dbeaverce::install() {
  local url tmp mp app
  url="$(maclib::dbeaverce::suite_installer_url)"
  tmp="$(mktemp -d -t "dbeaverce.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dbeaverce::install: download failed"
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


maclib::devops::dbeaverce::update() {
  # No vendor update path documented for "DBeaver".
  maclib::core::log::error "dbeaverce::update: no update path"
  return 127
}

maclib::devops::dbeaverce::uninstall() {
  # No clean uninstall for "DBeaver" (documented constraint).
  maclib::core::log::error "dbeaverce::uninstall: no clean uninstall"
  return 1
}
