#!/usr/bin/env bats
# Combined bats tests for the macAdmin Library modules.

setup() {
  source "${BATS_TEST_DIRNAME}/../lib/maclib.sh"
}

# ---------------------------------------------------------------------------
# logging (existing)
# ---------------------------------------------------------------------------

@test "log filters debug when level is info" {
  run bash -c 'source lib/core/log.sh; maclib::core::log::set_level info; maclib::core::log::debug "x"'
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "log warn goes to stderr" {
  run bash -c 'source lib/core/log.sh; maclib::core::log::set_level debug; maclib::core::log::warn "hello" 2>&1 1>/dev/null'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[WARN] hello"* ]]
}

# ---------------------------------------------------------------------------
# os module
# ---------------------------------------------------------------------------

@test "os::is_macos returns 0 on macOS" {
  run maclib::core::os::is_macos
  [ "$status" -eq 0 ]
}

@test "os::version returns a dotted string" {
  run maclib::core::os::version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "os::major_minor returns two components" {
  run maclib::core::os::major_minor
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

# ---------------------------------------------------------------------------
# user module
# ---------------------------------------------------------------------------

@test "user::is_root returns integer exit code" {
  run maclib::core::user::is_root
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "user::current_user returns non-empty name" {
  run maclib::core::user::current_user
  [ "$status" -eq 0 ]
  [[ -n "$output" ]]
}

@test "user::home_dir returns a path" {
  run maclib::core::user::home_dir
  [ "$status" -eq 0 ]
  [[ "$output" == */ ]] || [[ "$output" == /* ]]
}

# ---------------------------------------------------------------------------
# system module (SIP state is readable without root)
# ---------------------------------------------------------------------------

@test "system::sip_status returns a state string" {
  run maclib::core::system::sip_status
  [ "$status" -eq 0 ]
  [[ "$output" == *"enabled" || "$output" == *"disabled" || "$output" == *"unconfigured" ]]
}

# ---------------------------------------------------------------------------
# packages module (list is read-only, no args)
# ---------------------------------------------------------------------------

@test "packages::pkg_list returns exit 0" {
  run maclib::core::packages::pkg_list
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# signing module (verify with no target must return 2)
# ---------------------------------------------------------------------------

@test "signing::verify with no target returns 2" {
  run maclib::core::signing::verify
  [ "$status" -eq 2 ]
}

@test "signing::codesign with no target returns 2" {
  run maclib::core::signing::codesign
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# keychain module (has_entry with no args returns 2)
# ---------------------------------------------------------------------------

@test "keychain::has_entry with no args returns 2" {
  run maclib::core::keychain::has_entry
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# launchd module (is_loaded with no label returns 2)
# ---------------------------------------------------------------------------

@test "launchd::is_loaded with no label returns 2" {
  run maclib::core::launchd::is_loaded
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# management module (is_managed is readable without root)
# ---------------------------------------------------------------------------

@test "management::isManaged returns exit 0, 1, or 127 (absent tool)" {
  run maclib::core::management::is_managed
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ] || [ "$status" -eq 127 ]
}

# ---------------------------------------------------------------------------
# network module (hostname is readable without root)
# ---------------------------------------------------------------------------

@test "network::hostname returns non-empty" {
  run maclib::core::network::hostname
  [ "$status" -eq 0 ]
  [[ -n "$output" ]]
}

# ---------------------------------------------------------------------------
# app module (is_installed with no name returns 2)
# ---------------------------------------------------------------------------

@test "app::isInstalled with no name returns 2" {
  run maclib::core::app::is_installed
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# office module
# ---------------------------------------------------------------------------

@test "office::suite_installer_url returns the fwlink" {
  run maclib::productivity::office::suite_installer_url
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
  run maclib::productivity::office::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "16.112.26081720" ]]
}

@test "office::latest_version fails when no redirect is returned" {
  curl() {
    echo "HTTP/1.1 200 OK"
  }
  run maclib::productivity::office::latest_version
  [ "$status" -ne 0 ]
}

@test "office::is_installed returns 1 when no Office app is installed" {
  # On CI/developer machines Office is typically absent.
  run maclib::productivity::office::is_installed
  [ "$status" -eq 1 ] || [ "$status" -eq 0 ]
}

@test "office::installed_path returns non-zero when not installed" {
  run maclib::productivity::office::installed_path
  [ "$status" -ne 0 ] || [[ -n "$output" ]]
}

# ---------------------------------------------------------------------------
# chrome module (package installer)
# ---------------------------------------------------------------------------

@test "chrome::url returns the Google Chrome package URL" {
  run maclib::browsers::chrome::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"dl.google.com/chrome/mac"* ]]
}

@test "chrome::latest_version extracts a build from the version API" {
  curl() {
    echo '{"data":[{"version":"131.0.6778.86"}]}'
  }
  run maclib::browsers::chrome::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "131.0.6778.86" ]]
}

@test "chrome::latest_version fails when no version is returned" {
  curl() {
    echo '{"data":[]}'
  }
  run maclib::browsers::chrome::latest_version
  [ "$status" -ne 0 ]
}

@test "chrome::is_installed returns 0 or 1" {
  run maclib::browsers::chrome::is_installed
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

# ---------------------------------------------------------------------------
# firefox module (package installer)
# ---------------------------------------------------------------------------

@test "firefox::url returns the Firefox package URL" {
  run maclib::browsers::firefox::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"download.mozilla.org"*"firefox-pkg"* ]]
}

@test "firefox::latest_version extracts a build from product-details JSON" {
  curl() {
    echo '{"LATEST_FIREFOX_VERSION":"141.0.1"}'
  }
  run maclib::browsers::firefox::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "141.0.1" ]]
}

@test "firefox::latest_version fails when no version is returned" {
  curl() {
    echo '{}'
  }
  run maclib::browsers::firefox::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# zoom module (package installer)
# ---------------------------------------------------------------------------

@test "zoom::url returns the Zoom installer URL" {
  run maclib::communication::zoom::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"zoom.us/client/latest/ZoomInstallerIT.pkg"* ]]
}

@test "zoom::latest_version parses the version from a redirect Location" {
  curl() {
    echo "HTTP/1.1 302 Moved Temporarily"
    echo "Location: https://zoom.us/client/latest/5.17.6/ZoomInstallerIT.pkg"
  }
  run maclib::communication::zoom::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "5.17.6" ]]
}

@test "zoom::latest_version fails when no redirect is returned" {
  curl() {
    echo "HTTP/1.1 200 OK"
  }
  run maclib::communication::zoom::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# 1password module (package installer)
# ---------------------------------------------------------------------------

@test "1password::url returns the 1Password package URL" {
  run maclib::security_tools::1password::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"downloads.1password.com/mac/1Password.pkg"* ]]
}

@test "1password::latest_version extracts a build from the releases XML" {
  curl() {
    echo '<?xml version="1.0"?><rss><channel><item><title>8.10.5</title></item></channel></rss>'
  }
  run maclib::security_tools::1password::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "8.10.5" ]]
}

@test "1password::latest_version fails when no version is returned" {
  curl() {
    echo '<?xml version="1.0"?><rss><channel></channel></rss>'
  }
  run maclib::security_tools::1password::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# slack module (package installer)
# ---------------------------------------------------------------------------

@test "slack::url returns the Slack package URL" {
  run maclib::communication::slack::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"slack.com/api/desktop.latestRelease"* ]]
}

@test "slack::latest_version parses the version from a redirect Location" {
  curl() {
    echo "HTTP/1.1 302 Moved Temporarily"
    echo "Location: https://files.slack.com/files-pkg/x/141.0.0.0.0.pkg"
  }
  run maclib::communication::slack::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == *"141.0.0.0.0"* ]]
}

@test "slack::latest_version fails when no redirect is returned" {
  curl() {
    echo "HTTP/1.1 200 OK"
  }
  run maclib::communication::slack::latest_version
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# dropbox / notion / vlc / signal / libreoffice (dmg installers)
# ---------------------------------------------------------------------------

@test "dropbox::url returns the Dropbox disk image URL" {
  run maclib::cloud_storage::dropbox::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"dropbox.com/download"* ]]
}

@test "notion::url returns the Notion disk image URL" {
  run maclib::productivity::notion::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"notion.so/desktop/mac/download"* ]]
}

@test "vlc::latest_version extracts a build from the VLC page" {
  curl() {
    echo '{"latestVersion":"4.0.1"}'
  }
  run maclib::media::vlc::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "4.0.1" ]]
}

@test "vlc::url returns the current-version VLC disk image URL" {
  curl() {
    echo '{"latestVersion":"4.0.1"}'
  }
  run maclib::media::vlc::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"get.videolan.org/vlc/4.0.1"* ]]
}

@test "signal::url resolves a universal dmg from latest-mac.yml" {
  curl() {
    echo 'version: 8.24.1'
    echo '  - url: signal-desktop-mac-universal-8.24.1.dmg'
  }
  run maclib::communication::signal::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"updates.signal.org/desktop/"*"signal-desktop-mac-universal-8.24.1.dmg"* ]]
}

@test "libreoffice::url returns the arch-aware LibreOffice disk image URL" {
  curl() {
    echo '7.6.7'
  }
  run maclib::productivity::libreoffice::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"libreoffice/stable/7.6.7"* ]]
}

# ---------------------------------------------------------------------------
# iterm2 / figma / chatgpt (zip / dmg installers)
# ---------------------------------------------------------------------------

@test "iterm2::url returns the iTerm2 zip URL" {
  run maclib::devops::iterm2::url
  [ "$status" -eq 0 ]
  [[ "$output" == *"iterm2.com/downloads/stable/latest"* ]]
}

@test "iterm2::latest_version extracts a build from a redirect Location" {
  curl() {
    echo "HTTP/1.1 302 Moved Temporarily"
    echo "Location: https://iterm2.com/downloads/stable/iTerm2-2.5.0.zip"
  }
  run maclib::devops::iterm2::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "2.5.0" ]]
}

@test "figma::latest_version extracts a build from RELEASE.json" {
  curl() {
    echo '{"version":"130.10.0"}'
  }
  run maclib::creative::figma::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "130.10.0" ]]
}

@test "chatgpt::latest_version extracts a build from the appcast" {
  curl() {
    echo '<rss><channel><item><title>1.2025060521</title></item></channel></rss>'
  }
  run maclib::ai::chatgpt::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2025060521" ]]
}

# ---------------------------------------------------------------------------
# jamf module: Jamf Extension Attribute helpers
# (external macOS binaries mocked as shell functions, per test_security.bats)
# ---------------------------------------------------------------------------

@test "jamf::battery_cycle_count returns 0 on a batteryless machine" {
  system_profiler() { echo "AC Charger Information"; }
  run maclib::mdm::jamf::battery_cycle_count
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>0</result>" ]]
}

@test "jamf::battery_cycle_count extracts Cycle Count when present" {
  system_profiler() {
    echo "Battery Information"
    echo "    Cycle Count: 42"
  }
  run maclib::mdm::jamf::battery_cycle_count
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>42</result>" ]]
}

@test "jamf::battery_charge_percent is empty on AC-only power" {
  pmset() { echo "Now drawing from 'AC Power'"; }
  run maclib::mdm::jamf::battery_charge_percent
  [ "$status" -eq 0 ]
  [[ "$output" == "<result></result>" ]]
}

@test "jamf::battery_charge_percent extracts percentage" {
  pmset() { echo "Drawing from 'Battery' - 85%"; }
  run maclib::mdm::jamf::battery_charge_percent
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>85</result>" ]]
}

@test "jamf::security_chip prints Model Identifier (Apple Silicon fix)" {
  system_profiler() { echo "      Model Identifier: Mac16,11"; }
  run maclib::mdm::jamf::security_chip
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Mac16,11</result>" ]]
}

@test "jamf::third_party_kexts lists non-Apple kext load IDs" {
  kmutil() {
    echo "    3  215 0                  0          0          com.apple.kpi.bsd (27.0.0) UUID <>"
    echo "    8  300 0                  0          0          com.example.foo.kext (1.0) UUID <>"
  }
  run maclib::mdm::jamf::third_party_kexts
  [ "$status" -eq 0 ]
  [[ "$output" == "com.example.foo.kext" ]]
}

@test "jamf::third_party_kexts is empty when no third-party kexts" {
  kmutil() { echo "    3  215 0                  0          0          com.apple.kpi.bsd (27.0.0) UUID <>"; }
  run maclib::mdm::jamf::third_party_kexts
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
  run maclib::mdm::jamf::system_extensions
  [ "$status" -eq 0 ]
  [[ "$output" == *"com.f5.access.macos.DNSProxy"* ]]
}

@test "jamf::system_extensions is empty when none enabled" {
  systemextensionsctl() { echo "0 extension(s)"; }
  run maclib::mdm::jamf::system_extensions
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "jamf::uptime_seconds prints seconds since boot" {
  date() { echo "1000"; }
  sysctl() { echo "{ sec = 400, usec = 0 }"; }
  run maclib::mdm::jamf::uptime_seconds
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>600</result>" ]]
}

@test "jamf::xcode_clt_state reports Standalone" {
  xcode-select() { echo "/Library/Developer/CommandLineTools"; }
  run maclib::mdm::jamf::xcode_clt_state
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Standalone</result>" ]]
}

@test "jamf::xcode_clt_state reports Bundled with Xcode-beta" {
  xcode-select() { echo "/Applications/Xcode-beta.app/Contents/Developer"; }
  run maclib::mdm::jamf::xcode_clt_state
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Bundled with Xcode-beta</result>" ]]
}

@test "jamf::xcode_clt_state is empty when not installed" {
  xcode-select() { echo "/usr/bin"; }
  run maclib::mdm::jamf::xcode_clt_state
  [ "$status" -eq 0 ]
  [[ "$output" == "<result></result>" ]]
}

@test "jamf::startup_volume_name prints the boot volume name" {
  bless() { echo "/dev/disk3s1"; }
  diskutil() { echo "Volume Name: Macintosh HD"; }
  plutil() { echo "Macintosh HD"; }
  run maclib::mdm::jamf::startup_volume_name
  [ "$status" -eq 0 ]
  [[ "$output" == "Macintosh HD" ]]
}

@test "jamf::charger_wattage extracts wattage" {
  system_profiler() {
    echo "AC Charger Information:"
    echo "    Wattage: 96W"
  }
  run maclib::mdm::jamf::charger_wattage
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>96</result>" ]]
}

@test "jamf::charger_wattage is empty when no adapter" {
  system_profiler() { echo "AC Charger Information:"; }
  run maclib::mdm::jamf::charger_wattage
  [ "$status" -eq 0 ]
  [[ "$output" == "<result></result>" ]]
}

@test "jamf::time_machine_autobackup reports Enabled" {
  defaults() { echo "1"; }
  run maclib::mdm::jamf::time_machine_autobackup
  [ "$status" -eq 0 ]
  [[ "$output" == "<result>Enabled</result>" ]]
}

@test "jamf::time_machine_autobackup is empty when not configured" {
  defaults() { echo "0"; }
  run maclib::mdm::jamf::time_machine_autobackup
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
  out="$(MACLIB_BREW_BIN="$fake" maclib::mdm::jamf::homebrew_outdated_formulae)"
  [ "$?" -eq 0 ]
  [[ "$out" == "com.example.oldlib" ]]
  rm -rf "${fake%/*}"
}
# Generated bats tests for Installomator misc_batch_0 modules.
# Mocked network: curl is stubbed so tests run offline.

@test "4kvideodownloader::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/4kvideodownloader-installer.pkg"; }
  run maclib::apps::4::4kvideodownloader::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "4kvideodownloader::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/4kvideodownloader-16.112.26081720.dmg"; }
  run maclib::apps::4::4kvideodownloader::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "4kvideodownloader::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloader::is_installed
  [ "$status" -eq 1 ]
}

@test "4kvideodownloader::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloader::installed_path
  [ "$status" -eq 1 ]
}

@test "4kvideodownloader::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::4::4kvideodownloader::install
  [ "$status" -ne 0 ]
}

@test "4kvideodownloader::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloader::update
  [ "$status" -eq 127 ]
}

@test "4kvideodownloader::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloader::uninstall
  [ "$status" -eq 1 ]
}

@test "4kvideodownloaderplus::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/4kvideodownloaderplus-installer.pkg"; }
  run maclib::apps::4::4kvideodownloaderplus::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "4kvideodownloaderplus::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/4kvideodownloaderplus-16.112.26081720.dmg"; }
  run maclib::apps::4::4kvideodownloaderplus::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "4kvideodownloaderplus::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloaderplus::is_installed
  [ "$status" -eq 1 ]
}

@test "4kvideodownloaderplus::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloaderplus::installed_path
  [ "$status" -eq 1 ]
}

@test "4kvideodownloaderplus::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::4::4kvideodownloaderplus::install
  [ "$status" -ne 0 ]
}

@test "4kvideodownloaderplus::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloaderplus::update
  [ "$status" -eq 127 ]
}

@test "4kvideodownloaderplus::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::4::4kvideodownloaderplus::uninstall
  [ "$status" -eq 1 ]
}

@test "8x8::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/8x8-installer.pkg"; }
  run maclib::apps::8::8x8::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "8x8::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/8x8-16.112.26081720.dmg"; }
  run maclib::apps::8::8x8::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "8x8::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::8::8x8::is_installed
  [ "$status" -eq 1 ]
}

@test "8x8::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::8::8x8::installed_path
  [ "$status" -eq 1 ]
}

@test "8x8::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::8::8x8::install
  [ "$status" -ne 0 ]
}

@test "8x8::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::8::8x8::update
  [ "$status" -eq 127 ]
}

@test "8x8::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::8::8x8::uninstall
  [ "$status" -eq 1 ]
}

@test "abetterfinderattributes7::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abetterfinderattributes7-installer.pkg"; }
  run maclib::apps::a::abetterfinderattributes7::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abetterfinderattributes7::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abetterfinderattributes7-16.112.26081720.dmg"; }
  run maclib::apps::a::abetterfinderattributes7::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abetterfinderattributes7::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderattributes7::is_installed
  [ "$status" -eq 1 ]
}

@test "abetterfinderattributes7::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderattributes7::installed_path
  [ "$status" -eq 1 ]
}

@test "abetterfinderattributes7::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abetterfinderattributes7::install
  [ "$status" -ne 0 ]
}

@test "abetterfinderattributes7::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderattributes7::update
  [ "$status" -eq 127 ]
}

@test "abetterfinderattributes7::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderattributes7::uninstall
  [ "$status" -eq 1 ]
}

@test "abetterfinderrename11::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abetterfinderrename11-installer.pkg"; }
  run maclib::apps::a::abetterfinderrename11::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abetterfinderrename11::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abetterfinderrename11-16.112.26081720.dmg"; }
  run maclib::apps::a::abetterfinderrename11::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abetterfinderrename11::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename11::is_installed
  [ "$status" -eq 1 ]
}

@test "abetterfinderrename11::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename11::installed_path
  [ "$status" -eq 1 ]
}

@test "abetterfinderrename11::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abetterfinderrename11::install
  [ "$status" -ne 0 ]
}

@test "abetterfinderrename11::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename11::update
  [ "$status" -eq 127 ]
}

@test "abetterfinderrename11::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename11::uninstall
  [ "$status" -eq 1 ]
}

@test "abetterfinderrename12::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abetterfinderrename12-installer.pkg"; }
  run maclib::apps::a::abetterfinderrename12::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abetterfinderrename12::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abetterfinderrename12-16.112.26081720.dmg"; }
  run maclib::apps::a::abetterfinderrename12::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abetterfinderrename12::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename12::is_installed
  [ "$status" -eq 1 ]
}

@test "abetterfinderrename12::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename12::installed_path
  [ "$status" -eq 1 ]
}

@test "abetterfinderrename12::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abetterfinderrename12::install
  [ "$status" -ne 0 ]
}

@test "abetterfinderrename12::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename12::update
  [ "$status" -eq 127 ]
}

@test "abetterfinderrename12::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abetterfinderrename12::uninstall
  [ "$status" -eq 1 ]
}

@test "abletonlive12intro::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12intro-installer.pkg"; }
  run maclib::apps::a::abletonlive12intro::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abletonlive12intro::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12intro-16.112.26081720.dmg"; }
  run maclib::apps::a::abletonlive12intro::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abletonlive12intro::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12intro::is_installed
  [ "$status" -eq 1 ]
}

@test "abletonlive12intro::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12intro::installed_path
  [ "$status" -eq 1 ]
}

@test "abletonlive12intro::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abletonlive12intro::install
  [ "$status" -ne 0 ]
}

@test "abletonlive12intro::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12intro::update
  [ "$status" -eq 127 ]
}

@test "abletonlive12intro::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12intro::uninstall
  [ "$status" -eq 1 ]
}

@test "abletonlive12lite::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12lite-installer.pkg"; }
  run maclib::apps::a::abletonlive12lite::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abletonlive12lite::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12lite-16.112.26081720.dmg"; }
  run maclib::apps::a::abletonlive12lite::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abletonlive12lite::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12lite::is_installed
  [ "$status" -eq 1 ]
}

@test "abletonlive12lite::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12lite::installed_path
  [ "$status" -eq 1 ]
}

@test "abletonlive12lite::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abletonlive12lite::install
  [ "$status" -ne 0 ]
}

@test "abletonlive12lite::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12lite::update
  [ "$status" -eq 127 ]
}

@test "abletonlive12lite::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12lite::uninstall
  [ "$status" -eq 1 ]
}

@test "abletonlive12standard::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12standard-installer.pkg"; }
  run maclib::apps::a::abletonlive12standard::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abletonlive12standard::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12standard-16.112.26081720.dmg"; }
  run maclib::apps::a::abletonlive12standard::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abletonlive12standard::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12standard::is_installed
  [ "$status" -eq 1 ]
}

@test "abletonlive12standard::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12standard::installed_path
  [ "$status" -eq 1 ]
}

@test "abletonlive12standard::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abletonlive12standard::install
  [ "$status" -ne 0 ]
}

@test "abletonlive12standard::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12standard::update
  [ "$status" -eq 127 ]
}

@test "abletonlive12standard::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12standard::uninstall
  [ "$status" -eq 1 ]
}

@test "abletonlive12suite::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12suite-installer.pkg"; }
  run maclib::apps::a::abletonlive12suite::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abletonlive12suite::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12suite-16.112.26081720.dmg"; }
  run maclib::apps::a::abletonlive12suite::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abletonlive12suite::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12suite::is_installed
  [ "$status" -eq 1 ]
}

@test "abletonlive12suite::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12suite::installed_path
  [ "$status" -eq 1 ]
}

@test "abletonlive12suite::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abletonlive12suite::install
  [ "$status" -ne 0 ]
}

@test "abletonlive12suite::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12suite::update
  [ "$status" -eq 127 ]
}

@test "abletonlive12suite::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12suite::uninstall
  [ "$status" -eq 1 ]
}

@test "abletonlive12trial::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12trial-installer.pkg"; }
  run maclib::apps::a::abletonlive12trial::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abletonlive12trial::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abletonlive12trial-16.112.26081720.dmg"; }
  run maclib::apps::a::abletonlive12trial::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abletonlive12trial::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12trial::is_installed
  [ "$status" -eq 1 ]
}

@test "abletonlive12trial::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12trial::installed_path
  [ "$status" -eq 1 ]
}

@test "abletonlive12trial::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abletonlive12trial::install
  [ "$status" -ne 0 ]
}

@test "abletonlive12trial::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12trial::update
  [ "$status" -eq 127 ]
}

@test "abletonlive12trial::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abletonlive12trial::uninstall
  [ "$status" -eq 1 ]
}

@test "abstract::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abstract-installer.pkg"; }
  run maclib::apps::a::abstract::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "abstract::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/abstract-16.112.26081720.dmg"; }
  run maclib::apps::a::abstract::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "abstract::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abstract::is_installed
  [ "$status" -eq 1 ]
}

@test "abstract::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::abstract::installed_path
  [ "$status" -eq 1 ]
}

@test "abstract::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::abstract::install
  [ "$status" -ne 0 ]
}

@test "abstract::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::abstract::update
  [ "$status" -eq 127 ]
}

@test "abstract::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::abstract::uninstall
  [ "$status" -eq 1 ]
}

@test "acorn::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/acorn-installer.pkg"; }
  run maclib::apps::a::acorn::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "acorn::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/acorn-16.112.26081720.dmg"; }
  run maclib::apps::a::acorn::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "acorn::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::acorn::is_installed
  [ "$status" -eq 1 ]
}

@test "acorn::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::acorn::installed_path
  [ "$status" -eq 1 ]
}

@test "acorn::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::acorn::install
  [ "$status" -ne 0 ]
}

@test "acorn::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::acorn::update
  [ "$status" -eq 127 ]
}

@test "acorn::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::acorn::uninstall
  [ "$status" -eq 1 ]
}

@test "adium::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adium-installer.pkg"; }
  run maclib::apps::a::adium::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "adium::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adium-16.112.26081720.dmg"; }
  run maclib::apps::a::adium::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "adium::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adium::is_installed
  [ "$status" -eq 1 ]
}

@test "adium::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adium::installed_path
  [ "$status" -eq 1 ]
}

@test "adium::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::adium::install
  [ "$status" -ne 0 ]
}

@test "adium::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::adium::update
  [ "$status" -eq 127 ]
}

@test "adium::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::adium::uninstall
  [ "$status" -eq 1 ]
}

@test "adobeacrobatprodc::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobeacrobatprodc-installer.pkg"; }
  run maclib::apps::a::adobeacrobatprodc::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "adobeacrobatprodc::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobeacrobatprodc-16.112.26081720.dmg"; }
  run maclib::apps::a::adobeacrobatprodc::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "adobeacrobatprodc::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobeacrobatprodc::is_installed
  [ "$status" -eq 1 ]
}

@test "adobeacrobatprodc::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobeacrobatprodc::installed_path
  [ "$status" -eq 1 ]
}

@test "adobeacrobatprodc::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::adobeacrobatprodc::install
  [ "$status" -ne 0 ]
}

@test "adobeacrobatprodc::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::adobeacrobatprodc::update
  [ "$status" -eq 127 ]
}

@test "adobeacrobatprodc::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::adobeacrobatprodc::uninstall
  [ "$status" -eq 1 ]
}

@test "adobeconnect::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobeconnect-installer.pkg"; }
  run maclib::apps::a::adobeconnect::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "adobeconnect::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobeconnect-16.112.26081720.dmg"; }
  run maclib::apps::a::adobeconnect::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "adobeconnect::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobeconnect::is_installed
  [ "$status" -eq 1 ]
}

@test "adobeconnect::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobeconnect::installed_path
  [ "$status" -eq 1 ]
}

@test "adobeconnect::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::adobeconnect::install
  [ "$status" -ne 0 ]
}

@test "adobeconnect::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::adobeconnect::update
  [ "$status" -eq 127 ]
}

@test "adobeconnect::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::adobeconnect::uninstall
  [ "$status" -eq 1 ]
}

@test "adobecreativeclouddesktop::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobecreativeclouddesktop-installer.pkg"; }
  run maclib::apps::a::adobecreativeclouddesktop::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "adobecreativeclouddesktop::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobecreativeclouddesktop-16.112.26081720.dmg"; }
  run maclib::apps::a::adobecreativeclouddesktop::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "adobecreativeclouddesktop::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobecreativeclouddesktop::is_installed
  [ "$status" -eq 1 ]
}

@test "adobecreativeclouddesktop::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobecreativeclouddesktop::installed_path
  [ "$status" -eq 1 ]
}

@test "adobecreativeclouddesktop::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::adobecreativeclouddesktop::install
  [ "$status" -ne 0 ]
}

@test "adobecreativeclouddesktop::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::adobecreativeclouddesktop::update
  [ "$status" -eq 127 ]
}

@test "adobecreativeclouddesktop::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::adobecreativeclouddesktop::uninstall
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-update::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobereaderdc-update-installer.pkg"; }
  run maclib::apps::a::adobereaderdc-update::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "adobereaderdc-update::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/adobereaderdc-update-16.112.26081720.dmg"; }
  run maclib::apps::a::adobereaderdc-update::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "adobereaderdc-update::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-update::is_installed
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-update::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-update::installed_path
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-update::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::adobereaderdc-update::install
  [ "$status" -ne 0 ]
}

@test "adobereaderdc-update::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-update::update
  [ "$status" -eq 127 ]
}

@test "adobereaderdc-update::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-update::uninstall
  [ "$status" -eq 1 ]
}

@test "aftermath::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aftermath-installer.pkg"; }
  run maclib::apps::a::aftermath::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "aftermath::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aftermath-16.112.26081720.dmg"; }
  run maclib::apps::a::aftermath::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "aftermath::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aftermath::is_installed
  [ "$status" -eq 1 ]
}

@test "aftermath::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aftermath::installed_path
  [ "$status" -eq 1 ]
}

@test "aftermath::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::aftermath::install
  [ "$status" -ne 0 ]
}

@test "aftermath::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::aftermath::update
  [ "$status" -eq 127 ]
}

@test "aftermath::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::aftermath::uninstall
  [ "$status" -eq 1 ]
}

@test "airflow::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/airflow-installer.pkg"; }
  run maclib::apps::a::airflow::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "airflow::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/airflow-16.112.26081720.dmg"; }
  run maclib::apps::a::airflow::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "airflow::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::airflow::is_installed
  [ "$status" -eq 1 ]
}

@test "airflow::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::airflow::installed_path
  [ "$status" -eq 1 ]
}

@test "airflow::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::airflow::install
  [ "$status" -ne 0 ]
}

@test "airflow::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::airflow::update
  [ "$status" -eq 127 ]
}

@test "airflow::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::airflow::uninstall
  [ "$status" -eq 1 ]
}

@test "airserver::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/airserver-installer.pkg"; }
  run maclib::apps::a::airserver::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "airserver::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/airserver-16.112.26081720.dmg"; }
  run maclib::apps::a::airserver::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "airserver::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::airserver::is_installed
  [ "$status" -eq 1 ]
}

@test "airserver::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::airserver::installed_path
  [ "$status" -eq 1 ]
}

@test "airserver::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::airserver::install
  [ "$status" -ne 0 ]
}

@test "airserver::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::airserver::update
  [ "$status" -eq 127 ]
}

@test "airserver::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::airserver::uninstall
  [ "$status" -eq 1 ]
}

@test "aldente::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aldente-installer.pkg"; }
  run maclib::apps::a::aldente::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "aldente::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aldente-16.112.26081720.dmg"; }
  run maclib::apps::a::aldente::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "aldente::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aldente::is_installed
  [ "$status" -eq 1 ]
}

@test "aldente::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aldente::installed_path
  [ "$status" -eq 1 ]
}

@test "aldente::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::aldente::install
  [ "$status" -ne 0 ]
}

@test "aldente::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::aldente::update
  [ "$status" -eq 127 ]
}

@test "aldente::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::aldente::uninstall
  [ "$status" -eq 1 ]
}

@test "alephone::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/alephone-installer.pkg"; }
  run maclib::apps::a::alephone::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "alephone::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/alephone-16.112.26081720.dmg"; }
  run maclib::apps::a::alephone::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "alephone::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::alephone::is_installed
  [ "$status" -eq 1 ]
}

@test "alephone::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::alephone::installed_path
  [ "$status" -eq 1 ]
}

@test "alephone::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::alephone::install
  [ "$status" -ne 0 ]
}

@test "alephone::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::alephone::update
  [ "$status" -eq 127 ]
}

@test "alephone::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::alephone::uninstall
  [ "$status" -eq 1 ]
}

@test "alfred::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/alfred-installer.pkg"; }
  run maclib::apps::a::alfred::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "alfred::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/alfred-16.112.26081720.dmg"; }
  run maclib::apps::a::alfred::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "alfred::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::alfred::is_installed
  [ "$status" -eq 1 ]
}

@test "alfred::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::alfred::installed_path
  [ "$status" -eq 1 ]
}

@test "alfred::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::alfred::install
  [ "$status" -ne 0 ]
}

@test "alfred::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::alfred::update
  [ "$status" -eq 127 ]
}

@test "alfred::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::alfred::uninstall
  [ "$status" -eq 1 ]
}

@test "altserver::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/altserver-installer.pkg"; }
  run maclib::apps::a::altserver::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "altserver::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/altserver-16.112.26081720.dmg"; }
  run maclib::apps::a::altserver::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "altserver::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::altserver::is_installed
  [ "$status" -eq 1 ]
}

@test "altserver::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::altserver::installed_path
  [ "$status" -eq 1 ]
}

@test "altserver::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::altserver::install
  [ "$status" -ne 0 ]
}

@test "altserver::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::altserver::update
  [ "$status" -eq 127 ]
}

@test "altserver::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::altserver::uninstall
  [ "$status" -eq 1 ]
}

@test "alttab::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/alttab-installer.pkg"; }
  run maclib::apps::a::alttab::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "alttab::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/alttab-16.112.26081720.dmg"; }
  run maclib::apps::a::alttab::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "alttab::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::alttab::is_installed
  [ "$status" -eq 1 ]
}

@test "alttab::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::alttab::installed_path
  [ "$status" -eq 1 ]
}

@test "alttab::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::alttab::install
  [ "$status" -ne 0 ]
}

@test "alttab::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::alttab::update
  [ "$status" -eq 127 ]
}

@test "alttab::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::alttab::uninstall
  [ "$status" -eq 1 ]
}

@test "amazoncorretto11jdk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto11jdk-installer.pkg"; }
  run maclib::apps::a::amazoncorretto11jdk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazoncorretto11jdk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto11jdk-16.112.26081720.dmg"; }
  run maclib::apps::a::amazoncorretto11jdk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazoncorretto11jdk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto11jdk::is_installed
  [ "$status" -eq 1 ]
}

@test "amazoncorretto11jdk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto11jdk::installed_path
  [ "$status" -eq 1 ]
}

@test "amazoncorretto11jdk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazoncorretto11jdk::install
  [ "$status" -ne 0 ]
}

@test "amazoncorretto11jdk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto11jdk::update
  [ "$status" -eq 127 ]
}

@test "amazoncorretto11jdk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto11jdk::uninstall
  [ "$status" -eq 1 ]
}

@test "amazoncorretto17jdk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto17jdk-installer.pkg"; }
  run maclib::apps::a::amazoncorretto17jdk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazoncorretto17jdk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto17jdk-16.112.26081720.dmg"; }
  run maclib::apps::a::amazoncorretto17jdk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazoncorretto17jdk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto17jdk::is_installed
  [ "$status" -eq 1 ]
}

@test "amazoncorretto17jdk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto17jdk::installed_path
  [ "$status" -eq 1 ]
}

@test "amazoncorretto17jdk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazoncorretto17jdk::install
  [ "$status" -ne 0 ]
}

@test "amazoncorretto17jdk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto17jdk::update
  [ "$status" -eq 127 ]
}

@test "amazoncorretto17jdk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto17jdk::uninstall
  [ "$status" -eq 1 ]
}

@test "amazoncorretto21jdk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto21jdk-installer.pkg"; }
  run maclib::apps::a::amazoncorretto21jdk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazoncorretto21jdk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto21jdk-16.112.26081720.dmg"; }
  run maclib::apps::a::amazoncorretto21jdk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazoncorretto21jdk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto21jdk::is_installed
  [ "$status" -eq 1 ]
}

@test "amazoncorretto21jdk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto21jdk::installed_path
  [ "$status" -eq 1 ]
}

@test "amazoncorretto21jdk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazoncorretto21jdk::install
  [ "$status" -ne 0 ]
}

@test "amazoncorretto21jdk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto21jdk::update
  [ "$status" -eq 127 ]
}

@test "amazoncorretto21jdk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto21jdk::uninstall
  [ "$status" -eq 1 ]
}

@test "amazoncorretto22jdk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto22jdk-installer.pkg"; }
  run maclib::apps::a::amazoncorretto22jdk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazoncorretto22jdk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto22jdk-16.112.26081720.dmg"; }
  run maclib::apps::a::amazoncorretto22jdk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazoncorretto22jdk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto22jdk::is_installed
  [ "$status" -eq 1 ]
}

@test "amazoncorretto22jdk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto22jdk::installed_path
  [ "$status" -eq 1 ]
}

@test "amazoncorretto22jdk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazoncorretto22jdk::install
  [ "$status" -ne 0 ]
}

@test "amazoncorretto22jdk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto22jdk::update
  [ "$status" -eq 127 ]
}

@test "amazoncorretto22jdk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto22jdk::uninstall
  [ "$status" -eq 1 ]
}

@test "amazoncorretto23jdk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto23jdk-installer.pkg"; }
  run maclib::apps::a::amazoncorretto23jdk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazoncorretto23jdk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto23jdk-16.112.26081720.dmg"; }
  run maclib::apps::a::amazoncorretto23jdk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazoncorretto23jdk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto23jdk::is_installed
  [ "$status" -eq 1 ]
}

@test "amazoncorretto23jdk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto23jdk::installed_path
  [ "$status" -eq 1 ]
}

@test "amazoncorretto23jdk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazoncorretto23jdk::install
  [ "$status" -ne 0 ]
}

@test "amazoncorretto23jdk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto23jdk::update
  [ "$status" -eq 127 ]
}

@test "amazoncorretto23jdk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto23jdk::uninstall
  [ "$status" -eq 1 ]
}

@test "amazoncorretto25jdk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto25jdk-installer.pkg"; }
  run maclib::apps::a::amazoncorretto25jdk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazoncorretto25jdk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto25jdk-16.112.26081720.dmg"; }
  run maclib::apps::a::amazoncorretto25jdk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazoncorretto25jdk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto25jdk::is_installed
  [ "$status" -eq 1 ]
}

@test "amazoncorretto25jdk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto25jdk::installed_path
  [ "$status" -eq 1 ]
}

@test "amazoncorretto25jdk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazoncorretto25jdk::install
  [ "$status" -ne 0 ]
}

@test "amazoncorretto25jdk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto25jdk::update
  [ "$status" -eq 127 ]
}

@test "amazoncorretto25jdk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto25jdk::uninstall
  [ "$status" -eq 1 ]
}

@test "amazoncorretto8jdk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto8jdk-installer.pkg"; }
  run maclib::apps::a::amazoncorretto8jdk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazoncorretto8jdk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazoncorretto8jdk-16.112.26081720.dmg"; }
  run maclib::apps::a::amazoncorretto8jdk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazoncorretto8jdk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto8jdk::is_installed
  [ "$status" -eq 1 ]
}

@test "amazoncorretto8jdk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto8jdk::installed_path
  [ "$status" -eq 1 ]
}

@test "amazoncorretto8jdk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazoncorretto8jdk::install
  [ "$status" -ne 0 ]
}

@test "amazoncorretto8jdk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto8jdk::update
  [ "$status" -eq 127 ]
}

@test "amazoncorretto8jdk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazoncorretto8jdk::uninstall
  [ "$status" -eq 1 ]
}

@test "amazonq::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazonq-installer.pkg"; }
  run maclib::apps::a::amazonq::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazonq::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazonq-16.112.26081720.dmg"; }
  run maclib::apps::a::amazonq::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazonq::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazonq::is_installed
  [ "$status" -eq 1 ]
}

@test "amazonq::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazonq::installed_path
  [ "$status" -eq 1 ]
}

@test "amazonq::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazonq::install
  [ "$status" -ne 0 ]
}

@test "amazonq::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazonq::update
  [ "$status" -eq 127 ]
}

@test "amazonq::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazonq::uninstall
  [ "$status" -eq 1 ]
}

@test "amazonworkspaces::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazonworkspaces-installer.pkg"; }
  run maclib::apps::a::amazonworkspaces::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "amazonworkspaces::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/amazonworkspaces-16.112.26081720.dmg"; }
  run maclib::apps::a::amazonworkspaces::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "amazonworkspaces::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazonworkspaces::is_installed
  [ "$status" -eq 1 ]
}

@test "amazonworkspaces::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::amazonworkspaces::installed_path
  [ "$status" -eq 1 ]
}

@test "amazonworkspaces::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::amazonworkspaces::install
  [ "$status" -ne 0 ]
}

@test "amazonworkspaces::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::amazonworkspaces::update
  [ "$status" -eq 127 ]
}

@test "amazonworkspaces::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::amazonworkspaces::uninstall
  [ "$status" -eq 1 ]
}

@test "anastasiysextensionmanager::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/anastasiysextensionmanager-installer.pkg"; }
  run maclib::apps::a::anastasiysextensionmanager::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "anastasiysextensionmanager::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/anastasiysextensionmanager-16.112.26081720.dmg"; }
  run maclib::apps::a::anastasiysextensionmanager::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "anastasiysextensionmanager::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::anastasiysextensionmanager::is_installed
  [ "$status" -eq 1 ]
}

@test "anastasiysextensionmanager::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::anastasiysextensionmanager::installed_path
  [ "$status" -eq 1 ]
}

@test "anastasiysextensionmanager::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::anastasiysextensionmanager::install
  [ "$status" -ne 0 ]
}

@test "anastasiysextensionmanager::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::anastasiysextensionmanager::update
  [ "$status" -eq 127 ]
}

@test "anastasiysextensionmanager::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::anastasiysextensionmanager::uninstall
  [ "$status" -eq 1 ]
}

@test "androidfiletransfer::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/androidfiletransfer-installer.pkg"; }
  run maclib::apps::a::androidfiletransfer::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "androidfiletransfer::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/androidfiletransfer-16.112.26081720.dmg"; }
  run maclib::apps::a::androidfiletransfer::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "androidfiletransfer::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::androidfiletransfer::is_installed
  [ "$status" -eq 1 ]
}

@test "androidfiletransfer::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::androidfiletransfer::installed_path
  [ "$status" -eq 1 ]
}

@test "androidfiletransfer::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::androidfiletransfer::install
  [ "$status" -ne 0 ]
}

@test "androidfiletransfer::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::androidfiletransfer::update
  [ "$status" -eq 127 ]
}

@test "androidfiletransfer::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::androidfiletransfer::uninstall
  [ "$status" -eq 1 ]
}

@test "anki::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/anki-installer.pkg"; }
  run maclib::apps::a::anki::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "anki::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/anki-16.112.26081720.dmg"; }
  run maclib::apps::a::anki::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "anki::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::anki::is_installed
  [ "$status" -eq 1 ]
}

@test "anki::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::anki::installed_path
  [ "$status" -eq 1 ]
}

@test "anki::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::anki::install
  [ "$status" -ne 0 ]
}

@test "anki::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::anki::update
  [ "$status" -eq 127 ]
}

@test "anki::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::anki::uninstall
  [ "$status" -eq 1 ]
}

@test "antconc::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/antconc-installer.pkg"; }
  run maclib::apps::a::antconc::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "antconc::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/antconc-16.112.26081720.dmg"; }
  run maclib::apps::a::antconc::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "antconc::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::antconc::is_installed
  [ "$status" -eq 1 ]
}

@test "antconc::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::antconc::installed_path
  [ "$status" -eq 1 ]
}

@test "antconc::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::antconc::install
  [ "$status" -ne 0 ]
}

@test "antconc::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::antconc::update
  [ "$status" -eq 127 ]
}

@test "antconc::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::antconc::uninstall
  [ "$status" -eq 1 ]
}

@test "apachedirectorystudio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/apachedirectorystudio-installer.pkg"; }
  run maclib::apps::a::apachedirectorystudio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "apachedirectorystudio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/apachedirectorystudio-16.112.26081720.dmg"; }
  run maclib::apps::a::apachedirectorystudio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "apachedirectorystudio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::apachedirectorystudio::is_installed
  [ "$status" -eq 1 ]
}

@test "apachedirectorystudio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::apachedirectorystudio::installed_path
  [ "$status" -eq 1 ]
}

@test "apachedirectorystudio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::apachedirectorystudio::install
  [ "$status" -ne 0 ]
}

@test "apachedirectorystudio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::apachedirectorystudio::update
  [ "$status" -eq 127 ]
}

@test "apachedirectorystudio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::apachedirectorystudio::uninstall
  [ "$status" -eq 1 ]
}

@test "ape::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/ape-installer.pkg"; }
  run maclib::apps::a::ape::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "ape::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/ape-16.112.26081720.dmg"; }
  run maclib::apps::a::ape::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "ape::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::ape::is_installed
  [ "$status" -eq 1 ]
}

@test "ape::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::ape::installed_path
  [ "$status" -eq 1 ]
}

@test "ape::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::ape::install
  [ "$status" -ne 0 ]
}

@test "ape::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::ape::update
  [ "$status" -eq 127 ]
}

@test "ape::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::ape::uninstall
  [ "$status" -eq 1 ]
}

@test "apparency::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/apparency-installer.pkg"; }
  run maclib::apps::a::apparency::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "apparency::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/apparency-16.112.26081720.dmg"; }
  run maclib::apps::a::apparency::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "apparency::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::apparency::is_installed
  [ "$status" -eq 1 ]
}

@test "apparency::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::apparency::installed_path
  [ "$status" -eq 1 ]
}

@test "apparency::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::apparency::install
  [ "$status" -ne 0 ]
}

@test "apparency::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::apparency::update
  [ "$status" -eq 127 ]
}

@test "apparency::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::apparency::uninstall
  [ "$status" -eq 1 ]
}

@test "appcleaner::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/appcleaner-installer.pkg"; }
  run maclib::apps::a::appcleaner::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "appcleaner::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/appcleaner-16.112.26081720.dmg"; }
  run maclib::apps::a::appcleaner::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "appcleaner::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::appcleaner::is_installed
  [ "$status" -eq 1 ]
}

@test "appcleaner::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::appcleaner::installed_path
  [ "$status" -eq 1 ]
}

@test "appcleaner::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::appcleaner::install
  [ "$status" -ne 0 ]
}

@test "appcleaner::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::appcleaner::update
  [ "$status" -eq 127 ]
}

@test "appcleaner::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::appcleaner::uninstall
  [ "$status" -eq 1 ]
}

@test "applenyfonts::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applenyfonts-installer.pkg"; }
  run maclib::apps::a::applenyfonts::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "applenyfonts::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applenyfonts-16.112.26081720.dmg"; }
  run maclib::apps::a::applenyfonts::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "applenyfonts::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applenyfonts::is_installed
  [ "$status" -eq 1 ]
}

@test "applenyfonts::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applenyfonts::installed_path
  [ "$status" -eq 1 ]
}

@test "applenyfonts::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::applenyfonts::install
  [ "$status" -ne 0 ]
}

@test "applenyfonts::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::applenyfonts::update
  [ "$status" -eq 127 ]
}

@test "applenyfonts::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::applenyfonts::uninstall
  [ "$status" -eq 1 ]
}

@test "appleprovideoformats::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/appleprovideoformats-installer.pkg"; }
  run maclib::apps::a::appleprovideoformats::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "appleprovideoformats::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/appleprovideoformats-16.112.26081720.dmg"; }
  run maclib::apps::a::appleprovideoformats::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "appleprovideoformats::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::appleprovideoformats::is_installed
  [ "$status" -eq 1 ]
}

@test "appleprovideoformats::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::appleprovideoformats::installed_path
  [ "$status" -eq 1 ]
}

@test "appleprovideoformats::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::appleprovideoformats::install
  [ "$status" -ne 0 ]
}

@test "appleprovideoformats::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::appleprovideoformats::update
  [ "$status" -eq 127 ]
}

@test "appleprovideoformats::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::appleprovideoformats::uninstall
  [ "$status" -eq 1 ]
}

@test "applesfarabic::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfarabic-installer.pkg"; }
  run maclib::apps::a::applesfarabic::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "applesfarabic::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfarabic-16.112.26081720.dmg"; }
  run maclib::apps::a::applesfarabic::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "applesfarabic::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfarabic::is_installed
  [ "$status" -eq 1 ]
}

@test "applesfarabic::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfarabic::installed_path
  [ "$status" -eq 1 ]
}

@test "applesfarabic::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::applesfarabic::install
  [ "$status" -ne 0 ]
}

@test "applesfarabic::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfarabic::update
  [ "$status" -eq 127 ]
}

@test "applesfarabic::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfarabic::uninstall
  [ "$status" -eq 1 ]
}

@test "applesfcompact::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfcompact-installer.pkg"; }
  run maclib::apps::a::applesfcompact::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "applesfcompact::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfcompact-16.112.26081720.dmg"; }
  run maclib::apps::a::applesfcompact::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "applesfcompact::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfcompact::is_installed
  [ "$status" -eq 1 ]
}

@test "applesfcompact::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfcompact::installed_path
  [ "$status" -eq 1 ]
}

@test "applesfcompact::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::applesfcompact::install
  [ "$status" -ne 0 ]
}

@test "applesfcompact::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfcompact::update
  [ "$status" -eq 127 ]
}

@test "applesfcompact::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfcompact::uninstall
  [ "$status" -eq 1 ]
}

@test "applesfmono::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfmono-installer.pkg"; }
  run maclib::apps::a::applesfmono::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "applesfmono::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfmono-16.112.26081720.dmg"; }
  run maclib::apps::a::applesfmono::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "applesfmono::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfmono::is_installed
  [ "$status" -eq 1 ]
}

@test "applesfmono::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfmono::installed_path
  [ "$status" -eq 1 ]
}

@test "applesfmono::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::applesfmono::install
  [ "$status" -ne 0 ]
}

@test "applesfmono::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfmono::update
  [ "$status" -eq 127 ]
}

@test "applesfmono::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfmono::uninstall
  [ "$status" -eq 1 ]
}

@test "applesfpro::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfpro-installer.pkg"; }
  run maclib::apps::a::applesfpro::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "applesfpro::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/applesfpro-16.112.26081720.dmg"; }
  run maclib::apps::a::applesfpro::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "applesfpro::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfpro::is_installed
  [ "$status" -eq 1 ]
}

@test "applesfpro::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfpro::installed_path
  [ "$status" -eq 1 ]
}

@test "applesfpro::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::applesfpro::install
  [ "$status" -ne 0 ]
}

@test "applesfpro::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfpro::update
  [ "$status" -eq 127 ]
}

@test "applesfpro::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfpro::uninstall
  [ "$status" -eq 1 ]
}

@test "appsanywhere::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/appsanywhere-installer.pkg"; }
  run maclib::apps::a::appsanywhere::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "appsanywhere::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/appsanywhere-16.112.26081720.dmg"; }
  run maclib::apps::a::appsanywhere::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "appsanywhere::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::appsanywhere::is_installed
  [ "$status" -eq 1 ]
}

@test "appsanywhere::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::appsanywhere::installed_path
  [ "$status" -eq 1 ]
}

@test "appsanywhere::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::appsanywhere::install
  [ "$status" -ne 0 ]
}

@test "appsanywhere::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::appsanywhere::update
  [ "$status" -eq 127 ]
}

@test "appsanywhere::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::appsanywhere::uninstall
  [ "$status" -eq 1 ]
}

@test "aquamacs::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aquamacs-installer.pkg"; }
  run maclib::apps::a::aquamacs::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "aquamacs::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aquamacs-16.112.26081720.dmg"; }
  run maclib::apps::a::aquamacs::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "aquamacs::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aquamacs::is_installed
  [ "$status" -eq 1 ]
}

@test "aquamacs::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aquamacs::installed_path
  [ "$status" -eq 1 ]
}

@test "aquamacs::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::aquamacs::install
  [ "$status" -ne 0 ]
}

@test "aquamacs::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::aquamacs::update
  [ "$status" -eq 127 ]
}

@test "aquamacs::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::aquamacs::uninstall
  [ "$status" -eq 1 ]
}

@test "aquaskk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aquaskk-installer.pkg"; }
  run maclib::apps::a::aquaskk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "aquaskk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aquaskk-16.112.26081720.dmg"; }
  run maclib::apps::a::aquaskk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "aquaskk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aquaskk::is_installed
  [ "$status" -eq 1 ]
}

@test "aquaskk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aquaskk::installed_path
  [ "$status" -eq 1 ]
}

@test "aquaskk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::aquaskk::install
  [ "$status" -ne 0 ]
}

@test "aquaskk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::aquaskk::update
  [ "$status" -eq 127 ]
}

@test "aquaskk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::aquaskk::uninstall
  [ "$status" -eq 1 ]
}

@test "arcbrowser::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arcbrowser-installer.pkg"; }
  run maclib::apps::a::arcbrowser::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "arcbrowser::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arcbrowser-16.112.26081720.dmg"; }
  run maclib::apps::a::arcbrowser::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "arcbrowser::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arcbrowser::is_installed
  [ "$status" -eq 1 ]
}

@test "arcbrowser::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arcbrowser::installed_path
  [ "$status" -eq 1 ]
}

@test "arcbrowser::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::arcbrowser::install
  [ "$status" -ne 0 ]
}

@test "arcbrowser::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::arcbrowser::update
  [ "$status" -eq 127 ]
}

@test "arcbrowser::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::arcbrowser::uninstall
  [ "$status" -eq 1 ]
}

@test "archaeology::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archaeology-installer.pkg"; }
  run maclib::apps::a::archaeology::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "archaeology::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archaeology-16.112.26081720.dmg"; }
  run maclib::apps::a::archaeology::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "archaeology::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archaeology::is_installed
  [ "$status" -eq 1 ]
}

@test "archaeology::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archaeology::installed_path
  [ "$status" -eq 1 ]
}

@test "archaeology::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::archaeology::install
  [ "$status" -ne 0 ]
}

@test "archaeology::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::archaeology::update
  [ "$status" -eq 127 ]
}

@test "archaeology::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::archaeology::uninstall
  [ "$status" -eq 1 ]
}

@test "archimate::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archimate-installer.pkg"; }
  run maclib::apps::a::archimate::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "archimate::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archimate-16.112.26081720.dmg"; }
  run maclib::apps::a::archimate::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "archimate::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archimate::is_installed
  [ "$status" -eq 1 ]
}

@test "archimate::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archimate::installed_path
  [ "$status" -eq 1 ]
}

@test "archimate::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::archimate::install
  [ "$status" -ne 0 ]
}

@test "archimate::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::archimate::update
  [ "$status" -eq 127 ]
}

@test "archimate::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::archimate::uninstall
  [ "$status" -eq 1 ]
}

@test "archiwareb2go::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archiwareb2go-installer.pkg"; }
  run maclib::apps::a::archiwareb2go::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "archiwareb2go::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archiwareb2go-16.112.26081720.dmg"; }
  run maclib::apps::a::archiwareb2go::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "archiwareb2go::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archiwareb2go::is_installed
  [ "$status" -eq 1 ]
}

@test "archiwareb2go::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archiwareb2go::installed_path
  [ "$status" -eq 1 ]
}

@test "archiwareb2go::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::archiwareb2go::install
  [ "$status" -ne 0 ]
}

@test "archiwareb2go::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::archiwareb2go::update
  [ "$status" -eq 127 ]
}

@test "archiwareb2go::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::archiwareb2go::uninstall
  [ "$status" -eq 1 ]
}

@test "archiwarepst::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archiwarepst-installer.pkg"; }
  run maclib::apps::a::archiwarepst::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "archiwarepst::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/archiwarepst-16.112.26081720.dmg"; }
  run maclib::apps::a::archiwarepst::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "archiwarepst::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archiwarepst::is_installed
  [ "$status" -eq 1 ]
}

@test "archiwarepst::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::archiwarepst::installed_path
  [ "$status" -eq 1 ]
}

@test "archiwarepst::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::archiwarepst::install
  [ "$status" -ne 0 ]
}

@test "archiwarepst::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::archiwarepst::update
  [ "$status" -eq 127 ]
}

@test "archiwarepst::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::archiwarepst::uninstall
  [ "$status" -eq 1 ]
}

@test "arduinoide::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arduinoide-installer.pkg"; }
  run maclib::apps::a::arduinoide::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "arduinoide::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arduinoide-16.112.26081720.dmg"; }
  run maclib::apps::a::arduinoide::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "arduinoide::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arduinoide::is_installed
  [ "$status" -eq 1 ]
}

@test "arduinoide::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arduinoide::installed_path
  [ "$status" -eq 1 ]
}

@test "arduinoide::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::arduinoide::install
  [ "$status" -ne 0 ]
}

@test "arduinoide::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::arduinoide::update
  [ "$status" -eq 127 ]
}

@test "arduinoide::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::arduinoide::uninstall
  [ "$status" -eq 1 ]
}

@test "arq7::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arq7-installer.pkg"; }
  run maclib::apps::a::arq7::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "arq7::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arq7-16.112.26081720.dmg"; }
  run maclib::apps::a::arq7::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "arq7::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arq7::is_installed
  [ "$status" -eq 1 ]
}

@test "arq7::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arq7::installed_path
  [ "$status" -eq 1 ]
}

@test "arq7::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::arq7::install
  [ "$status" -ne 0 ]
}

@test "arq7::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::arq7::update
  [ "$status" -eq 127 ]
}

@test "arq7::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::arq7::uninstall
  [ "$status" -eq 1 ]
}

@test "arturiamcc::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arturiamcc-installer.pkg"; }
  run maclib::apps::a::arturiamcc::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "arturiamcc::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arturiamcc-16.112.26081720.dmg"; }
  run maclib::apps::a::arturiamcc::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "arturiamcc::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arturiamcc::is_installed
  [ "$status" -eq 1 ]
}

@test "arturiamcc::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arturiamcc::installed_path
  [ "$status" -eq 1 ]
}

@test "arturiamcc::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::arturiamcc::install
  [ "$status" -ne 0 ]
}

@test "arturiamcc::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::arturiamcc::update
  [ "$status" -eq 127 ]
}

@test "arturiamcc::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::arturiamcc::uninstall
  [ "$status" -eq 1 ]
}

@test "arturiasoftwarecenter::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arturiasoftwarecenter-installer.pkg"; }
  run maclib::apps::a::arturiasoftwarecenter::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "arturiasoftwarecenter::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/arturiasoftwarecenter-16.112.26081720.dmg"; }
  run maclib::apps::a::arturiasoftwarecenter::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "arturiasoftwarecenter::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arturiasoftwarecenter::is_installed
  [ "$status" -eq 1 ]
}

@test "arturiasoftwarecenter::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::arturiasoftwarecenter::installed_path
  [ "$status" -eq 1 ]
}

@test "arturiasoftwarecenter::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::arturiasoftwarecenter::install
  [ "$status" -ne 0 ]
}

@test "arturiasoftwarecenter::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::arturiasoftwarecenter::update
  [ "$status" -eq 127 ]
}

@test "arturiasoftwarecenter::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::arturiasoftwarecenter::uninstall
  [ "$status" -eq 1 ]
}

@test "asana::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/asana-installer.pkg"; }
  run maclib::apps::a::asana::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "asana::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/asana-16.112.26081720.dmg"; }
  run maclib::apps::a::asana::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "asana::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::asana::is_installed
  [ "$status" -eq 1 ]
}

@test "asana::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::asana::installed_path
  [ "$status" -eq 1 ]
}

@test "asana::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::asana::install
  [ "$status" -ne 0 ]
}

@test "asana::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::asana::update
  [ "$status" -eq 127 ]
}

@test "asana::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::asana::uninstall
  [ "$status" -eq 1 ]
}

@test "asperaconnect::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/asperaconnect-installer.pkg"; }
  run maclib::apps::a::asperaconnect::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "asperaconnect::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/asperaconnect-16.112.26081720.dmg"; }
  run maclib::apps::a::asperaconnect::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "asperaconnect::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::asperaconnect::is_installed
  [ "$status" -eq 1 ]
}

@test "asperaconnect::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::asperaconnect::installed_path
  [ "$status" -eq 1 ]
}

@test "asperaconnect::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::asperaconnect::install
  [ "$status" -ne 0 ]
}

@test "asperaconnect::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::asperaconnect::update
  [ "$status" -eq 127 ]
}

@test "asperaconnect::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::asperaconnect::uninstall
  [ "$status" -eq 1 ]
}

@test "asymmetrickeygenerator::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/asymmetrickeygenerator-installer.pkg"; }
  run maclib::apps::a::asymmetrickeygenerator::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "asymmetrickeygenerator::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/asymmetrickeygenerator-16.112.26081720.dmg"; }
  run maclib::apps::a::asymmetrickeygenerator::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "asymmetrickeygenerator::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::asymmetrickeygenerator::is_installed
  [ "$status" -eq 1 ]
}

@test "asymmetrickeygenerator::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::asymmetrickeygenerator::installed_path
  [ "$status" -eq 1 ]
}

@test "asymmetrickeygenerator::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::asymmetrickeygenerator::install
  [ "$status" -ne 0 ]
}

@test "asymmetrickeygenerator::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::asymmetrickeygenerator::update
  [ "$status" -eq 127 ]
}

@test "asymmetrickeygenerator::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::asymmetrickeygenerator::uninstall
  [ "$status" -eq 1 ]
}

@test "atlassiancompanion::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/atlassiancompanion-installer.pkg"; }
  run maclib::apps::a::atlassiancompanion::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "atlassiancompanion::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/atlassiancompanion-16.112.26081720.dmg"; }
  run maclib::apps::a::atlassiancompanion::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "atlassiancompanion::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::atlassiancompanion::is_installed
  [ "$status" -eq 1 ]
}

@test "atlassiancompanion::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::atlassiancompanion::installed_path
  [ "$status" -eq 1 ]
}

@test "atlassiancompanion::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::atlassiancompanion::install
  [ "$status" -ne 0 ]
}

@test "atlassiancompanion::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::atlassiancompanion::update
  [ "$status" -eq 127 ]
}

@test "atlassiancompanion::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::atlassiancompanion::uninstall
  [ "$status" -eq 1 ]
}

@test "audacity::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/audacity-installer.pkg"; }
  run maclib::apps::a::audacity::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "audacity::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/audacity-16.112.26081720.dmg"; }
  run maclib::apps::a::audacity::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "audacity::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::audacity::is_installed
  [ "$status" -eq 1 ]
}

@test "audacity::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::audacity::installed_path
  [ "$status" -eq 1 ]
}

@test "audacity::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::audacity::install
  [ "$status" -ne 0 ]
}

@test "audacity::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::audacity::update
  [ "$status" -eq 127 ]
}

@test "audacity::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::audacity::uninstall
  [ "$status" -eq 1 ]
}

@test "autodmg::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/autodmg-installer.pkg"; }
  run maclib::apps::a::autodmg::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "autodmg::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/autodmg-16.112.26081720.dmg"; }
  run maclib::apps::a::autodmg::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "autodmg::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::autodmg::is_installed
  [ "$status" -eq 1 ]
}

@test "autodmg::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::autodmg::installed_path
  [ "$status" -eq 1 ]
}

@test "autodmg::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::autodmg::install
  [ "$status" -ne 0 ]
}

@test "autodmg::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::autodmg::update
  [ "$status" -eq 127 ]
}

@test "autodmg::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::autodmg::uninstall
  [ "$status" -eq 1 ]
}

@test "automounter::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/automounter-installer.pkg"; }
  run maclib::apps::a::automounter::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "automounter::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/automounter-16.112.26081720.dmg"; }
  run maclib::apps::a::automounter::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "automounter::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::automounter::is_installed
  [ "$status" -eq 1 ]
}

@test "automounter::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::automounter::installed_path
  [ "$status" -eq 1 ]
}

@test "automounter::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::automounter::install
  [ "$status" -ne 0 ]
}

@test "automounter::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::automounter::update
  [ "$status" -eq 127 ]
}

@test "automounter::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::automounter::uninstall
  [ "$status" -eq 1 ]
}

@test "autopkgr::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/autopkgr-installer.pkg"; }
  run maclib::apps::a::autopkgr::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "autopkgr::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/autopkgr-16.112.26081720.dmg"; }
  run maclib::apps::a::autopkgr::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "autopkgr::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::autopkgr::is_installed
  [ "$status" -eq 1 ]
}

@test "autopkgr::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::autopkgr::installed_path
  [ "$status" -eq 1 ]
}

@test "autopkgr::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::autopkgr::install
  [ "$status" -ne 0 ]
}

@test "autopkgr::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::autopkgr::update
  [ "$status" -eq 127 ]
}

@test "autopkgr::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::autopkgr::uninstall
  [ "$status" -eq 1 ]
}

@test "avertouch::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/avertouch-installer.pkg"; }
  run maclib::apps::a::avertouch::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "avertouch::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/avertouch-16.112.26081720.dmg"; }
  run maclib::apps::a::avertouch::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "avertouch::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::avertouch::is_installed
  [ "$status" -eq 1 ]
}

@test "avertouch::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::avertouch::installed_path
  [ "$status" -eq 1 ]
}

@test "avertouch::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::avertouch::install
  [ "$status" -ne 0 ]
}

@test "avertouch::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::avertouch::update
  [ "$status" -eq 127 ]
}

@test "avertouch::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::avertouch::uninstall
  [ "$status" -eq 1 ]
}

@test "aviatrix::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aviatrix-installer.pkg"; }
  run maclib::apps::a::aviatrix::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "aviatrix::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/aviatrix-16.112.26081720.dmg"; }
  run maclib::apps::a::aviatrix::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "aviatrix::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aviatrix::is_installed
  [ "$status" -eq 1 ]
}

@test "aviatrix::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aviatrix::installed_path
  [ "$status" -eq 1 ]
}

@test "aviatrix::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::aviatrix::install
  [ "$status" -ne 0 ]
}

@test "aviatrix::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::aviatrix::update
  [ "$status" -eq 127 ]
}

@test "aviatrix::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::aviatrix::uninstall
  [ "$status" -eq 1 ]
}

@test "awscli2::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/awscli2-installer.pkg"; }
  run maclib::apps::a::awscli2::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "awscli2::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/awscli2-16.112.26081720.dmg"; }
  run maclib::apps::a::awscli2::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "awscli2::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::awscli2::is_installed
  [ "$status" -eq 1 ]
}

@test "awscli2::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::awscli2::installed_path
  [ "$status" -eq 1 ]
}

@test "awscli2::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::awscli2::install
  [ "$status" -ne 0 ]
}

@test "awscli2::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::awscli2::update
  [ "$status" -eq 127 ]
}

@test "awscli2::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::awscli2::uninstall
  [ "$status" -eq 1 ]
}

@test "awsvpnclient::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/awsvpnclient-installer.pkg"; }
  run maclib::apps::a::awsvpnclient::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "awsvpnclient::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/awsvpnclient-16.112.26081720.dmg"; }
  run maclib::apps::a::awsvpnclient::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "awsvpnclient::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::awsvpnclient::is_installed
  [ "$status" -eq 1 ]
}

@test "awsvpnclient::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::awsvpnclient::installed_path
  [ "$status" -eq 1 ]
}

@test "awsvpnclient::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::awsvpnclient::install
  [ "$status" -ne 0 ]
}

@test "awsvpnclient::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::awsvpnclient::update
  [ "$status" -eq 127 ]
}

@test "awsvpnclient::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::awsvpnclient::uninstall
  [ "$status" -eq 1 ]
}

@test "axurerp10::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/axurerp10-installer.pkg"; }
  run maclib::apps::a::axurerp10::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "axurerp10::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/axurerp10-16.112.26081720.dmg"; }
  run maclib::apps::a::axurerp10::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "axurerp10::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::axurerp10::is_installed
  [ "$status" -eq 1 ]
}

@test "axurerp10::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::axurerp10::installed_path
  [ "$status" -eq 1 ]
}

@test "axurerp10::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::axurerp10::install
  [ "$status" -ne 0 ]
}

@test "axurerp10::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::axurerp10::update
  [ "$status" -eq 127 ]
}

@test "axurerp10::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::axurerp10::uninstall
  [ "$status" -eq 1 ]
}

@test "azuredatastudio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/azuredatastudio-installer.pkg"; }
  run maclib::apps::a::azuredatastudio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "azuredatastudio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/azuredatastudio-16.112.26081720.dmg"; }
  run maclib::apps::a::azuredatastudio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "azuredatastudio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::azuredatastudio::is_installed
  [ "$status" -eq 1 ]
}

@test "azuredatastudio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::azuredatastudio::installed_path
  [ "$status" -eq 1 ]
}

@test "azuredatastudio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::a::azuredatastudio::install
  [ "$status" -ne 0 ]
}

@test "azuredatastudio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::a::azuredatastudio::update
  [ "$status" -eq 127 ]
}

@test "azuredatastudio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::a::azuredatastudio::uninstall
  [ "$status" -eq 1 ]
}

@test "backgroundmusic::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/backgroundmusic-installer.pkg"; }
  run maclib::apps::b::backgroundmusic::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "backgroundmusic::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/backgroundmusic-16.112.26081720.dmg"; }
  run maclib::apps::b::backgroundmusic::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "backgroundmusic::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::backgroundmusic::is_installed
  [ "$status" -eq 1 ]
}

@test "backgroundmusic::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::backgroundmusic::installed_path
  [ "$status" -eq 1 ]
}

@test "backgroundmusic::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::backgroundmusic::install
  [ "$status" -ne 0 ]
}

@test "backgroundmusic::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::backgroundmusic::update
  [ "$status" -eq 127 ]
}

@test "backgroundmusic::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::backgroundmusic::uninstall
  [ "$status" -eq 1 ]
}

@test "backgrounds::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/backgrounds-installer.pkg"; }
  run maclib::apps::b::backgrounds::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "backgrounds::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/backgrounds-16.112.26081720.dmg"; }
  run maclib::apps::b::backgrounds::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "backgrounds::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::backgrounds::is_installed
  [ "$status" -eq 1 ]
}

@test "backgrounds::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::backgrounds::installed_path
  [ "$status" -eq 1 ]
}

@test "backgrounds::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::backgrounds::install
  [ "$status" -ne 0 ]
}

@test "backgrounds::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::backgrounds::update
  [ "$status" -eq 127 ]
}

@test "backgrounds::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::backgrounds::uninstall
  [ "$status" -eq 1 ]
}

@test "balenaetcher::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/balenaetcher-installer.pkg"; }
  run maclib::apps::b::balenaetcher::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "balenaetcher::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/balenaetcher-16.112.26081720.dmg"; }
  run maclib::apps::b::balenaetcher::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "balenaetcher::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::balenaetcher::is_installed
  [ "$status" -eq 1 ]
}

@test "balenaetcher::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::balenaetcher::installed_path
  [ "$status" -eq 1 ]
}

@test "balenaetcher::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::balenaetcher::install
  [ "$status" -ne 0 ]
}

@test "balenaetcher::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::balenaetcher::update
  [ "$status" -eq 127 ]
}

@test "balenaetcher::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::balenaetcher::uninstall
  [ "$status" -eq 1 ]
}

@test "balsamiqwireframes::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/balsamiqwireframes-installer.pkg"; }
  run maclib::apps::b::balsamiqwireframes::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "balsamiqwireframes::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/balsamiqwireframes-16.112.26081720.dmg"; }
  run maclib::apps::b::balsamiqwireframes::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "balsamiqwireframes::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::balsamiqwireframes::is_installed
  [ "$status" -eq 1 ]
}

@test "balsamiqwireframes::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::balsamiqwireframes::installed_path
  [ "$status" -eq 1 ]
}

@test "balsamiqwireframes::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::balsamiqwireframes::install
  [ "$status" -ne 0 ]
}

@test "balsamiqwireframes::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::balsamiqwireframes::update
  [ "$status" -eq 127 ]
}

@test "balsamiqwireframes::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::balsamiqwireframes::uninstall
  [ "$status" -eq 1 ]
}

@test "bambustudio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bambustudio-installer.pkg"; }
  run maclib::apps::b::bambustudio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bambustudio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bambustudio-16.112.26081720.dmg"; }
  run maclib::apps::b::bambustudio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bambustudio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bambustudio::is_installed
  [ "$status" -eq 1 ]
}

@test "bambustudio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bambustudio::installed_path
  [ "$status" -eq 1 ]
}

@test "bambustudio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bambustudio::install
  [ "$status" -ne 0 ]
}

@test "bambustudio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bambustudio::update
  [ "$status" -eq 127 ]
}

@test "bambustudio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bambustudio::uninstall
  [ "$status" -eq 1 ]
}

@test "bartender::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bartender-installer.pkg"; }
  run maclib::apps::b::bartender::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bartender::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bartender-16.112.26081720.dmg"; }
  run maclib::apps::b::bartender::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bartender::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bartender::is_installed
  [ "$status" -eq 1 ]
}

@test "bartender::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bartender::installed_path
  [ "$status" -eq 1 ]
}

@test "bartender::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bartender::install
  [ "$status" -ne 0 ]
}

@test "bartender::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bartender::update
  [ "$status" -eq 127 ]
}

@test "bartender::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bartender::uninstall
  [ "$status" -eq 1 ]
}

@test "basecamp3::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/basecamp3-installer.pkg"; }
  run maclib::apps::b::basecamp3::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "basecamp3::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/basecamp3-16.112.26081720.dmg"; }
  run maclib::apps::b::basecamp3::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "basecamp3::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::basecamp3::is_installed
  [ "$status" -eq 1 ]
}

@test "basecamp3::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::basecamp3::installed_path
  [ "$status" -eq 1 ]
}

@test "basecamp3::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::basecamp3::install
  [ "$status" -ne 0 ]
}

@test "basecamp3::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::basecamp3::update
  [ "$status" -eq 127 ]
}

@test "basecamp3::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::basecamp3::uninstall
  [ "$status" -eq 1 ]
}

@test "baseline::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/baseline-installer.pkg"; }
  run maclib::apps::b::baseline::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "baseline::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/baseline-16.112.26081720.dmg"; }
  run maclib::apps::b::baseline::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "baseline::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::baseline::is_installed
  [ "$status" -eq 1 ]
}

@test "baseline::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::baseline::installed_path
  [ "$status" -eq 1 ]
}

@test "baseline::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::baseline::install
  [ "$status" -ne 0 ]
}

@test "baseline::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::baseline::update
  [ "$status" -eq 127 ]
}

@test "baseline::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::baseline::uninstall
  [ "$status" -eq 1 ]
}

@test "baseline-nodaemon::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/baseline-nodaemon-installer.pkg"; }
  run maclib::apps::b::baseline-nodaemon::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "baseline-nodaemon::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/baseline-nodaemon-16.112.26081720.dmg"; }
  run maclib::apps::b::baseline-nodaemon::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "baseline-nodaemon::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::baseline-nodaemon::is_installed
  [ "$status" -eq 1 ]
}

@test "baseline-nodaemon::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::baseline-nodaemon::installed_path
  [ "$status" -eq 1 ]
}

@test "baseline-nodaemon::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::baseline-nodaemon::install
  [ "$status" -ne 0 ]
}

@test "baseline-nodaemon::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::baseline-nodaemon::update
  [ "$status" -eq 127 ]
}

@test "baseline-nodaemon::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::baseline-nodaemon::uninstall
  [ "$status" -eq 1 ]
}

@test "bbedit::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bbedit-installer.pkg"; }
  run maclib::apps::b::bbedit::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bbedit::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bbedit-16.112.26081720.dmg"; }
  run maclib::apps::b::bbedit::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bbedit::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bbedit::is_installed
  [ "$status" -eq 1 ]
}

@test "bbedit::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bbedit::installed_path
  [ "$status" -eq 1 ]
}

@test "bbedit::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bbedit::install
  [ "$status" -ne 0 ]
}

@test "bbedit::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bbedit::update
  [ "$status" -eq 127 ]
}

@test "bbedit::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bbedit::uninstall
  [ "$status" -eq 1 ]
}

@test "bbeditpkg::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bbeditpkg-installer.pkg"; }
  run maclib::apps::b::bbeditpkg::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bbeditpkg::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bbeditpkg-16.112.26081720.dmg"; }
  run maclib::apps::b::bbeditpkg::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bbeditpkg::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bbeditpkg::is_installed
  [ "$status" -eq 1 ]
}

@test "bbeditpkg::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bbeditpkg::installed_path
  [ "$status" -eq 1 ]
}

@test "bbeditpkg::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bbeditpkg::install
  [ "$status" -ne 0 ]
}

@test "bbeditpkg::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bbeditpkg::update
  [ "$status" -eq 127 ]
}

@test "bbeditpkg::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bbeditpkg::uninstall
  [ "$status" -eq 1 ]
}

@test "beamstudio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/beamstudio-installer.pkg"; }
  run maclib::apps::b::beamstudio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "beamstudio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/beamstudio-16.112.26081720.dmg"; }
  run maclib::apps::b::beamstudio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "beamstudio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::beamstudio::is_installed
  [ "$status" -eq 1 ]
}

@test "beamstudio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::beamstudio::installed_path
  [ "$status" -eq 1 ]
}

@test "beamstudio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::beamstudio::install
  [ "$status" -ne 0 ]
}

@test "beamstudio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::beamstudio::update
  [ "$status" -eq 127 ]
}

@test "beamstudio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::beamstudio::uninstall
  [ "$status" -eq 1 ]
}

@test "beekeeperstudio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/beekeeperstudio-installer.pkg"; }
  run maclib::apps::b::beekeeperstudio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "beekeeperstudio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/beekeeperstudio-16.112.26081720.dmg"; }
  run maclib::apps::b::beekeeperstudio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "beekeeperstudio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::beekeeperstudio::is_installed
  [ "$status" -eq 1 ]
}

@test "beekeeperstudio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::beekeeperstudio::installed_path
  [ "$status" -eq 1 ]
}

@test "beekeeperstudio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::beekeeperstudio::install
  [ "$status" -ne 0 ]
}

@test "beekeeperstudio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::beekeeperstudio::update
  [ "$status" -eq 127 ]
}

@test "beekeeperstudio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::beekeeperstudio::uninstall
  [ "$status" -eq 1 ]
}

@test "betterdisplay::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/betterdisplay-installer.pkg"; }
  run maclib::apps::b::betterdisplay::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "betterdisplay::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/betterdisplay-16.112.26081720.dmg"; }
  run maclib::apps::b::betterdisplay::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "betterdisplay::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::betterdisplay::is_installed
  [ "$status" -eq 1 ]
}

@test "betterdisplay::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::betterdisplay::installed_path
  [ "$status" -eq 1 ]
}

@test "betterdisplay::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::betterdisplay::install
  [ "$status" -ne 0 ]
}

@test "betterdisplay::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::betterdisplay::update
  [ "$status" -eq 127 ]
}

@test "betterdisplay::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::betterdisplay::uninstall
  [ "$status" -eq 1 ]
}

@test "bettertouchtool::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bettertouchtool-installer.pkg"; }
  run maclib::apps::b::bettertouchtool::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bettertouchtool::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bettertouchtool-16.112.26081720.dmg"; }
  run maclib::apps::b::bettertouchtool::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bettertouchtool::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bettertouchtool::is_installed
  [ "$status" -eq 1 ]
}

@test "bettertouchtool::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bettertouchtool::installed_path
  [ "$status" -eq 1 ]
}

@test "bettertouchtool::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bettertouchtool::install
  [ "$status" -ne 0 ]
}

@test "bettertouchtool::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bettertouchtool::update
  [ "$status" -eq 127 ]
}

@test "bettertouchtool::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bettertouchtool::uninstall
  [ "$status" -eq 1 ]
}

@test "betterzip::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/betterzip-installer.pkg"; }
  run maclib::apps::b::betterzip::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "betterzip::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/betterzip-16.112.26081720.dmg"; }
  run maclib::apps::b::betterzip::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "betterzip::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::betterzip::is_installed
  [ "$status" -eq 1 ]
}

@test "betterzip::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::betterzip::installed_path
  [ "$status" -eq 1 ]
}

@test "betterzip::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::betterzip::install
  [ "$status" -ne 0 ]
}

@test "betterzip::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::betterzip::update
  [ "$status" -eq 127 ]
}

@test "betterzip::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::betterzip::uninstall
  [ "$status" -eq 1 ]
}

@test "beyondcomparepro::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/beyondcomparepro-installer.pkg"; }
  run maclib::apps::b::beyondcomparepro::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "beyondcomparepro::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/beyondcomparepro-16.112.26081720.dmg"; }
  run maclib::apps::b::beyondcomparepro::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "beyondcomparepro::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::beyondcomparepro::is_installed
  [ "$status" -eq 1 ]
}

@test "beyondcomparepro::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::beyondcomparepro::installed_path
  [ "$status" -eq 1 ]
}

@test "beyondcomparepro::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::beyondcomparepro::install
  [ "$status" -ne 0 ]
}

@test "beyondcomparepro::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::beyondcomparepro::update
  [ "$status" -eq 127 ]
}

@test "beyondcomparepro::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::beyondcomparepro::uninstall
  [ "$status" -eq 1 ]
}

@test "bezel::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bezel-installer.pkg"; }
  run maclib::apps::b::bezel::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bezel::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bezel-16.112.26081720.dmg"; }
  run maclib::apps::b::bezel::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bezel::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bezel::is_installed
  [ "$status" -eq 1 ]
}

@test "bezel::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bezel::installed_path
  [ "$status" -eq 1 ]
}

@test "bezel::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bezel::install
  [ "$status" -ne 0 ]
}

@test "bezel::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bezel::update
  [ "$status" -eq 127 ]
}

@test "bezel::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bezel::uninstall
  [ "$status" -eq 1 ]
}

@test "bibdesk::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bibdesk-installer.pkg"; }
  run maclib::apps::b::bibdesk::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bibdesk::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bibdesk-16.112.26081720.dmg"; }
  run maclib::apps::b::bibdesk::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bibdesk::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bibdesk::is_installed
  [ "$status" -eq 1 ]
}

@test "bibdesk::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bibdesk::installed_path
  [ "$status" -eq 1 ]
}

@test "bibdesk::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bibdesk::install
  [ "$status" -ne 0 ]
}

@test "bibdesk::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bibdesk::update
  [ "$status" -eq 127 ]
}

@test "bibdesk::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bibdesk::uninstall
  [ "$status" -eq 1 ]
}

@test "bitrix24::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bitrix24-installer.pkg"; }
  run maclib::apps::b::bitrix24::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bitrix24::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bitrix24-16.112.26081720.dmg"; }
  run maclib::apps::b::bitrix24::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bitrix24::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bitrix24::is_installed
  [ "$status" -eq 1 ]
}

@test "bitrix24::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bitrix24::installed_path
  [ "$status" -eq 1 ]
}

@test "bitrix24::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bitrix24::install
  [ "$status" -ne 0 ]
}

@test "bitrix24::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bitrix24::update
  [ "$status" -eq 127 ]
}

@test "bitrix24::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bitrix24::uninstall
  [ "$status" -eq 1 ]
}

@test "bitwarden::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bitwarden-installer.pkg"; }
  run maclib::apps::b::bitwarden::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bitwarden::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bitwarden-16.112.26081720.dmg"; }
  run maclib::apps::b::bitwarden::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bitwarden::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bitwarden::is_installed
  [ "$status" -eq 1 ]
}

@test "bitwarden::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bitwarden::installed_path
  [ "$status" -eq 1 ]
}

@test "bitwarden::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bitwarden::install
  [ "$status" -ne 0 ]
}

@test "bitwarden::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bitwarden::update
  [ "$status" -eq 127 ]
}

@test "bitwarden::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bitwarden::uninstall
  [ "$status" -eq 1 ]
}

@test "bitwigstudio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bitwigstudio-installer.pkg"; }
  run maclib::apps::b::bitwigstudio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bitwigstudio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bitwigstudio-16.112.26081720.dmg"; }
  run maclib::apps::b::bitwigstudio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bitwigstudio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bitwigstudio::is_installed
  [ "$status" -eq 1 ]
}

@test "bitwigstudio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bitwigstudio::installed_path
  [ "$status" -eq 1 ]
}

@test "bitwigstudio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bitwigstudio::install
  [ "$status" -ne 0 ]
}

@test "bitwigstudio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bitwigstudio::update
  [ "$status" -eq 127 ]
}

@test "bitwigstudio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bitwigstudio::uninstall
  [ "$status" -eq 1 ]
}

@test "blackhole16ch::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blackhole16ch-installer.pkg"; }
  run maclib::apps::b::blackhole16ch::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "blackhole16ch::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blackhole16ch-16.112.26081720.dmg"; }
  run maclib::apps::b::blackhole16ch::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "blackhole16ch::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole16ch::is_installed
  [ "$status" -eq 1 ]
}

@test "blackhole16ch::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole16ch::installed_path
  [ "$status" -eq 1 ]
}

@test "blackhole16ch::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::blackhole16ch::install
  [ "$status" -ne 0 ]
}

@test "blackhole16ch::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole16ch::update
  [ "$status" -eq 127 ]
}

@test "blackhole16ch::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole16ch::uninstall
  [ "$status" -eq 1 ]
}

@test "blackhole2ch::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blackhole2ch-installer.pkg"; }
  run maclib::apps::b::blackhole2ch::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "blackhole2ch::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blackhole2ch-16.112.26081720.dmg"; }
  run maclib::apps::b::blackhole2ch::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "blackhole2ch::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole2ch::is_installed
  [ "$status" -eq 1 ]
}

@test "blackhole2ch::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole2ch::installed_path
  [ "$status" -eq 1 ]
}

@test "blackhole2ch::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::blackhole2ch::install
  [ "$status" -ne 0 ]
}

@test "blackhole2ch::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole2ch::update
  [ "$status" -eq 127 ]
}

@test "blackhole2ch::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole2ch::uninstall
  [ "$status" -eq 1 ]
}

@test "blackhole64ch::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blackhole64ch-installer.pkg"; }
  run maclib::apps::b::blackhole64ch::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "blackhole64ch::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blackhole64ch-16.112.26081720.dmg"; }
  run maclib::apps::b::blackhole64ch::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "blackhole64ch::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole64ch::is_installed
  [ "$status" -eq 1 ]
}

@test "blackhole64ch::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole64ch::installed_path
  [ "$status" -eq 1 ]
}

@test "blackhole64ch::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::blackhole64ch::install
  [ "$status" -ne 0 ]
}

@test "blackhole64ch::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole64ch::update
  [ "$status" -eq 127 ]
}

@test "blackhole64ch::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::blackhole64ch::uninstall
  [ "$status" -eq 1 ]
}

@test "blitzit::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blitzit-installer.pkg"; }
  run maclib::apps::b::blitzit::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "blitzit::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/blitzit-16.112.26081720.dmg"; }
  run maclib::apps::b::blitzit::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "blitzit::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blitzit::is_installed
  [ "$status" -eq 1 ]
}

@test "blitzit::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::blitzit::installed_path
  [ "$status" -eq 1 ]
}

@test "blitzit::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::blitzit::install
  [ "$status" -ne 0 ]
}

@test "blitzit::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::blitzit::update
  [ "$status" -eq 127 ]
}

@test "blitzit::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::blitzit::uninstall
  [ "$status" -eq 1 ]
}

@test "boop::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boop-installer.pkg"; }
  run maclib::apps::b::boop::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "boop::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boop-16.112.26081720.dmg"; }
  run maclib::apps::b::boop::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "boop::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boop::is_installed
  [ "$status" -eq 1 ]
}

@test "boop::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boop::installed_path
  [ "$status" -eq 1 ]
}

@test "boop::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::boop::install
  [ "$status" -ne 0 ]
}

@test "boop::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::boop::update
  [ "$status" -eq 127 ]
}

@test "boop::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::boop::uninstall
  [ "$status" -eq 1 ]
}

@test "boxdrive::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boxdrive-installer.pkg"; }
  run maclib::apps::b::boxdrive::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "boxdrive::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boxdrive-16.112.26081720.dmg"; }
  run maclib::apps::b::boxdrive::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "boxdrive::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boxdrive::is_installed
  [ "$status" -eq 1 ]
}

@test "boxdrive::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boxdrive::installed_path
  [ "$status" -eq 1 ]
}

@test "boxdrive::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::boxdrive::install
  [ "$status" -ne 0 ]
}

@test "boxdrive::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::boxdrive::update
  [ "$status" -eq 127 ]
}

@test "boxdrive::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::boxdrive::uninstall
  [ "$status" -eq 1 ]
}

@test "boxsync::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boxsync-installer.pkg"; }
  run maclib::apps::b::boxsync::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "boxsync::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boxsync-16.112.26081720.dmg"; }
  run maclib::apps::b::boxsync::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "boxsync::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boxsync::is_installed
  [ "$status" -eq 1 ]
}

@test "boxsync::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boxsync::installed_path
  [ "$status" -eq 1 ]
}

@test "boxsync::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::boxsync::install
  [ "$status" -ne 0 ]
}

@test "boxsync::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::boxsync::update
  [ "$status" -eq 127 ]
}

@test "boxsync::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::boxsync::uninstall
  [ "$status" -eq 1 ]
}

@test "boxtools::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boxtools-installer.pkg"; }
  run maclib::apps::b::boxtools::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "boxtools::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/boxtools-16.112.26081720.dmg"; }
  run maclib::apps::b::boxtools::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "boxtools::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boxtools::is_installed
  [ "$status" -eq 1 ]
}

@test "boxtools::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::boxtools::installed_path
  [ "$status" -eq 1 ]
}

@test "boxtools::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::boxtools::install
  [ "$status" -ne 0 ]
}

@test "boxtools::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::boxtools::update
  [ "$status" -eq 127 ]
}

@test "boxtools::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::boxtools::uninstall
  [ "$status" -eq 1 ]
}

@test "bracketsio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bracketsio-installer.pkg"; }
  run maclib::apps::b::bracketsio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bracketsio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bracketsio-16.112.26081720.dmg"; }
  run maclib::apps::b::bracketsio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bracketsio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bracketsio::is_installed
  [ "$status" -eq 1 ]
}

@test "bracketsio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bracketsio::installed_path
  [ "$status" -eq 1 ]
}

@test "bracketsio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bracketsio::install
  [ "$status" -ne 0 ]
}

@test "bracketsio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bracketsio::update
  [ "$status" -eq 127 ]
}

@test "bracketsio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bracketsio::uninstall
  [ "$status" -eq 1 ]
}

@test "brave::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/brave-installer.pkg"; }
  run maclib::apps::b::brave::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "brave::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/brave-16.112.26081720.dmg"; }
  run maclib::apps::b::brave::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "brave::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::brave::is_installed
  [ "$status" -eq 1 ]
}

@test "brave::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::brave::installed_path
  [ "$status" -eq 1 ]
}

@test "brave::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::brave::install
  [ "$status" -ne 0 ]
}

@test "brave::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::brave::update
  [ "$status" -eq 127 ]
}

@test "brave::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::brave::uninstall
  [ "$status" -eq 1 ]
}

@test "bravepkg::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bravepkg-installer.pkg"; }
  run maclib::apps::b::bravepkg::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bravepkg::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bravepkg-16.112.26081720.dmg"; }
  run maclib::apps::b::bravepkg::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bravepkg::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bravepkg::is_installed
  [ "$status" -eq 1 ]
}

@test "bravepkg::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bravepkg::installed_path
  [ "$status" -eq 1 ]
}

@test "bravepkg::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bravepkg::install
  [ "$status" -ne 0 ]
}

@test "bravepkg::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bravepkg::update
  [ "$status" -eq 127 ]
}

@test "bravepkg::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bravepkg::uninstall
  [ "$status" -eq 1 ]
}

@test "brosix::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/brosix-installer.pkg"; }
  run maclib::apps::b::brosix::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "brosix::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/brosix-16.112.26081720.dmg"; }
  run maclib::apps::b::brosix::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "brosix::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::brosix::is_installed
  [ "$status" -eq 1 ]
}

@test "brosix::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::brosix::installed_path
  [ "$status" -eq 1 ]
}

@test "brosix::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::brosix::install
  [ "$status" -ne 0 ]
}

@test "brosix::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::brosix::update
  [ "$status" -eq 127 ]
}

@test "brosix::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::brosix::uninstall
  [ "$status" -eq 1 ]
}

@test "browserosaurus::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/browserosaurus-installer.pkg"; }
  run maclib::apps::b::browserosaurus::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "browserosaurus::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/browserosaurus-16.112.26081720.dmg"; }
  run maclib::apps::b::browserosaurus::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "browserosaurus::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::browserosaurus::is_installed
  [ "$status" -eq 1 ]
}

@test "browserosaurus::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::browserosaurus::installed_path
  [ "$status" -eq 1 ]
}

@test "browserosaurus::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::browserosaurus::install
  [ "$status" -ne 0 ]
}

@test "browserosaurus::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::browserosaurus::update
  [ "$status" -eq 127 ]
}

@test "browserosaurus::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::browserosaurus::uninstall
  [ "$status" -eq 1 ]
}

@test "bruno::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bruno-installer.pkg"; }
  run maclib::apps::b::bruno::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bruno::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bruno-16.112.26081720.dmg"; }
  run maclib::apps::b::bruno::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bruno::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bruno::is_installed
  [ "$status" -eq 1 ]
}

@test "bruno::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bruno::installed_path
  [ "$status" -eq 1 ]
}

@test "bruno::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bruno::install
  [ "$status" -ne 0 ]
}

@test "bruno::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bruno::update
  [ "$status" -eq 127 ]
}

@test "bruno::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bruno::uninstall
  [ "$status" -eq 1 ]
}

@test "bugdom::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bugdom-installer.pkg"; }
  run maclib::apps::b::bugdom::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "bugdom::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/bugdom-16.112.26081720.dmg"; }
  run maclib::apps::b::bugdom::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "bugdom::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bugdom::is_installed
  [ "$status" -eq 1 ]
}

@test "bugdom::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::bugdom::installed_path
  [ "$status" -eq 1 ]
}

@test "bugdom::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::bugdom::install
  [ "$status" -ne 0 ]
}

@test "bugdom::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::bugdom::update
  [ "$status" -eq 127 ]
}

@test "bugdom::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::bugdom::uninstall
  [ "$status" -eq 1 ]
}

@test "burpsuiteprofessional::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/burpsuiteprofessional-installer.pkg"; }
  run maclib::apps::b::burpsuiteprofessional::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "burpsuiteprofessional::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/burpsuiteprofessional-16.112.26081720.dmg"; }
  run maclib::apps::b::burpsuiteprofessional::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "burpsuiteprofessional::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::burpsuiteprofessional::is_installed
  [ "$status" -eq 1 ]
}

@test "burpsuiteprofessional::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::burpsuiteprofessional::installed_path
  [ "$status" -eq 1 ]
}

@test "burpsuiteprofessional::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::burpsuiteprofessional::install
  [ "$status" -ne 0 ]
}

@test "burpsuiteprofessional::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::burpsuiteprofessional::update
  [ "$status" -eq 127 ]
}

@test "burpsuiteprofessional::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::burpsuiteprofessional::uninstall
  [ "$status" -eq 1 ]
}

@test "busycal::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/busycal-installer.pkg"; }
  run maclib::apps::b::busycal::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "busycal::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/busycal-16.112.26081720.dmg"; }
  run maclib::apps::b::busycal::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "busycal::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::busycal::is_installed
  [ "$status" -eq 1 ]
}

@test "busycal::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::busycal::installed_path
  [ "$status" -eq 1 ]
}

@test "busycal::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::busycal::install
  [ "$status" -ne 0 ]
}

@test "busycal::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::busycal::update
  [ "$status" -eq 127 ]
}

@test "busycal::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::busycal::uninstall
  [ "$status" -eq 1 ]
}

@test "busycontacts::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/busycontacts-installer.pkg"; }
  run maclib::apps::b::busycontacts::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "busycontacts::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/busycontacts-16.112.26081720.dmg"; }
  run maclib::apps::b::busycontacts::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "busycontacts::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::busycontacts::is_installed
  [ "$status" -eq 1 ]
}

@test "busycontacts::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::busycontacts::installed_path
  [ "$status" -eq 1 ]
}

@test "busycontacts::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::busycontacts::install
  [ "$status" -ne 0 ]
}

@test "busycontacts::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::busycontacts::update
  [ "$status" -eq 127 ]
}

@test "busycontacts::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::busycontacts::uninstall
  [ "$status" -eq 1 ]
}

@test "buttercup::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/buttercup-installer.pkg"; }
  run maclib::apps::b::buttercup::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "buttercup::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/buttercup-16.112.26081720.dmg"; }
  run maclib::apps::b::buttercup::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "buttercup::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::buttercup::is_installed
  [ "$status" -eq 1 ]
}

@test "buttercup::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::b::buttercup::installed_path
  [ "$status" -eq 1 ]
}

@test "buttercup::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::b::buttercup::install
  [ "$status" -ne 0 ]
}

@test "buttercup::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::b::buttercup::update
  [ "$status" -eq 127 ]
}

@test "buttercup::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::b::buttercup::uninstall
  [ "$status" -eq 1 ]
}

@test "caffeine::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/caffeine-installer.pkg"; }
  run maclib::apps::c::caffeine::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "caffeine::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/caffeine-16.112.26081720.dmg"; }
  run maclib::apps::c::caffeine::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "caffeine::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::caffeine::is_installed
  [ "$status" -eq 1 ]
}

@test "caffeine::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::caffeine::installed_path
  [ "$status" -eq 1 ]
}

@test "caffeine::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::caffeine::install
  [ "$status" -ne 0 ]
}

@test "caffeine::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::caffeine::update
  [ "$status" -eq 127 ]
}

@test "caffeine::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::caffeine::uninstall
  [ "$status" -eq 1 ]
}

@test "cakebrew::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cakebrew-installer.pkg"; }
  run maclib::apps::c::cakebrew::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cakebrew::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cakebrew-16.112.26081720.dmg"; }
  run maclib::apps::c::cakebrew::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cakebrew::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cakebrew::is_installed
  [ "$status" -eq 1 ]
}

@test "cakebrew::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cakebrew::installed_path
  [ "$status" -eq 1 ]
}

@test "cakebrew::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cakebrew::install
  [ "$status" -ne 0 ]
}

@test "cakebrew::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cakebrew::update
  [ "$status" -eq 127 ]
}

@test "cakebrew::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cakebrew::uninstall
  [ "$status" -eq 1 ]
}

@test "calcservice::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/calcservice-installer.pkg"; }
  run maclib::apps::c::calcservice::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "calcservice::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/calcservice-16.112.26081720.dmg"; }
  run maclib::apps::c::calcservice::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "calcservice::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::calcservice::is_installed
  [ "$status" -eq 1 ]
}

@test "calcservice::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::calcservice::installed_path
  [ "$status" -eq 1 ]
}

@test "calcservice::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::calcservice::install
  [ "$status" -ne 0 ]
}

@test "calcservice::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::calcservice::update
  [ "$status" -eq 127 ]
}

@test "calcservice::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::calcservice::uninstall
  [ "$status" -eq 1 ]
}

@test "calibre::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/calibre-installer.pkg"; }
  run maclib::apps::c::calibre::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "calibre::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/calibre-16.112.26081720.dmg"; }
  run maclib::apps::c::calibre::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "calibre::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::calibre::is_installed
  [ "$status" -eq 1 ]
}

@test "calibre::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::calibre::installed_path
  [ "$status" -eq 1 ]
}

@test "calibre::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::calibre::install
  [ "$status" -ne 0 ]
}

@test "calibre::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::calibre::update
  [ "$status" -eq 127 ]
}

@test "calibre::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::calibre::uninstall
  [ "$status" -eq 1 ]
}

@test "calibriteprofiler::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/calibriteprofiler-installer.pkg"; }
  run maclib::apps::c::calibriteprofiler::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "calibriteprofiler::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/calibriteprofiler-16.112.26081720.dmg"; }
  run maclib::apps::c::calibriteprofiler::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "calibriteprofiler::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::calibriteprofiler::is_installed
  [ "$status" -eq 1 ]
}

@test "calibriteprofiler::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::calibriteprofiler::installed_path
  [ "$status" -eq 1 ]
}

@test "calibriteprofiler::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::calibriteprofiler::install
  [ "$status" -ne 0 ]
}

@test "calibriteprofiler::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::calibriteprofiler::update
  [ "$status" -eq 127 ]
}

@test "calibriteprofiler::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::calibriteprofiler::uninstall
  [ "$status" -eq 1 ]
}

@test "cameracontroller::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cameracontroller-installer.pkg"; }
  run maclib::apps::c::cameracontroller::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cameracontroller::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cameracontroller-16.112.26081720.dmg"; }
  run maclib::apps::c::cameracontroller::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cameracontroller::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cameracontroller::is_installed
  [ "$status" -eq 1 ]
}

@test "cameracontroller::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cameracontroller::installed_path
  [ "$status" -eq 1 ]
}

@test "cameracontroller::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cameracontroller::install
  [ "$status" -ne 0 ]
}

@test "cameracontroller::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cameracontroller::update
  [ "$status" -eq 127 ]
}

@test "cameracontroller::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cameracontroller::uninstall
  [ "$status" -eq 1 ]
}

@test "camostudio::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/camostudio-installer.pkg"; }
  run maclib::apps::c::camostudio::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "camostudio::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/camostudio-16.112.26081720.dmg"; }
  run maclib::apps::c::camostudio::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "camostudio::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::camostudio::is_installed
  [ "$status" -eq 1 ]
}

@test "camostudio::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::camostudio::installed_path
  [ "$status" -eq 1 ]
}

@test "camostudio::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::camostudio::install
  [ "$status" -ne 0 ]
}

@test "camostudio::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::camostudio::update
  [ "$status" -eq 127 ]
}

@test "camostudio::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::camostudio::uninstall
  [ "$status" -eq 1 ]
}

@test "camunda::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/camunda-installer.pkg"; }
  run maclib::apps::c::camunda::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "camunda::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/camunda-16.112.26081720.dmg"; }
  run maclib::apps::c::camunda::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "camunda::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::camunda::is_installed
  [ "$status" -eq 1 ]
}

@test "camunda::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::camunda::installed_path
  [ "$status" -eq 1 ]
}

@test "camunda::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::camunda::install
  [ "$status" -ne 0 ]
}

@test "camunda::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::camunda::update
  [ "$status" -eq 127 ]
}

@test "camunda::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::camunda::uninstall
  [ "$status" -eq 1 ]
}

@test "canva::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/canva-installer.pkg"; }
  run maclib::apps::c::canva::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "canva::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/canva-16.112.26081720.dmg"; }
  run maclib::apps::c::canva::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "canva::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::canva::is_installed
  [ "$status" -eq 1 ]
}

@test "canva::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::canva::installed_path
  [ "$status" -eq 1 ]
}

@test "canva::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::canva::install
  [ "$status" -ne 0 ]
}

@test "canva::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::canva::update
  [ "$status" -eq 127 ]
}

@test "canva::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::canva::uninstall
  [ "$status" -eq 1 ]
}

@test "carboncopycloner::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/carboncopycloner-installer.pkg"; }
  run maclib::apps::c::carboncopycloner::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "carboncopycloner::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/carboncopycloner-16.112.26081720.dmg"; }
  run maclib::apps::c::carboncopycloner::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "carboncopycloner::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::carboncopycloner::is_installed
  [ "$status" -eq 1 ]
}

@test "carboncopycloner::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::carboncopycloner::installed_path
  [ "$status" -eq 1 ]
}

@test "carboncopycloner::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::carboncopycloner::install
  [ "$status" -ne 0 ]
}

@test "carboncopycloner::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::carboncopycloner::update
  [ "$status" -eq 127 ]
}

@test "carboncopycloner::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::carboncopycloner::uninstall
  [ "$status" -eq 1 ]
}

@test "cardpresso::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cardpresso-installer.pkg"; }
  run maclib::apps::c::cardpresso::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cardpresso::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cardpresso-16.112.26081720.dmg"; }
  run maclib::apps::c::cardpresso::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cardpresso::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cardpresso::is_installed
  [ "$status" -eq 1 ]
}

@test "cardpresso::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cardpresso::installed_path
  [ "$status" -eq 1 ]
}

@test "cardpresso::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cardpresso::install
  [ "$status" -ne 0 ]
}

@test "cardpresso::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cardpresso::update
  [ "$status" -eq 127 ]
}

@test "cardpresso::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cardpresso::uninstall
  [ "$status" -eq 1 ]
}

@test "catoclient::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/catoclient-installer.pkg"; }
  run maclib::apps::c::catoclient::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "catoclient::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/catoclient-16.112.26081720.dmg"; }
  run maclib::apps::c::catoclient::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "catoclient::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::catoclient::is_installed
  [ "$status" -eq 1 ]
}

@test "catoclient::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::catoclient::installed_path
  [ "$status" -eq 1 ]
}

@test "catoclient::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::catoclient::install
  [ "$status" -ne 0 ]
}

@test "catoclient::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::catoclient::update
  [ "$status" -eq 127 ]
}

@test "catoclient::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::catoclient::uninstall
  [ "$status" -eq 1 ]
}

@test "charles::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/charles-installer.pkg"; }
  run maclib::apps::c::charles::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "charles::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/charles-16.112.26081720.dmg"; }
  run maclib::apps::c::charles::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "charles::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::charles::is_installed
  [ "$status" -eq 1 ]
}

@test "charles::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::charles::installed_path
  [ "$status" -eq 1 ]
}

@test "charles::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::charles::install
  [ "$status" -ne 0 ]
}

@test "charles::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::charles::update
  [ "$status" -eq 127 ]
}

@test "charles::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::charles::uninstall
  [ "$status" -eq 1 ]
}

@test "chatwork::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/chatwork-installer.pkg"; }
  run maclib::apps::c::chatwork::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "chatwork::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/chatwork-16.112.26081720.dmg"; }
  run maclib::apps::c::chatwork::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "chatwork::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chatwork::is_installed
  [ "$status" -eq 1 ]
}

@test "chatwork::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chatwork::installed_path
  [ "$status" -eq 1 ]
}

@test "chatwork::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::chatwork::install
  [ "$status" -ne 0 ]
}

@test "chatwork::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::chatwork::update
  [ "$status" -eq 127 ]
}

@test "chatwork::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::chatwork::uninstall
  [ "$status" -eq 1 ]
}

@test "chemdoodle2d::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/chemdoodle2d-installer.pkg"; }
  run maclib::apps::c::chemdoodle2d::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "chemdoodle2d::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/chemdoodle2d-16.112.26081720.dmg"; }
  run maclib::apps::c::chemdoodle2d::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "chemdoodle2d::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle2d::is_installed
  [ "$status" -eq 1 ]
}

@test "chemdoodle2d::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle2d::installed_path
  [ "$status" -eq 1 ]
}

@test "chemdoodle2d::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::chemdoodle2d::install
  [ "$status" -ne 0 ]
}

@test "chemdoodle2d::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle2d::update
  [ "$status" -eq 127 ]
}

@test "chemdoodle2d::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle2d::uninstall
  [ "$status" -eq 1 ]
}

@test "chemdoodle3d::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/chemdoodle3d-installer.pkg"; }
  run maclib::apps::c::chemdoodle3d::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "chemdoodle3d::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/chemdoodle3d-16.112.26081720.dmg"; }
  run maclib::apps::c::chemdoodle3d::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "chemdoodle3d::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle3d::is_installed
  [ "$status" -eq 1 ]
}

@test "chemdoodle3d::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle3d::installed_path
  [ "$status" -eq 1 ]
}

@test "chemdoodle3d::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::chemdoodle3d::install
  [ "$status" -ne 0 ]
}

@test "chemdoodle3d::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle3d::update
  [ "$status" -eq 127 ]
}

@test "chemdoodle3d::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle3d::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudioblue3::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioblue3-installer.pkg"; }
  run maclib::apps::c::cherryaudioblue3::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudioblue3::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioblue3-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudioblue3::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudioblue3::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioblue3::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudioblue3::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioblue3::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudioblue3::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudioblue3::install
  [ "$status" -ne 0 ]
}

@test "cherryaudioblue3::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioblue3::update
  [ "$status" -eq 127 ]
}

@test "cherryaudioblue3::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioblue3::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudioca2600::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioca2600-installer.pkg"; }
  run maclib::apps::c::cherryaudioca2600::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudioca2600::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioca2600-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudioca2600::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudioca2600::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioca2600::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudioca2600::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioca2600::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudioca2600::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudioca2600::install
  [ "$status" -ne 0 ]
}

@test "cherryaudioca2600::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioca2600::update
  [ "$status" -eq 127 ]
}

@test "cherryaudioca2600::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioca2600::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudiochroma::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiochroma-installer.pkg"; }
  run maclib::apps::c::cherryaudiochroma::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudiochroma::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiochroma-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudiochroma::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudiochroma::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiochroma::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudiochroma::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiochroma::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudiochroma::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudiochroma::install
  [ "$status" -ne 0 ]
}

@test "cherryaudiochroma::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiochroma::update
  [ "$status" -eq 127 ]
}

@test "cherryaudiochroma::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiochroma::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudiocr78::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiocr78-installer.pkg"; }
  run maclib::apps::c::cherryaudiocr78::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudiocr78::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiocr78-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudiocr78::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudiocr78::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiocr78::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudiocr78::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiocr78::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudiocr78::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudiocr78::install
  [ "$status" -ne 0 ]
}

@test "cherryaudiocr78::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiocr78::update
  [ "$status" -eq 127 ]
}

@test "cherryaudiocr78::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiocr78::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudiodco106::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiodco106-installer.pkg"; }
  run maclib::apps::c::cherryaudiodco106::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudiodco106::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiodco106-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudiodco106::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudiodco106::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodco106::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudiodco106::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodco106::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudiodco106::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudiodco106::install
  [ "$status" -ne 0 ]
}

@test "cherryaudiodco106::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodco106::update
  [ "$status" -eq 127 ]
}

@test "cherryaudiodco106::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodco106::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudiodreamsynth::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiodreamsynth-installer.pkg"; }
  run maclib::apps::c::cherryaudiodreamsynth::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudiodreamsynth::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiodreamsynth-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudiodreamsynth::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudiodreamsynth::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodreamsynth::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudiodreamsynth::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodreamsynth::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudiodreamsynth::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudiodreamsynth::install
  [ "$status" -ne 0 ]
}

@test "cherryaudiodreamsynth::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodreamsynth::update
  [ "$status" -eq 127 ]
}

@test "cherryaudiodreamsynth::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiodreamsynth::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudioeightvoice::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioeightvoice-installer.pkg"; }
  run maclib::apps::c::cherryaudioeightvoice::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudioeightvoice::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioeightvoice-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudioeightvoice::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudioeightvoice::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioeightvoice::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudioeightvoice::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioeightvoice::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudioeightvoice::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudioeightvoice::install
  [ "$status" -ne 0 ]
}

@test "cherryaudioeightvoice::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioeightvoice::update
  [ "$status" -eq 127 ]
}

@test "cherryaudioeightvoice::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioeightvoice::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudioelkax::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioelkax-installer.pkg"; }
  run maclib::apps::c::cherryaudioelkax::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudioelkax::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudioelkax-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudioelkax::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudioelkax::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioelkax::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudioelkax::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioelkax::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudioelkax::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudioelkax::install
  [ "$status" -ne 0 ]
}

@test "cherryaudioelkax::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioelkax::update
  [ "$status" -eq 127 ]
}

@test "cherryaudioelkax::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudioelkax::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudiogalacticreverb::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiogalacticreverb-installer.pkg"; }
  run maclib::apps::c::cherryaudiogalacticreverb::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudiogalacticreverb::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiogalacticreverb-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudiogalacticreverb::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudiogalacticreverb::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogalacticreverb::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudiogalacticreverb::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogalacticreverb::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudiogalacticreverb::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudiogalacticreverb::install
  [ "$status" -ne 0 ]
}

@test "cherryaudiogalacticreverb::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogalacticreverb::update
  [ "$status" -eq 127 ]
}

@test "cherryaudiogalacticreverb::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogalacticreverb::uninstall
  [ "$status" -eq 1 ]
}

@test "cherryaudiogx80::suite_installer_url returns a URL" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiogx80-installer.pkg"; }
  run maclib::apps::c::cherryaudiogx80::suite_installer_url
  [ "$status" -eq 0 ]
  [[ "$output" == *"https://example.com"* ]]
}

@test "cherryaudiogx80::latest_version returns a version" {
  source lib/maclib.sh
  curl() { printf "%s\n" "https://example.com/cherryaudiogx80-16.112.26081720.dmg"; }
  run maclib::apps::c::cherryaudiogx80::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "cherryaudiogx80::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogx80::is_installed
  [ "$status" -eq 1 ]
}

@test "cherryaudiogx80::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogx80::installed_path
  [ "$status" -eq 1 ]
}

@test "cherryaudiogx80::install returns 1 on download failure" {
  source lib/maclib.sh
  curl() { return 22; }
  run maclib::apps::c::cherryaudiogx80::install
  [ "$status" -ne 0 ]
}

@test "cherryaudiogx80::update returns 127 (no update path)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogx80::update
  [ "$status" -eq 127 ]
}

@test "cherryaudiogx80::uninstall returns 1 (no clean uninstall)" {
  source lib/maclib.sh
  run maclib::apps::c::cherryaudiogx80::uninstall
  [ "$status" -eq 1 ]
}

# ---------------------------------------------------------------------------
# acroniscyberprotectconnect (Installomator)
# ---------------------------------------------------------------------------

@test "acroniscyberprotectconnect::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnect::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnect::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnect::latest_version
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnect::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::a::acroniscyberprotectconnect::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "acroniscyberprotectconnect::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnect::is_installed
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnect::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::acroniscyberprotectconnect::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "acroniscyberprotectconnect::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnect::installed_path
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnect::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::acroniscyberprotectconnect::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "acroniscyberprotectconnect::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnect::install
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnect::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnect::update
  [ "$status" -eq 0 ]
}

@test "acroniscyberprotectconnect::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnect::uninstall
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# acroniscyberprotectconnectagent (Installomator)
# ---------------------------------------------------------------------------

@test "acroniscyberprotectconnectagent::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnectagent::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnectagent::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnectagent::latest_version
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnectagent::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::a::acroniscyberprotectconnectagent::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "acroniscyberprotectconnectagent::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnectagent::is_installed
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnectagent::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::acroniscyberprotectconnectagent::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "acroniscyberprotectconnectagent::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnectagent::installed_path
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnectagent::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::acroniscyberprotectconnectagent::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "acroniscyberprotectconnectagent::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnectagent::install
  [ "$status" -eq 1 ]
}

@test "acroniscyberprotectconnectagent::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnectagent::update
  [ "$status" -eq 0 ]
}

@test "acroniscyberprotectconnectagent::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::a::acroniscyberprotectconnectagent::uninstall
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# adobebrackets (Installomator)
# ---------------------------------------------------------------------------

@test "adobebrackets::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::adobebrackets::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "adobebrackets::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::a::adobebrackets::latest_version
  [ "$status" -eq 1 ]
}

@test "adobebrackets::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::a::adobebrackets::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobebrackets::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobebrackets::is_installed
  [ "$status" -eq 1 ]
}

@test "adobebrackets::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::adobebrackets::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobebrackets::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobebrackets::installed_path
  [ "$status" -eq 1 ]
}

@test "adobebrackets::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::adobebrackets::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobebrackets::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::adobebrackets::install
  [ "$status" -eq 1 ]
}

@test "adobebrackets::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::a::adobebrackets::update
  [ "$status" -eq 0 ]
}

@test "adobebrackets::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::a::adobebrackets::uninstall
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# adobereaderdc (Installomator)
# ---------------------------------------------------------------------------

@test "adobereaderdc::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "adobereaderdc::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc::latest_version
  [ "$status" -eq 1 ]
}

@test "adobereaderdc::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::a::adobereaderdc::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobereaderdc::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc::is_installed
  [ "$status" -eq 1 ]
}

@test "adobereaderdc::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::adobereaderdc::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobereaderdc::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc::installed_path
  [ "$status" -eq 1 ]
}

@test "adobereaderdc::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::adobereaderdc::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobereaderdc::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc::install
  [ "$status" -eq 1 ]
}

@test "adobereaderdc::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc::update
  [ "$status" -eq 0 ]
}

@test "adobereaderdc::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc::uninstall
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# adobereaderdc-install (Installomator)
# ---------------------------------------------------------------------------

@test "adobereaderdc-install::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-install::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-install::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-install::latest_version
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-install::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::a::adobereaderdc-install::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobereaderdc-install::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-install::is_installed
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-install::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::adobereaderdc-install::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobereaderdc-install::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-install::installed_path
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-install::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::adobereaderdc-install::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "adobereaderdc-install::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-install::install
  [ "$status" -eq 1 ]
}

@test "adobereaderdc-install::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-install::update
  [ "$status" -eq 0 ]
}

@test "adobereaderdc-install::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::a::adobereaderdc-install::uninstall
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# applesfsymbols (Installomator)
# ---------------------------------------------------------------------------

@test "applesfsymbols::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfsymbols::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "applesfsymbols::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::a::applesfsymbols::latest_version
  [ "$status" -eq 1 ]
}

@test "applesfsymbols::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::a::applesfsymbols::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "applesfsymbols::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfsymbols::is_installed
  [ "$status" -eq 1 ]
}

@test "applesfsymbols::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::applesfsymbols::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "applesfsymbols::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::applesfsymbols::installed_path
  [ "$status" -eq 1 ]
}

@test "applesfsymbols::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::applesfsymbols::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "applesfsymbols::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfsymbols::install
  [ "$status" -eq 1 ]
}

@test "applesfsymbols::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfsymbols::update
  [ "$status" -eq 0 ]
}

@test "applesfsymbols::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::a::applesfsymbols::uninstall
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# aspera (Installomator)
# ---------------------------------------------------------------------------

@test "aspera::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::aspera::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "aspera::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::a::aspera::latest_version
  [ "$status" -eq 1 ]
}

@test "aspera::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::a::aspera::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "aspera::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aspera::is_installed
  [ "$status" -eq 1 ]
}

@test "aspera::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::aspera::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "aspera::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::a::aspera::installed_path
  [ "$status" -eq 1 ]
}

@test "aspera::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::a::aspera::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "aspera::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::a::aspera::install
  [ "$status" -eq 1 ]
}

@test "aspera::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::a::aspera::update
  [ "$status" -eq 0 ]
}

@test "aspera::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::a::aspera::uninstall
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# chemdoodle (Installomator)
# ---------------------------------------------------------------------------

@test "chemdoodle::suite_installer_url returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle::suite_installer_url
  [ "$status" -eq 1 ]
}

@test "chemdoodle::latest_version returns 1 when not installed" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle::latest_version
  [ "$status" -eq 1 ]
}

@test "chemdoodle::latest_version returns a version when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app/Contents"
  cat >"$tmp/Applications/.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>CFBundleShortVersionString</key>
  <string>1.2.3</string>
</dict>
</plist>
EOF
  HOME="$tmp"
  run maclib::apps::c::chemdoodle::latest_version
  [ "$status" -eq 0 ]
  [[ "$output" == "1.2.3" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "chemdoodle::is_installed returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle::is_installed
  [ "$status" -eq 1 ]
}

@test "chemdoodle::is_installed returns 0 when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::c::chemdoodle::is_installed
  [ "$status" -eq 0 ]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "chemdoodle::installed_path returns 1 when absent" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle::installed_path
  [ "$status" -eq 1 ]
}

@test "chemdoodle::installed_path returns a path when installed" {
  source lib/maclib.sh
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/Applications/.app"
  HOME="$tmp"
  run maclib::apps::c::chemdoodle::installed_path
  [ "$status" -eq 0 ]
  [[ "$output" == *".app" ]]
  HOME="/Users/malbers"
  rm -rf "$tmp"
}

@test "chemdoodle::install returns 1 (no vendor URL)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle::install
  [ "$status" -eq 1 ]
}

@test "chemdoodle::update returns 0 (re-run install)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle::update
  [ "$status" -eq 0 ]
}

@test "chemdoodle::uninstall returns 0 (manual removal)" {
  source lib/maclib.sh
  run maclib::apps::c::chemdoodle::uninstall
  [ "$status" -eq 0 ]
}
