#!/usr/bin/env bash
# shellcheck disable=all
# deepl.sh - DeepL (Installomator label) helpers
#
# Vendor source: Installomator label deepl from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/d::deepl::suite_installer_url() {
  # TODO: Add actual download URL for DeepL
  printf '%s\\n' 'https://example.com/deepl/installer'
}

maclib::apps/d::deepl::latest_version() {
  # TODO: Add version detection for DeepL
  return 1
}

maclib::apps/d::deepl::is_installed() {
  [[ -d "/Applications/Deepl.app" ]] || [[ -d "$HOME/Applications/Deepl.app" ]]
}

maclib::apps/d::deepl::installed_path() {
  if [[ -d "/Applications/Deepl.app" ]]; then
    printf '%s\\n' "/Applications/Deepl.app"
  elif [[ -d "$HOME/Applications/Deepl.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Deepl.app"
  fi
}

maclib::deepl::install() {
  local url tmp mp app
  url="$(maclib::deepl::suite_installer_url)"
  tmp="$(mktemp -d -t "deepl.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "deepl::install: download failed"
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


maclib::apps/d::deepl::update() {
  # No vendor update path documented for "DeepL".
  maclib::core::log::error "deepl::update: no update path"
  return 127
}

maclib::apps/d::deepl::uninstall() {
  # No clean uninstall for "DeepL" (documented constraint).
  maclib::core::log::error "deepl::uninstall: no clean uninstall"
  return 1
}
