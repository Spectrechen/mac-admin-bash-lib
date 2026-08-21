#!/usr/bin/env bash
# system.sh - macOS system maintenance helpers

# Print the list of available macOS updates (requires network + root).
maclib::system::softwareupdate() {
	/usr/bin/softwareupdate --list "$@"
}

# Check for and download available updates without installing.
maclib::system::softwareupdate_check() {
	/usr/bin/softwareupdate --check "$@"
}

# Download but do not install available updates.
maclib::system::softwareupdate_download() {
	/usr/bin/softwareupdate --download "$@"
}

# Install available updates (requires root, may reboot).
maclib::system::softwareupdate_install() {
	/usr/bin/softwareupdate --install "$@"
}

# Run /usr/bin/system_profiler with the given data types (default: all).
maclib::system::system_profiler() {
	local types="${1:-SPALL}"
	/usr/bin/system_profiler "$types" "$@"
}

# Print the current System Integrity Protection (SIP) state.
# Output is the raw string from csrutil (e.g. "enabled", "disabled").
maclib::system::sip_status() {
	local out
	out="$(/usr/bin/csrutil status 2>/dev/null)" || return 1
	# csrutil prints: "System Integrity Protection status: ."
	out="${out#*status:}"
	out="${out%.*}"
	# Trim leading/trailing whitespace.
	out="${out#"${out%%[![:space:]]*}"}"
	out="${out%"${out##*[![:space:]]}"}"
	printf '%s\n' "$out"
}

# Return 0 if SIP is currently active/enabled.
maclib::system::is_sip_active() {
	local state
	state="$(maclib::system::sip_status)" || return $?
	[[ "$state" == "Active" ]]
}
