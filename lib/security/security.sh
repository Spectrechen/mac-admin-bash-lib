#!/usr/bin/env bash
# security.sh - macOS security-compliance helpers (CIS-style audit + remediate)
#
# Provides a small audit/remediate framework mirroring the CIS hardening-script
# pattern (pass/fail/warn counters + a final compliance report) and a set of
# discrete controls: Gatekeeper, Application Firewall, SSH. Each control has an
# audit-only function plus (where safe) a remediate_* helper.
#
# Reference: akshaymahaldar/macos-cis-benchmark-hardening (macos_cis_hardening.sh).
# These helpers use only macOS system tools (spctl, firewall, launchctl).

# ---------------------------------------------------------------------------
# Audit framework (shared counters). Reset with maclib::security::reset().
# ---------------------------------------------------------------------------

# Number of controls that currently pass.
__MACLIB_SECURITY_PASS=0
# Number of controls that fail.
__MACLIB_SECURITY_FAIL=0
# Number of controls that produced a warning.
__MACLIB_SECURITY_WARN=0

# Reset the audit counters to zero. Call at the start of each audit run.
maclib::security::reset() {
  __MACLIB_SECURITY_PASS=0
  __MACLIB_SECURITY_FAIL=0
  __MACLIB_SECURITY_WARN=0
}

# Record a passing control (increments PASS_COUNT) and print "PASS: <msg>".
maclib::security::pass() {
  __MACLIB_SECURITY_PASS=$((__MACLIB_SECURITY_PASS + 1))
  printf 'PASS: %s\n' "$*"
}

# Record a failing control (increments FAIL_COUNT) and print "FAIL: <msg>" to stderr.
maclib::security::fail() {
  __MACLIB_SECURITY_FAIL=$((__MACLIB_SECURITY_FAIL + 1))
  printf 'FAIL: %s\n' "$*" >&2
}

# Record a warning control (increments WARN_COUNT) and print "WARN: <msg>" to stderr.
maclib::security::warn() {
  __MACLIB_SECURITY_WARN=$((__MACLIB_SECURITY_WARN + 1))
  printf 'WARN: %s\n' "$*" >&2
}

# Print a compliance summary and return 0 only if no control failed.
# Usage: maclib::security::report
maclib::security::report() {
  printf 'Security audit: %d passed, %d failed, %d warning(s)\n' \
    "$__MACLIB_SECURITY_PASS" "$__MACLIB_SECURITY_FAIL" "$__MACLIB_SECURITY_WARN"
  ((__MACLIB_SECURITY_FAIL == 0))
}

# ---------------------------------------------------------------------------
# Gatekeeper (spctl)
# ---------------------------------------------------------------------------

# Print the current Gatekeeper enforcement state: "enabled", "disabled" or
# "unknown". Parses the output of `spctl --status` (e.g. "assessments enabled").
# Returns non-zero when spctl is unavailable.
maclib::security::gatekeeper_state() {
  local out low
  out="$(spctl --status 2>/dev/null)" || return $?
  [[ -n "$out" ]] || return 1
  # bash 3.2 lacks ${var,,}; lowercase via tr for the comparison.
  low="$(printf '%s' "$out" | tr '[:upper:]' '[:lower:]')"
  case "$low" in
    *"enabled"*) printf 'enabled\n' ;;
    *"disabled"*) printf 'disabled\n' ;;
    *) printf 'unknown\n' ;;
  esac
}

# Return 0 if Gatekeeper (System-Wide Applications) is enforcing.
maclib::security::is_gatekeeper_enforced() {
  [[ "$(maclib::security::gatekeeper_state)" == "enabled" ]]
}

# Enable Gatekeeper enforcement (requires root): spctl --master enable.
# Usage: maclib::security::remediate_gatekeeper [spctl options...]
maclib::security::remediate_gatekeeper() {
  spctl --master enable "$@"
}

# ---------------------------------------------------------------------------
# Application Firewall (firewall)
# ---------------------------------------------------------------------------

# Print the Application Firewall state: "On" or "Off". Returns non-zero when
# the firewall binary is unavailable (common on older macOS).
maclib::security::firewall_state() {
  command -v firewall >/dev/null 2>&1 || return 127
  local out
  out="$(firewall --getFirewall 2>/dev/null)" || return $?
  [[ -n "$out" ]] || return 1
  printf '%s\n' "$out"
}

# Return 0 if the Application Firewall is currently ON.
maclib::security::is_application_firewall_enabled() {
  [[ "$(maclib::security::firewall_state)" == "On" ]]
}

# Turn the Application Firewall on (requires root): firewall --setFirewall On.
# Usage: maclib::security::remediate_firewall [firewall options...]
maclib::security::remediate_firewall() {
  firewall --setFirewall On "$@"
}

# ---------------------------------------------------------------------------
# SSH (OpenSSH network daemon)
# ---------------------------------------------------------------------------

# Return 0 if the OpenSSH daemon is NOT active (disabled or absent). Modern
# macOS ships without sshd by default, which is the safe state. Returns 1 when
# the daemon is active/starting.
maclib::security::is_ssh_disabled() {
  local out
  # launchctl print returns non-zero when the service is absent -> safe.
  if ! out="$(launchctl print system/com.openssh.sshd 2>/dev/null)"; then
    return 0
  fi
  if printf '%s' "$out" \
    | grep -qiE '"state" *: *"?(active|running|starting)"?'; then
    return 1
  fi
  return 0
}

# Disable the OpenSSH network daemon at boot (requires root):
# launchctl bootout system/com.openssh.sshd.
# Usage: maclib::security::remediate_ssh
maclib::security::remediate_ssh() {
  launchctl bootout system/com.openssh.sshd "$@"
}

# ---------------------------------------------------------------------------
# Aggregated audit
# ---------------------------------------------------------------------------

# Run the read-only security controls, record pass/fail/warn, and print a
# compliance report (see maclib::security::report()). Returns 0 only if no
# control failed.
maclib::security::audit() {
  maclib::security::reset

  # Gatekeeper.
  if maclib::security::is_gatekeeper_enforced; then
    maclib::security::pass "Gatekeeper enforced"
  else
    maclib::security::fail "Gatekeeper not enforced"
  fi

  # Application Firewall.
  local fw
  fw="$(maclib::security::firewall_state)"
  if [[ "$fw" == "On" ]]; then
    maclib::security::pass "Application Firewall on"
  elif [[ -n "$fw" ]]; then
    maclib::security::warn "Application Firewall off ($fw)"
  else
    maclib::security::warn "Application Firewall not installed"
  fi

  # SSH daemon.
  if maclib::security::is_ssh_disabled; then
    maclib::security::pass "SSH daemon disabled"
  else
    maclib::security::fail "SSH daemon enabled"
  fi

  maclib::security::report
}
