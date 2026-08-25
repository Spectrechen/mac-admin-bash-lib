#!/usr/bin/env bash
# management.sh - macOS MDM / configuration-profile helpers

# Print the raw output of mdmstatus (MDM server URL + serial, or "no MDM").
maclib::management::mdmstatus() {
  /usr/libexec/mdmstatus
}

# Return 0 if the machine is managed by an MDM server.
maclib::management::is_managed() {
  /usr/libexec/mdmstatus >/dev/null 2>&1
}

# Print the MDM server URL if the machine is managed (empty otherwise).
maclib::management::server_url() {
  local out
  out="$(maclib::management::mdmstatus)" || return 1
  # mdmstatus prints: "MDM Server URL: <url>"
  if [[ "$out" =~ MDM\ Server\ URL:\ (.+) ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
  fi
}

# Install a configuration profile (requires root).
maclib::management::install_profile() {
  local profile="${1:-}"
  [[ -n "$profile" ]] || {
    maclib::log::error "install_profile: no .mobilepath given"
    return 2
  }
  /usr/bin/profiles -I -f "$profile" "$@"
}

# List installed configuration profiles.
maclib::management::list_profiles() {
  /usr/bin/profiles -L "$@"
}

# Remove a configuration profile by its UUID (requires root).
maclib::management::remove_profile() {
  local uuid="${1:-}"
  [[ -n "$uuid" ]] || {
    maclib::log::error "remove_profile: no UUID given"
    return 2
  }
  /usr/bin profiles -R -UUID "$uuid" "$@"
}
