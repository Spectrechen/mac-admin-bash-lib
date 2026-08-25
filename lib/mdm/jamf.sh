#!/usr/bin/env bash
# jamf.sh - macOS inventory helpers for Jamf Extension Attributes (EAs).
#
# Jamf parses the <result>...</result> XML wrapper around a helper's stdout, so
# every helper below prints its value between <result> and </result>. Anything
# written to stderr is ignored by Jamf (and satisfies the library's
# stdout=data / stderr=logs convention). Each helper returns a shell exit
# status mirroring the value's validity: 0 = value present/valid, non-zero =
# absent/error.
#
# Reference: palantir/jamf-pro-scripts extension-attributes/ (Apache-2.0).
# Tools are invoked by plain name (as lib/security.sh does) so the helpers stay
# testable — bats mocks external macOS binaries as shell functions.
#
# Namespace: maclib::jamf::<name>(). See docs/jamf-ea-integration-specs.md.

# ---------------------------------------------------------------------------
# Tier 1 — integrate first (clearly worth, robust, low-risk)
# ---------------------------------------------------------------------------

# Print the integer battery cycle count. Batteryless desktops (e.g. Mac mini)
# have no "Battery Information" block, so this returns 0 with <result>0</result>
# rather than failing under pipefail. Needs bc (ships with macOS).
maclib::jamf::battery_cycle_count() {
  local powerReport cycleCount
  powerReport="$(system_profiler SPPowerDataType 2>/dev/null)" || true
  if printf '%s' "$powerReport" | grep -q "Battery Information"; then
    cycleCount="$(printf '%s' "$powerReport" | awk '/Cycle Count/ {print $NF}' | bc)"
  else
    cycleCount=0
  fi
  printf '<result>%s</result>\n' "$cycleCount"
}

# Print the battery charge percentage (0-100). Empty on batteryless / always-AC
# machines (e.g. "Now drawing from 'AC Power'" has no percentage). Needs bc.
maclib::jamf::battery_charge_percent() {
  local charge
  # Realistic output is like "Drawing from 'Battery' - 85%"; the percentage is
  # the last field. The spec's `awk '/%/ {print $3}'` extracts field 3 ("Battery")
  # and is therefore buggy — use $NF instead.
  charge="$(pmset -g batt 2>/dev/null | awk '/%/ {print $NF}' | tr -d '%;' | bc)" || true
  printf '<result>%s</result>\n' "$charge"
}

# Print the Apple Security Chip / T2 model identifier (e.g. Mac16,11).
#
# FIX: palantir greps "/Model Name/" but SPiBridgeDataType prints
# "Model Identifier: Mac16,11" — the original matches nothing on every Apple
# Silicon Mac. We parse the Model Identifier column instead.
maclib::jamf::security_chip() {
  local chip
  chip="$(system_profiler SPiBridgeDataType 2>/dev/null | awk -F': ' '/Model Identifier/ {print $NF}')" || true
  printf '<result>%s</result>\n' "$chip"
}

# Print a newline-separated list of third-party kernel extension load
# identifiers (empty when none loaded). Requires kmutil (macOS 12.3+).
maclib::jamf::third_party_kexts() {
  kmutil showloaded --list-only 2>/dev/null | grep -v 'com.apple' | awk '{print $6}' | sort
}

# Print a newline-separated list of enabled system extensions (bundle IDs).
#
# FIX: palantir's `awk '/ enabled/ {print $4}'` matches nothing — the
# systemextensionsctl list is a tab-separated table whose data rows begin with
# empty columns. Skip the header lines, then extract the bundle-ID column with
# a regex rather than a fixed field position.
maclib::jamf::system_extensions() {
  systemextensionsctl list 2>/dev/null | tail -n +3 \
    | grep -oE 'com\.[A-Za-z0-9._]+ \([0-9]' \
    | sed -E 's/ \([0-9].*$//' \
    | sort -u
}

# Print seconds since last boot (integer). Trivial and robust.
maclib::jamf::uptime_seconds() {
  local currentDate bootDate uptime
  currentDate="$(date +%s)"
  bootDate="$(sysctl -n kern.boottime 2>/dev/null | awk -F'[ ,]' '{print $4}')"
  uptime=$((currentDate - bootDate))
  printf '<result>%s</result>\n' "$uptime"
}

