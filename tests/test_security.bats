#!/usr/bin/env bats
# Tests for the security-compliance behaviors integrated from community scripts:
#   - lib/security.sh (CIS-style audit + remediate framework, Gatekeeper, Firewall, SSH)
#   - lib/filevault.sh (recovery-key escrow status, flag for regeneration)
#   - lib/packages.sh (label-based version detect/verify)
#   - lib/system.sh (major macOS update detection)
#
# macOS binaries (spctl, firewall, launchctl, diskutil, softwareupdate, PlistBuddy)
# are mocked as shell functions, exactly like the office/chrome tests mock curl.

setup() {
  source "${BATS_TEST_DIRNAME}/../lib/maclib.sh"
}

# ---------------------------------------------------------------------------
# security module: audit framework counters
# ---------------------------------------------------------------------------

# NOTE: the audit counters live in the calling shell, so they must be exercised
# with direct calls (not `run`, which runs in a subshell and cannot mutate the
# parent shell's counters). Output is captured to a variable where needed.

@test "security::reset zeroes all counters" {
  __MACLIB_SECURITY_PASS=5
  __MACLIB_SECURITY_FAIL=3
  __MACLIB_SECURITY_WARN=2
  maclib::security::reset
  maclib::security::pass "test control"
  [ "$__MACLIB_SECURITY_PASS" -eq 1 ]
  [ "$__MACLIB_SECURITY_FAIL" -eq 0 ]
}

@test "security::fail increments FAIL_COUNT and prints to stderr" {
  maclib::security::reset
  # Call fail directly (NOT inside command substitution, which would run in a
  # subshell and drop the counter increment). Capture stderr to a temp file so
  # the counter increment persists in the current shell.
  local errfile err
  errfile="$(mktemp)"
  maclib::security::fail "bad control" 2>"$errfile"
  err="$(cat "$errfile")"
  rm -f "$errfile"
  [ "$__MACLIB_SECURITY_FAIL" -eq 1 ]
  [[ "$err" == *"FAIL: bad control"* ]]
}

@test "security::report returns non-zero when a control failed" {
  maclib::security::reset
  maclib::security::pass "ok"
  maclib::security::fail "bad"
  local out rc
  # Capture the summary output via command substitution. report() returns
  # non-zero when a control failed, so append `|| true` to avoid failing the
  # test on that exit code (the output is still captured).
  out="$(maclib::security::report 2>&1)" || true
  # Capture the return code WITHOUT letting the non-zero exit fail the test:
  # `report` returns non-zero when a control failed, so wrap it in an `if`.
  if maclib::security::report >/dev/null 2>&1; then
    rc=0
  else
    rc=1
  fi
  [ "$rc" -ne 0 ]
  [[ "$out" == *"failed"* ]]
  [[ "$out" == *"passed"* ]]
}

@test "security::report returns 0 when no control failed" {
  maclib::security::reset
  maclib::security::pass "ok1"
  maclib::security::pass "ok2"
  local out
  out="$(maclib::security::report)"
  [ "$?" -eq 0 ]
  [[ "$out" == *"2 passed"* ]]
  [[ "$out" == *"0 failed"* ]]
}

# ---------------------------------------------------------------------------
# security module: Gatekeeper (spctl)
# ---------------------------------------------------------------------------

@test "security::gatekeeper_state parses 'assessments enabled' -> enabled" {
  spctl() { echo "assessments enabled"; }
  run maclib::security::gatekeeper_state
  [ "$status" -eq 0 ]
  [ "$output" == "enabled" ]
}

@test "security::gatekeeper_state parses disabled -> disabled" {
  spctl() { echo "assessments disabled"; }
  run maclib::security::gatekeeper_state
  [ "$output" == "disabled" ]
}

@test "security::is_gatekeeper_enforced returns 0 when enforced" {
  spctl() { echo "assessments enabled"; }
  run maclib::security::is_gatekeeper_enforced
  [ "$status" -eq 0 ]
}

@test "security::is_gatekeeper_enforced returns 1 when not enforced" {
  spctl() { echo "assessments disabled"; }
  run maclib::security::is_gatekeeper_enforced
  [ "$status" -ne 0 ]
}

@test "security::gatekeeper_state returns 127 when spctl is absent" {
  spctl() { return 127; }
  run -127 maclib::security::gatekeeper_state
}

