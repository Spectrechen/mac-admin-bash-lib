#!/usr/bin/env bash
# app.sh - macOS application (bundle) management helpers

# Return 0 if an application bundle (.app) exists in a standard location.
maclib::core::app::is_installed() {
  local name="${1:-}"
  [[ -n "$name" ]] || {
    maclib::core::log::error "is_installed: no app name given"
    return 2
  }
  [[ -d "/Applications/$name.app" ]] || [[ -d "$HOME/Applications/$name.app" ]]
}

# Print the path to an installed .app bundle (or empty if not found).
maclib::core::app::path() {
  local name="${1:-}"
  [[ -n "$name" ]] || return 2
  if [[ -d "/Applications/$name.app" ]]; then
    printf '%s\n' "/Applications/$name.app"
  elif [[ -d "$HOME/Applications/$name.app" ]]; then
    printf '%s\n' "$HOME/Applications/$name.app"
  fi
}

# Install an application by copying its .app bundle to /Applications (requires root).
maclib::core::app::install() {
  local source="${1:-}"
  [[ -n "$source" ]] || {
    maclib::core::log::error "install: no .app source given"
    return 2
  }
  [[ -d "$source" ]] || {
    maclib::core::log::error "install: not a bundle: $source"
    return 1
  }
  /usr/bin cp -R "$source" "/Applications/" "$@"
}

# Uninstall an application by removing its .app bundle.
maclib::core::app::uninstall() {
  local name="${1:-}"
  [[ -n "$name" ]] || {
    maclib::core::log::error "uninstall: no app name given"
    return 2
  }
  rm -rf "/Applications/$name.app" "$HOME/Applications/$name.app" "$@"
}

# Print common installation locations for an application bundle.
maclib::core::app::locations() {
  local name="${1:-}"
  [[ -n "$name" ]] || return 2
  [[ -d "/Applications/$name.app" ]] && printf '%s\n' "/Applications/$name.app"
  [[ -d "$HOME/Applications/$name.app" ]] && printf '%s\n' "$HOME/Applications/$name.app"
}
