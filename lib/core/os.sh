#!/usr/bin/env bash
# os.sh - macOS detection helpers

maclib::core::os::is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

maclib::core::os::version() {
  # Outputs e.g. 14.4.1
  if ! maclib::core::os::is_macos; then
    printf 'maclib::core::os::version: not macOS
' >&2
    return 1
  fi
  /usr/bin/sw_vers -productVersion
}

maclib::core::os::major_minor() {
  local v
  v="$(maclib::core::os::version)"
  # Keep first two components
  local major minor rest
  IFS='.' read -r major minor rest <<<"$v"
  printf '%s.%s
' "$major" "$minor"
}

maclib::core::os::arch() {
  uname -m
}