# Print the Xcode Command Line Tools state: "Bundled with Xcode", "Standalone",
# or empty (not installed / other install method such as Xcode-beta).
#
# FIX: handle the Xcode-beta path ("/Applications/Xcode-beta.app/Contents/Developer")
# that palantir's two-case check missed (it returned empty for that case).
maclib::jamf::xcode_clt_state() {
  local xcodeAppPath xcodeCLTPath xcodeBetaPath xcodeCheck xcodeCLTCheck
  xcodeAppPath="/Applications/Xcode.app/Contents/Developer"
  xcodeCLTPath="/Library/Developer/CommandLineTools"
  xcodeBetaPath="/Applications/Xcode-beta.app/Contents/Developer"
  xcodeCheck="$(xcode-select --print-path 2>&1)"
  if [ "$xcodeCheck" = "$xcodeAppPath" ] && [ -e "$xcodeAppPath" ]; then
    xcodeCLTCheck="Bundled with Xcode"
  elif [ "$xcodeCheck" = "$xcodeCLTPath" ] && [ -e "$xcodeCLTPath" ]; then
    xcodeCLTCheck="Standalone"
  elif [ "$xcodeCheck" = "$xcodeBetaPath" ] && [ -e "$xcodeBetaPath" ]; then
    xcodeCLTCheck="Bundled with Xcode-beta"
  fi
  printf '<result>%s</result>\n' "$xcodeCLTCheck"
}

# Print the name of the startup / boot volume (e.g. "Macintosh HD"). Trivial.
maclib::jamf::startup_volume_name() {
  diskutil info -plist "$(bless --getBoot 2>/dev/null)" 2>/dev/null \
    | plutil -extract VolumeName raw -- -
}

# ---------------------------------------------------------------------------
# Tier 2 — marginal, integrate if capacity
# ---------------------------------------------------------------------------

# Print the power adapter wattage (empty when no adapter / batteryless). Only
# meaningful when a power adapter is attached to a battery device.
maclib::jamf::charger_wattage() {
  local wattage
  wattage="$(system_profiler SPPowerDataType 2>/dev/null | awk '/Wattage/ {print $NF}')" || true
  # SPPowerDataType prints "Wattage: 96W"; keep only the digits.
  wattage="$(printf '%s' "$wattage" | tr -cd '0-9')" || true
  printf '<result>%s</result>\n' "$wattage"
}

# Print "Enabled" when Time Machine auto-backup is configured, else empty.
maclib::jamf::time_machine_autobackup() {
  local timeMachineAutoBackup timeMachineStatus
  timeMachineAutoBackup="$(defaults read "/Library/Preferences/com.apple.TimeMachine.plist" AutoBackup 2>/dev/null)"
  if [ "$timeMachineAutoBackup" = "1" ]; then
    timeMachineStatus="Enabled"
  else
    timeMachineStatus=""
  fi
  printf '<result>%s</result>\n' "$timeMachineStatus"
}

# ---------------------------------------------------------------------------
# Tier 3 — buggy / skip / defer (documented)
# ---------------------------------------------------------------------------

# SKIPPED: firmware_password_state.
#
# palantir's `grep -q "i386"` guard only runs on Intel; on all Apple Silicon
# Macs (arch -> arm64) the block is skipped, so the helper always prints empty
# (a false "no password" result) on the majority of modern fleet hardware.
# Worse, `firmwarepasswd -check` requires root and errors out otherwise.
# Firmware password is of declining relevance on T2 / Security-Chip Macs
# (replaced by the Security Chip EA). Recommend skipping entirely. If a distinct
# reading is ever wanted, parse `firmwarepasswd -check` output (Enabled/No)
# directly without the arch guard, and only from within a root Jamf EA.

# SKIPPED: remote_login_state.
#
# Partial duplicate of maclib::security::is_ssh_disabled. `systemsetup
# -getremotelogin` requires root and prints an error string when run without
# it (fragile against awk parsing). Given the security module already covers
# SSH state, this EA is only worth it for a distinct "Remote Login toggle"
# reading — deferred as marginal.

# IMPLEMENTED WITH FIX: homebrew_outdated_formulae.
#
# palantir used `sudo -u <user> brew outdated ...`, which is fragile in an EA
# because it does not inherit the logged-in user's environment (Homebrew's
# HOMEBREW_USER / shell). The modern replacement is `launchctl asuser <uid>`.
# Computes the console UID via `stat -f%u /dev/console`, then runs brew
# under that user's context. Prints a newline-separated list of outdated
# formula names (empty when none). The brew binary path is overridable via
# $MACLIB_BREW_BIN (useful for MDM deployments / tests); it defaults to the
# arch-aware Homebrew prefix.
maclib::jamf::homebrew_outdated_formulae() {
  local architectureCheck brewPrefix brewPath brew_bin uid
  architectureCheck="$(arch)"
  if [ "$architectureCheck" = "arm64" ]; then
    brewPrefix="/opt/homebrew/bin"
  else
    brewPrefix="/usr/local/bin"
  fi
  brewPath="${brewPrefix}/brew"
  brew_bin="${MACLIB_BREW_BIN:-$brewPath}"
  # launchctl asuser needs the console user's numeric UID (stat -f%u).
  uid="$(stat -f%u "/dev/console" 2>/dev/null)" || return 1
  launchctl asuser "$uid" "$brew_bin" outdated --formula --quiet 2>/dev/null || true
}