@test "security::remediate_gatekeeper calls spctl --master enable" {
  spctl() { echo "ARGS:$*"; }
  run maclib::security::remediate_gatekeeper
  [[ "$output" == *"--master enable"* ]]
}

# ---------------------------------------------------------------------------
# security module: Application Firewall (firewall)
# ---------------------------------------------------------------------------

@test "security::firewall_state returns 'On' when firewall binary present" {
  firewall() { echo "On"; }
  run maclib::security::firewall_state
  [ "$status" -eq 0 ]
  [ "$output" == "On" ]
}

@test "security::is_application_firewall_enabled returns 0 when On" {
  firewall() { echo "On"; }
  run maclib::security::is_application_firewall_enabled
  [ "$status" -eq 0 ]
}

@test "security::is_application_firewall_enabled returns 1 when Off" {
  firewall() { echo "Off"; }
  run maclib::security::is_application_firewall_enabled
  [ "$status" -ne 0 ]
}

@test "security::firewall_state returns 127 when firewall binary absent" {
  # No firewall() function defined; the real binary is absent on this box.
  run -127 maclib::security::firewall_state
}

# ---------------------------------------------------------------------------
# security module: SSH daemon (launchctl)
# ---------------------------------------------------------------------------

@test "security::is_ssh_disabled returns 1 when sshd active" {
  launchctl() {
    if [[ "$*" == *"com.openssh.sshd"* ]]; then
      echo '"state" : "active"'
    fi
  }
  run maclib::security::is_ssh_disabled
  [ "$status" -ne 0 ]
}

@test "security::is_ssh_disabled returns 0 when sshd stopped" {
  launchctl() {
    if [[ "$*" == *"com.openssh.sshd"* ]]; then
      echo '"state" : "stopped"'
    fi
  }
  run maclib::security::is_ssh_disabled
  [ "$status" -eq 0 ]
}

