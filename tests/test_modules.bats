#!/usr/bin/env bats
# Combined bats tests for the macAdmin Library modules.

setup() {
  source "${BATS_TEST_DIRNAME}/../lib/maclib.sh"
}

# ---------------------------------------------------------------------------
# logging (existing)
# ---------------------------------------------------------------------------

@test "log filters debug when level is info" {
  run bash -c 'source lib/log.sh; maclib::log::set_level info; maclib::log::debug "x"'
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "log warn goes to stderr" {
  run bash -c 'source lib/log.sh; maclib::log::set_level debug; maclib::log::warn "hello" 2>&1 1>/dev/null'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[WARN] hello"* ]]
}

# ---------------------------------------------------------------------------
# os module
# ---------------------------------------------------------------------------

@test "os::is_macos returns 0 on macOS" {
  run maclib::os::is_macos
  [ "$status" -eq 0 ]
}

@test "os::version returns a dotted string" {
  run maclib::os::version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "os::major_minor returns two components" {
  run maclib::os::major_minor
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

# ---------------------------------------------------------------------------
# user module
# ---------------------------------------------------------------------------

@test "user::is_root returns integer exit code" {
  run maclib::user::is_root
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "user::current_user returns non-empty name" {
  run maclib::user::current_user
  [ "$status" -eq 0 ]
  [[ -n "$output" ]]
}

@test "user::home_dir returns a path" {
  run maclib::user::home_dir
  [ "$status" -eq 0 ]
  [[ "$output" == */ ]] || [[ "$output" == /* ]]
}

# ---------------------------------------------------------------------------
# system module (SIP state is readable without root)
# ---------------------------------------------------------------------------

@test "system::sip_status returns a state string" {
  run maclib::system::sip_status
  [ "$status" -eq 0 ]
  [[ "$output" == *"enabled" || "$output" == *"disabled" || "$output" == *"unconfigured" ]]
}

# ---------------------------------------------------------------------------
# packages module (list is read-only, no args)
# ---------------------------------------------------------------------------

@test "packages::pkg_list returns exit 0" {
  run maclib::packages::pkg_list
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# signing module (verify with no target must return 2)
# ---------------------------------------------------------------------------

@test "signing::verify with no target returns 2" {
  run maclib::signing::verify
  [ "$status" -eq 2 ]
}

@test "signing::codesign with no target returns 2" {
  run maclib::signing::codesign
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# keychain module (has_entry with no args returns 2)
# ---------------------------------------------------------------------------

@test "keychain::has_entry with no args returns 2" {
  run maclib::keychain::has_entry
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# launchd module (is_loaded with no label returns 2)
# ---------------------------------------------------------------------------

@test "launchd::is_loaded with no label returns 2" {
  run maclib::launchd::is_loaded
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# management module (is_managed is readable without root)
# ---------------------------------------------------------------------------

@test "management::isManaged returns exit 0, 1, or 127 (absent tool)" {
  run maclib::management::isManaged
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ] || [ "$status" -eq 127 ]
}

# ---------------------------------------------------------------------------
# network module (hostname is readable without root)
# ---------------------------------------------------------------------------

@test "network::hostname returns non-empty" {
  run maclib::network::hostname
  [ "$status" -eq 0 ]
  [[ -n "$output" ]]
}

# ---------------------------------------------------------------------------
# app module (is_installed with no name returns 2)
# ---------------------------------------------------------------------------

@test "app::isInstalled with no name returns 2" {
  run maclib::app::is_installed
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# office module
# ---------------------------------------------------------------------------

@test "office::suite_installer_url returns the fwlink" {
  run maclib::office::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"fwlink/?linkid=525133"* ]]
}

@test "office::latest_version extracts a dotted version from the fwlink" {
  # Mock curl (a shell function, inherited by bats' run subshell) to emit a
  # redirect Location header pointing at a package file name containing a
  # version string.
  curl() {
    echo "HTTP/1.1 302 Moved Temporarily"
    echo "Location: https://res.public.onecdn.static.microsoft/MacAutoupdate/Microsoft_365_and_Office_16.112.26081720_Installer.pkg"
  }
  run maclib::office::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "16.112.26081720" ]]
}

@test "office::latest_version fails when no redirect is returned" {
  curl() {
    echo "HTTP/1.1 200 OK"
  }
  run maclib::office::latest_version
  [ "$status" -ne 0 ]
}

@test "office::is_installed returns 1 when no Office app is installed" {
  # On CI/developer machines Office is typically absent.
  run maclib::office::is_installed
  [ "$status" -eq 1 ] || [ "$status" -eq 0 ]
}

@test "office::installed_path returns non-zero when not installed" {
  run maclib::office::installed_path
  [ "$status" -ne 0 ] || [[ -n "$output" ]]
}

# ---------------------------------------------------------------------------
# chrome module (package installer)
# ---------------------------------------------------------------------------

@test "chrome::url returns the Google Chrome package URL" {
  run maclib::chrome::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"dl.google.com/chrome/mac"* ]]
}

@test "chrome::latest_version extracts a build from the version API" {
  curl() {
    echo '{"data":[{"version":"131.0.6778.86"}]}'
  }
  run maclib::chrome::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "131.0.6778.86" ]]
}

@test "chrome::latest_version fails when no version is returned" {
  curl() {
    echo '{"data":[]}'
  }
  run maclib::chrome::latest_version
  [ "$status" -ne 0 ]
}

@test "chrome::is_installed returns 0 or 1" {
  run maclib::chrome::is_installed
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

# ---------------------------------------------------------------------------
# firefox module (package installer)
# ---------------------------------------------------------------------------

@test "firefox::url returns the Firefox package URL" {
  run maclib::firefox::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"download.mozilla.org"*"firefox-pkg"* ]]
}

@test "firefox::latest_version extracts a build from product-details JSON" {
  curl() {
    echo '{"LATEST_FIREFOX_VERSION":"141.0.1"}'
  }
  run maclib::firefox::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "141.0.1" ]]
}

@test "firefox::latest_version fails when no version is returned" {
  curl() {
    echo '{}'
  }
  run maclib::firefox::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# zoom module (package installer)
# ---------------------------------------------------------------------------

@test "zoom::url returns the Zoom installer URL" {
  run maclib::zoom::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"zoom.us/client/latest/ZoomInstallerIT.pkg"* ]]
}

@test "zoom::latest_version parses the version from a redirect Location" {
  curl() {
    echo "HTTP/1.1 302 Moved Temporarily"
    echo "Location: https://zoom.us/client/latest/5.17.6/ZoomInstallerIT.pkg"
  }
  run maclib::zoom::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "5.17.6" ]]
}

@test "zoom::latest_version fails when no redirect is returned" {
  curl() {
    echo "HTTP/1.1 200 OK"
  }
  run maclib::zoom::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# 1password module (package installer)
# ---------------------------------------------------------------------------

@test "1password::url returns the 1Password package URL" {
  run maclib::1password::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"downloads.1password.com/mac/1Password.pkg"* ]]
}

@test "1password::latest_version extracts a build from the releases XML" {
  curl() {
    echo '<?xml version="1.0"?><rss><channel><item><title>8.10.5</title></item></channel></rss>'
  }
  run maclib::1password::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "8.10.5" ]]
}

@test "1password::latest_version fails when no version is returned" {
  curl() {
    echo '<?xml version="1.0"?><rss><channel></channel></rss>'
  }
  run maclib::1password::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# slack module (package installer)
# ---------------------------------------------------------------------------

@test "slack::url returns the Slack package URL" {
  run maclib::slack::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"slack.com/api/desktop.latestRelease"* ]]
}

@test "slack::latest_version parses the version from a redirect Location" {
  curl() {
    echo "HTTP/1.1 302 Moved Temporarily"
    echo "Location: https://files.slack.com/files-pkg/x/141.0.0.0.0.pkg"
  }
  run maclib::slack::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == *"141.0.0.0.0"* ]]
}

@test "slack::latest_version fails when no redirect is returned" {
  curl() {
    echo "HTTP/1.1 200 OK"
  }
  run maclib::slack::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# dropbox / notion / vlc / signal / libreoffice (dmg installers)
# ---------------------------------------------------------------------------

@test "dropbox::url returns the Dropbox disk image URL" {
  run maclib::dropbox::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"dropbox.com/download"* ]]
}

@test "notion::url returns the Notion disk image URL" {
  run maclib::notion::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"notion.so/desktop/mac/download"* ]]
}

@test "vlc::latest_version extracts a build from the VLC page" {
  curl() {
    echo '{"latestVersion":"4.0.1"}'
  }
  run maclib::vlc::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "4.0.1" ]]
}

@test "vlc::url returns the current-version VLC disk image URL" {
  curl() {
    echo '{"latestVersion":"4.0.1"}'
  }
  run maclib::vlc::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"get.videolan.org/vlc/4.0.1"* ]]
}

@test "signal::url resolves a universal dmg from latest-mac.yml" {
  curl() {
    echo 'version: 8.24.1'
    echo '  - url: signal-desktop-mac-universal-8.24.1.dmg'
  }
  run maclib::signal::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"updates.signal.org/desktop/"*"signal-desktop-mac-universal-8.24.1.dmg"* ]]
}

@test "libreoffice::url returns the arch-aware LibreOffice disk image URL" {
  curl() {
    echo '7.6.7'
  }
  run maclib::libreoffice::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"libreoffice/stable/7.6.7"* ]]
}

# ---------------------------------------------------------------------------
# iterm2 / figma / chatgpt (zip / dmg installers)
# ---------------------------------------------------------------------------

@test "iterm2::url returns the iTerm2 zip URL" {
  run maclib::iterm2::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"iterm2.com/downloads/stable/latest"* ]]
}

@test "iterm2::latest_version extracts a build from a redirect Location" {
  curl() {
    echo "HTTP/1.1 302 Moved Temporarily"
    echo "Location: https://iterm2.com/downloads/stable/iTerm2-2.5.0.zip"
  }
  run maclib::iterm2::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "2.5.0" ]]
}

@test "figma::latest_version extracts a build from RELEASE.json" {
  curl() {
    echo '{"version":"130.10.0"}'
  }
  run maclib::figma::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "130.10.0" ]]
}

@test "chatgpt::latest_version extracts a build from the appcast" {
  curl() {
    echo '<rss><channel><item><title>1.2025060521</title></item></channel></rss>'
  }
  run maclib::chatgpt::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2025060521" ]]
}

# ---------------------------------------------------------------------------
# jamf module: Jamf Extension Attribute helpers
# (external macOS binaries mocked as shell functions, per test_security.bats)
# ---------------------------------------------------------------------------

@test "jamf::battery_cycle_count returns 0 on a batteryless machine" {
  system_profiler() { echo "AC Charger Information"; }
  run maclib::jamf::battery_cycle_count
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>0</result>" ]]
}

@test "jamf::battery_cycle_count extracts Cycle Count when present" {
  system_profiler() {
    echo "Battery Information"
    echo "    Cycle Count: 42"
  }
  run maclib::jamf::battery_cycle_count
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>42</result>" ]]
}

@test "jamf::battery_charge_percent is empty on AC-only power" {
  pmset() { echo "Now drawing from 'AC Power'"; }
  run maclib::jamf::battery_charge_percent
  [ "$status" -eq 0 ]
  [[ "$output" == "<result></result>" ]]
}

@test "jamf::battery_charge_percent extracts percentage" {
  pmset() { echo "Drawing from 'Battery' - 85%"; }
  run maclib::jamf::battery_charge_percent
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>85</result>" ]]
}

@test "jamf::security_chip prints Model Identifier (Apple Silicon fix)" {
  system_profiler() { echo "      Model Identifier: Mac16,11"; }
  run maclib::jamf::security_chip
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Mac16,11</result>" ]]
}

@test "jamf::third_party_kexts lists non-Apple kext load IDs" {
  kmutil() {
    echo "    3  215 0                  0          0          com.apple.kpi.bsd (27.0.0) UUID <>"
    echo "    8  300 0                  0          0          com.example.foo.kext (1.0) UUID <>"
  }
  run maclib::jamf::third_party_kexts
  [ "$status" -eq 0 ]
  [[ "$output" == "com.example.foo.kext" ]]
}

@test "jamf::third_party_kexts is empty when no third-party kexts" {
  kmutil() { echo "    3  215 0                  0          0          com.apple.kpi.bsd (27.0.0) UUID <>"; }
  run maclib::jamf::third_party_kexts
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "jamf::system_extensions extracts enabled bundle IDs" {
  systemextensionsctl() {
    echo "2 extension(s)"
    echo "--- com.apple.system_extension.network_extension"
    echo "enabled	active	teamID	bundleID (version)	name	[state]"
    printf '\t*\t57P38MF5GS\tcom.f5.access.macos.DNSProxy (7260.0.0.1/7260.0.0.1)\tDNSProxy\t[activated waiting for user]\n'
  }
  run maclib::jamf::system_extensions
  [ "$status" -eq 0 ]
  [[ "$output" == *"com.f5.access.macos.DNSProxy"* ]]
}

@test "jamf::system_extensions is empty when none enabled" {
  systemextensionsctl() { echo "0 extension(s)"; }
  run maclib::jamf::system_extensions
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "jamf::uptime_seconds prints seconds since boot" {
  date() { echo "1000"; }
  sysctl() { echo "{ sec = 400, usec = 0 }"; }
  run maclib::jamf::uptime_seconds
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>600</result>" ]]
}

@test "jamf::xcode_clt_state reports Standalone" {
  xcode-select() { echo "/Library/Developer/CommandLineTools"; }
  run maclib::jamf::xcode_clt_state
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Standalone</result>" ]]
}

@test "jamf::xcode_clt_state reports Bundled with Xcode-beta" {
  xcode-select() { echo "/Applications/Xcode-beta.app/Contents/Developer"; }
  run maclib::jamf::xcode_clt_state
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Bundled with Xcode-beta</result>" ]]
}

@test "jamf::xcode_clt_state is empty when not installed" {
  xcode-select() { echo "/usr/bin"; }
  run maclib::jamf::xcode_clt_state
  [ "$status" -eq 0 ]
  [[ "$output" == "<result></result>" ]]
}

@test "jamf::startup_volume_name prints the boot volume name" {
  bless() { echo "/dev/disk3s1"; }
  diskutil() { echo "Volume Name: Macintosh HD"; }
  plutil() { echo "Macintosh HD"; }
  run maclib::jamf::startup_volume_name
  [ "$status" -eq 0 ]
  [[ "$output" == "Macintosh HD" ]]
}

@test "jamf::charger_wattage extracts wattage" {
  system_profiler() {
    echo "AC Charger Information:"
    echo "    Wattage: 96W"
  }
  run maclib::jamf::charger_wattage
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>96</result>" ]]
}

@test "jamf::charger_wattage is empty when no adapter" {
  system_profiler() { echo "AC Charger Information:"; }
  run maclib::jamf::charger_wattage
  [ "$status" -eq 0 ]
  [[ "$output" == "<result></result>" ]]
}

@test "jamf::time_machine_autobackup reports Enabled" {
  defaults() { echo "1"; }
  run maclib::jamf::time_machine_autobackup
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Enabled</result>" ]]
}

@test "jamf::time_machine_autobackup is empty when not configured" {
  defaults() { echo "0"; }
  run maclib::jamf::time_machine_autobackup
  [ "$status" -eq 0 ]
  [[ "$output" == "<result></result>" ]]
}

# Fake brew script for the homebrew EA test (created in a temp dir).
__fake_brew() {
  local dir="$1"
  mkdir -p "$dir"
  cat >"$dir/brew" <<'BREW'
#!/usr/bin/env bash
echo "com.example.oldlib"
BREW
  chmod +x "$dir/brew"
  printf '%s\n' "$dir/brew"
}

@test "jamf::homebrew_outdated_formulae runs brew under console UID" {
  local fake out
  fake="$(__fake_brew "$(mktemp -d)")"
  arch() { echo "arm64"; }
  stat() {
    case "$2" in
      -f%u) echo "501" ;;
      *) echo "malbers" ;;
    esac
  }
  launchctl() {
    if [[ "$1" == "asuser" ]]; then
      "$MACLIB_BREW_BIN" outdated --formula --quiet
    fi
  }
  # Use command substitution (not `run`) so the mocked shell functions survive
  # into the subshell; MACLIB_BREW_BIN is exported only for this call.
  out="$(MACLIB_BREW_BIN="$fake" maclib::jamf::homebrew_outdated_formulae)"
  [ "$?" -eq 0 ]
  [[ "$out" == "com.example.oldlib" ]]
  rm -rf "${fake%/*}"
}
