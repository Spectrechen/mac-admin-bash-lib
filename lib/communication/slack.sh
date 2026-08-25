#!/usr/bin/env bash
# slack.sh - Slack (package installer) helpers
#
# Vendor research (see docs/slack-vendor-notes.md):
#   Slack ships a signed .pkg from its API endpoint
#   https://slack.com/api/desktop.latestRelease?redirect=1&variant=pkg&arch=universal.
#   The current build is embedded in the redirect Location header.
#   Apple Developer Team ID: BQR82RBBHL ; package ID: com.slack.client.
#   Source: Installomator `slack` label.

# Print the Slack package installer URL.
maclib::slack::url() {
  printf '%s\n' 'https://slack.com/api/desktop.latestRelease?redirect=1&variant=pkg&arch=universal'
}

# Print the current Slack build version.
# Installomator parses the version from the redirect Location header
# (cut -d "/" -f7).
maclib::slack::latest_version() {
  local url location version
  url="$(maclib::slack::url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ll]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  # Version is the dotted number embedded in the redirect Location.
  version="$(printf '%s' "$location" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)*' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Slack app bundle is installed.
maclib::slack::is_installed() {
  [[ -d "/Applications/Slack.app" ]] || [[ -d "$HOME/Applications/Slack.app" ]]
}

# Print the path to the Slack app bundle if present.
maclib::slack::installed_path() {
  if [[ -d "/Applications/Slack.app" ]]; then
    printf '%s\n' "/Applications/Slack.app"
  elif [[ -d "$HOME/Applications/Slack.app" ]]; then
    printf '%s\n' "$HOME/Applications/Slack.app"
  fi
}

# Download the Slack package installer and install it (requires root).
maclib::slack::install() {
  local url tmp
  url="$(maclib::slack::url)"
  tmp="$(mktemp -t "slack_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "slack::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Slack has a self-updating installer; updates are applied by re-installing the
# latest package (see install()). Documented as no separate update path.
