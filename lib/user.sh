#!/usr/bin/env bash
# user.sh - macOS user account helpers

# Return 0 if the current process runs as root (uid 0).
maclib::user::is_root() {
	[[ "$(id -u)" -eq 0 ]]
}

# Print the short name of the user running the current shell.
maclib::user::current_user() {
	whoami
}

# Print the short name of the user running the current shell.
maclib::user::whoami() {
	whoami
}

# Print the home directory of the given user (default: current user).
# Uses dscl on macOS; falls back to a /etc/passwd lookup on other systems.
maclib::user::home_dir() {
	local name="${1:-}"
	if [[ -z "$name" ]]; then
		name="$(maclib::user::whoami)"
	fi

	if maclib::os::is_macos; then
		local home
		home="$(dscl . -read "/Users/$name" NFSHomeDirectory 2>/dev/null || true)"
		# Strip "NFSHomeDirectory:" prefix and surrounding whitespace.
		home="${home#*:}"
		home="${home#"${home%%[![:space:]]*}"}"
		home="${home%"${home##*[![:space:]]}"}"
		[[ -n "$home" ]] || return 1
		printf '%s\n' "$home"
	else
		# /etc/passwd: name:uid:gid:GECos:home:shell → field 6 is home.
		local line
		line="$(getent passwd "$name" 2>/dev/null || true)"
		[[ -n "$line" ]] || return 1
		local home
		IFS=':' read -r _ _ _ _ _ home <<<"$line"
		printf '%s\n' "$home"
	fi
}

# Print the full home directory of the given user (default: current user).
maclib::user::home_dir_full() {
	local name="${1:-}"
	if [[ -z "$name" ]]; then
		name="$(maclib::user::whoami)"
	fi
	local home
	home="$(maclib::user::home_dir "$name")" || return $?
	printf '%s\n' "$home"
}
