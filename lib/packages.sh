#!/usr/bin/env bash
# packages.sh - macOS package (pkgutil) helpers

# Install a .pkg installer (requires root).
maclib::packages::pkg_install() {
  local pkg="${1:-}"
  [[ -n "$pkg" ]] || {
    maclib::log::error "pkg_install: no .pkg path given"
    return 2
  }
  /usr/sbin/installer -pkg "$pkg" -target "$@"
}

# List installed packages (one package ID per line).
maclib::packages::pkg_list() {
  /usr/sbin/pkgutil --pkgs "$@"
}

# Print installation info (paths, version) for a given package ID.
maclib::packages::pkg_info() {
  local id="${1:-}"
  [[ -n "$id" ]] || {
    maclib::log::error "pkg_info: no package ID given"
    return 2
  }
  /usr/sbin/pkgutil --pkg-info "$id" "$@"
}

# Forget a package from the pkgutil database (does not uninstall files).
maclib::packages::pkg_forget() {
  local id="${1:-}"
  [[ -n "$id" ]] || {
    maclib::log::error "pkg_forget: no package ID given"
    return 2
  }
  /usr/sbin/pkgutil --forget "$id" "$@"
}

# List all files belonging to a given package ID (requires root).
maclib::packages::pkg_files() {
  local id="${1:-}"
  [[ -n "$id" ]] || {
    maclib::log::error "pkg_files: no package ID given"
    return 2
  }
  /usr/sbin/pkgutil --files "$id" "$@"
}

# List all receipt (metadata) files registered with pkgutil.
maclib::packages::pkg_receipts() {
  /usr/sbin/pkgutil --receipts "$@"
}