@test "security::is_ssh_disabled returns 0 when sshd service absent" {
  launchctl() { return 127; }
  run maclib::security::is_ssh_disabled
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# security module: full audit run
# ---------------------------------------------------------------------------

@test "security::audit passes all when Gatekeeper on, firewall on, ssh off" {
  spctl() { echo "assessments enabled"; }
  firewall() { echo "On"; }
  launchctl() {
    if [[ "$*" == *"com.openssh.sshd"* ]]; then
      echo '"state" : "stopped"'
    fi
  }
  run maclib::security::audit
  [ "$status" -eq 0 ]
  [[ "$output" == *"0 failed"* ]]
}

# ---------------------------------------------------------------------------
# filevault module: recovery-key escrow status
# ---------------------------------------------------------------------------

@test "filevault::escrowed_key_status parses 'Recovery Key Escrowed: Yes' -> yes" {
  diskutil() { echo "Recovery Key Escrowed: Yes"; }
  run maclib::filevault::escrowed_key_status
  [ "$output" == "yes" ]
}

@test "filevault::escrowed_key_status parses 'No' -> no" {
  diskutil() { echo "Recovery Key Escrowed: No"; }
  run maclib::filevault::escrowed_key_status
  [ "$output" == "no" ]
}

@test "filevault::escrowed_key_status -> not-applicable when no escrow line" {
  diskutil() { echo "Volume disk3s2 not present"; }
  run maclib::filevault::escrowed_key_status
  [ "$output" == "not-applicable" ]
}

@test "filevault::escrowed_key_status returns 127 when diskutil absent" {
  diskutil() { return 127; }
  run -127 maclib::filevault::escrowed_key_status
}

@test "filevault::flag_new_key_for_escrow returns 127 when not encrypted" {
  diskutil() { echo "Volume disk3s2 not encrypted"; }
  run -127 maclib::filevault::flag_new_key_for_escrow
}

# ---------------------------------------------------------------------------
# packages module: label-based version detection / verify
# ---------------------------------------------------------------------------

# Helper: create a fake app bundle directory at <bundle>.app/Contents/Info.plist
# and point maclib::app::path at it (so the -f "<path>/Contents/Info.plist" guard
# in label_detect_version passes). First argument is the bundle name, second is
# the plist content.
__make_bundle() {
  local bundle="${1:-Finder}" root
  root="$(mktemp -d)/${bundle}.app"
  mkdir -p "$root/Contents"
  printf '%s\n' "$2" >"$root/Contents/Info.plist"
  # Return the bundle root; label_detect_version appends /Contents/Info.plist.
  printf '%s\n' "$root"
}

@test "packages::label_detect_version reads CFBundleShortVersionString" {
  local dir
  dir="$(__make_bundle Finder 'CFBundleShortVersionString = "27.0";')"
  maclib::app::path() { printf '%s\n' "$dir"; }
  PlistBuddy() { echo "27.0"; }
  run maclib::packages::label_detect_version Finder
  [ "$status" -eq 0 ]
  [ "$output" == "27.0" ]
  rm -rf "${dir%/*}"
}

@test "packages::label_detect_version returns empty for absent bundle" {
  run maclib::packages::label_detect_version NonexistentApp
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "packages::label_detect_version returns 2 when no bundle name" {
  run maclib::packages::label_detect_version
  [ "$status" -eq 2 ]
}

@test "packages::label_verify_installed returns 0 when installed" {
  local dir
  dir="$(__make_bundle Finder 'x')"
  maclib::app::path() { printf '%s\n' "$dir"; }
  run maclib::packages::label_verify_installed Finder
  [ "$status" -eq 0 ]
  rm -rf "${dir%/*}"
}

@test "packages::label_verify_installed returns 1 when not installed" {
  maclib::app::path() { return 1; }
  run maclib::packages::label_verify_installed NonexistentApp
  [ "$status" -ne 0 ]
}

@test "packages::verify_after_install returns 1 when installed build older than expected" {
  local dir
  dir="$(__make_bundle Finder 'x')"
  maclib::app::path() { printf '%s\n' "$dir"; }
  PlistBuddy() { echo "26.0"; }
  run maclib::packages::verify_after_install Finder 27.0
  [ "$status" -ne 0 ]
  rm -rf "${dir%/*}"
}

@test "packages::verify_after_install returns 0 when installed build >= expected" {
  local dir
  dir="$(__make_bundle Finder 'x')"
  maclib::app::path() { printf '%s\n' "$dir"; }
  PlistBuddy() { echo "27.0"; }
  run maclib::packages::verify_after_install Finder 26.0
  [ "$status" -eq 0 ]
  rm -rf "${dir%/*}"
}

@test "packages::_version_ge returns 0 when v1 > v2" {
  run maclib::packages::_version_ge 15.0 14.4.1
  [ "$status" -eq 0 ]
}

@test "packages::_version_ge returns 1 when v1 < v2" {
  run maclib::packages::_version_ge 14.4.1 15.0
  [ "$status" -ne 0 ]
}

@test "packages::_version_ge returns 0 when equal" {
  run maclib::packages::_version_ge 14.4.1 14.4.1
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# system module: major macOS update detection
# ---------------------------------------------------------------------------

@test "system::latest_os_version parses highest major.minor from softwareupdate --list" {
  softwareupdate() {
    echo "No new software available."
    echo "Software Update Tool"
    echo ""
    echo "Finding available software"
    echo "The following information about available updates is not yet available:"
    echo "    macOS macOS 15.0:"
    echo "        24A342"
  }
  run maclib::system::latest_os_version
  [ "$status" -eq 0 ]
  [ "$output" == "15.0" ]
}

@test "system::latest_os_version returns 1 when no update available" {
  softwareupdate() { echo "No new software available."; }
  run maclib::system::latest_os_version
  [ "$status" -ne 0 ]
}

@test "system::os_major_update_available prints newer major version" {
  # Compute the next major from the *current* OS so the test is robust to the
  # host's macOS version. The mock then advertises exactly next_major.0.
  local cur_major next_major
  cur_major="$(maclib::os::major_minor | cut -d. -f1)"
  next_major=$((cur_major + 1))
  softwareupdate() {
    echo "No new software available."
    echo "Software Update Tool"
    echo ""
    echo "Finding available software"
    echo "    macOS macOS ${next_major}.0:"
    echo "        25A001"
  }
  # Capture via command substitution (the function prints the version and
  # returns 0 on success). `run` is avoided here because it enables errexit in
  # its subshell, which trips the wrapper's internal `|| return` lines.
  local out
  out="$(maclib::system::os_major_update_available)"
  [[ "$out" == "${next_major}."* ]]
}

@test "system::os_major_update_available returns 1 when no major update" {
  softwareupdate() { echo "No new software available."; }
  run maclib::system::os_major_update_available
  [ "$status" -ne 0 ]
}
