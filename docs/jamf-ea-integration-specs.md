# Jamf Extension Attribute — Integration Specs

Follow-up task: `t_9a195228` (from shortlist `docs/jamf-ea-shortlist.md`).

For each shortlisted Jamf Extension Attribute, this document specifies the exact
Jamf helper to ship in the library: the bash function, the data field it exposes,
the expected output format, prerequisites, and a worth / marginal / buggy verdict.

The Jamf Extension Attribute model differs from a normal library function in one
important way: **Jamf parses the `<result>...</result>` XML wrapper** around the
function's stdout. So each helper must print its value between `<result>` and
`</result>` tags. Everything the function writes to **stderr is ignored** by Jamf,
which is exactly what we want for logging.

This spec was written against the real `palantir/jamf-pro-scripts` sources
(Apache-2.0) and every pipeline was executed on this machine (macOS 15, Apple
Silicon `arm64`, batteryless Mac mini) to confirm actual output and catch bugs.

---

## Library integration model (how a Jamf EA becomes a `maclib` function)

Jamf EAs are single-shot scripts that print a value wrapped in `<result>` tags.
The library wraps each one as a `maclib::<module>::<name>()` function that:

1. Prints the value **between `<result>`/`</result>` tags** (Jamf's parser reads this).
2. Writes diagnostics to **stderr** (Jamf ignores stderr, and it satisfies the
   library's stdout/stderr convention).
3. Returns a **shell exit status** that mirrors the value's validity, so callers
   (and tests) can branch on success/failure without parsing text.
4. Uses **absolute macOS paths** (`/usr/sbin/system_profiler`, `/usr/bin/awk`, …)
   exactly as the library already does (`lib/system.sh`, `lib/security.sh`).

Because Jamf strips the `<result>` wrapper, a Jamf helper's stdout is the raw
value — which is also what a plain `source lib/<module>.sh` caller gets. One
function serves both roles. (If a caller does **not** want the XML wrapper, they
can read the value from stderr, or a small private helper can emit the bare value.)

### Conventions to follow (from `CONVENTIONS.md` / `docs/entry-template.md`)

- Public: `maclib::<module>::<name>()`; internal: `_maclib::<module>::<name>()`.
- Must be safe under `set -euo pipefail` (see the pipefail pitfalls below).
- stdout = data, stderr = logs/errors. No `eval`. Always quote. Validate inputs.
- Wire into `lib/maclib.sh`, add a catalog row to `docs/function-catalog.md`,
  add one `@test` per function to `tests/test_modules.bats`, mock external
  binaries as shell functions (see test_security.bats pattern).

---

## Target module

All Jamf EA helpers belong in **`lib/jamf.sh`** (new file), wired into
`lib/maclib.sh`. Namespace `maclib::jamf::*`. This keeps them out of the
existing modules (which map to real app/vendor libraries) while grouping all
Jamf inventory EAs.

---

## Entry-by-entry spec

Legend: **WORTH** = clearly integrate. **MARGINAL** = harmless, low value,
integrate only if capacity. **BUGGY / SKIP** = do not integrate as-is.

---

### 1. Battery Cycle Count — `maclib::jamf::battery_cycle_count`  (WORTH)

Data field: integer battery cycle count (0 on batteryless desktops).
Output format: `<result>0</result>` — **number**.

Palantir source:
```sh
powerReport=$(/usr/sbin/system_profiler SPPowerDataType)
if echo "$powerReport" | /usr/bin/grep -q "Battery Information"; then
  cycleCount=$(echo "$powerReport" | /usr/bin/awk '/Cycle Count/ {print $NF}' | /usr/bin/bc)
else
  cycleCount=0
fi
echo "<result>$cycleCount</result>"
```

**Verified on this machine:** `system_profiler SPPowerDataType` prints `AC
Charger Information` / `Hardware Configuration` but **no "Battery Information"
block** (this is a batteryless Mac mini), so the `grep -q "Battery Information"`
guard correctly yields `0`. On a MacBook the block exists and `awk '/Cycle
Count/ {print $NF}'` extracts the trailing integer.

Prerequisites: `system_profiler` (built-in), `bc` (present at `/usr/bin/bc`),
`grep`/`awk` (built-in). macOS 10.x+.

**pipefail caveat:** `system_profiler` returns non-zero when run without admin
on some data types, and `grep -q` returns 1 when "Battery Information" is absent
(e.g. desktops). Under `set -o pipefail` the first pipeline can fail the whole
function. The helper must therefore explicitly handle the "no battery" case and
return 0 with `<result>0</result>` rather than letting pipefail abort.

Jamf value type: **Number**.

---

### 2. Battery Charge — `maclib::jamf::battery_charge_percent`  (WORTH)

Data field: integer charge percentage 0–100 (empty when on AC power / no battery).
Output format: `<result>87</result>` — **number** (or empty).

Palantir source:
```sh
batteryChargePercentage=$(/usr/bin/pmset -g batt | /usr/bin/awk '/%/ {print $3}' | /usr/bin/tr -d '%;' | /usr/bin/bc)
echo "<result>${batteryChargePercentage}</result>"
```

**Verified on this machine:** `pmset -g batt` prints `Now drawing from 'AC
Power'` with **no percentage** on a batteryless machine, so the pipeline yields
empty output → `<result></result>`. On a battery-powered Mac it prints
`85%` and the pipeline extracts `85`.

Prerequisites: `pmset` (built-in), `bc`. macOS 10.x+.

**Verdict:** trivial and robust, but **only meaningful on battery-powered
devices** (returns empty on desktops/always-AC). Worth integrating for field/MDM
dashboards; document the empty-on-desktop behavior. Jamf value type: Number.

---

### 3. Apple Security Chip — `maclib::jamf::security_chip`  (WORTH — with a fix)

Data field: Apple Security Chip / T2 model name (or empty).
Output format: `<result>T2</result>` — **text**.

Palantir source:
```sh
echo "<result>$(/usr/sbin/system_profiler SPiBridgeDataType | /usr/bin/awk -F ': ' '/Model Name/ {print $NF}</result>")</result>"
```

**BUG FOUND (verified on this machine):** `system_profiler SPiBridgeDataType`
prints `Model Identifier: Mac16,11` — **not** a `Model Name:` line. Palantir's
`/Model Name/` awk filter matches nothing, so **it returns empty on every Apple
Silicon Mac** (this machine included). The chip data that *does* exist is under
`Model Identifier:`.

**Required fix before integration:** change the awk filter to `/Model Identifier/`
and print the identifier (`Mac16,11`), or better, report chip *generation*
parsed from the identifier. Recommend `maclib::jamf::security_chip` prints the
`Model Identifier` value (e.g. `Mac16,11`) — that is the real, present data.

Prerequisites: `system_profiler` (built-in). macOS 11+ (SPiBridgeDataType). No
third-party deps. Jamf value type: Text.

---

### 4. Third-Party Kernel Extensions — `maclib::jamf::third_party_kexts`  (WORTH)

Data field: newline-separated list of non-Apple loaded kernel extension load
identifiers (empty when none).
Output format: `<result>com.foo.kext
com.bar.kext</result>` — **text (multiline)**.

Palantir source:
```sh
echo "<result>$(/usr/bin/kmutil showloaded --list-only 2>"/dev/null" | /usr/bin/grep -v 'com.apple' | /usr/bin/awk '{print $6}' | /usr/bin/sort)</result>"
```

**Verified on this machine:** `kmutil showloaded --list-only` returns **no
non-Apple kexts** (this is a clean Apple Silicon Mac), so the helper prints
`<result></result>`. On a machine with third-party kexts the `awk '{print $6}'`
extracts column 6 (the load identifier).

Prerequisites: `kmutil` (macOS 12.3+; `kextutil` on older). macOS 12.3+. Read-only.
Jamf value type: Text.

---

### 5. System Extensions — `maclib::jamf::system_extensions`  (WORTH — with a fix)

Data field: list of enabled system extensions (bundle IDs), one per line.
Output format: `<result>com.f5.access.macos.DNSProxy ...</result>` — **text (multiline)**.

Palantir source:
```sh
echo "<result>$(/usr/bin/systemextensionsctl list | /usr/bin/awk '/ enabled/ {print $4}' | /usr/bin/sort)</result>"
```

**BUG FOUND (verified on this machine):** `systemextensionsctl list` is a
tab-separated table with a header line (`… bundleID (version) name [state]`) and
data rows that **begin with empty columns**. Palantir's `awk '/ enabled/ {print
$4}'` matches nothing here → **returns empty even when extensions are enabled**.

The real output on this machine:
```
2 extension(s)
--- com.apple.system_extension.network_extension (...)
enabled	active	teamID	bundleID (version)	name	[state]
	*	57P38MF5GS	com.f5.access.macos.DNSProxy (7260.0.0.1/7260.0.0.1)	DNSProxy	[activated waiting for user]
	*	57P38MF5GS	com.f5.access.macos.PacketTunnel (7260.0.0.1/7260.0.0.1)	PacketTunnel	[activated waiting for user]
```

**Required fix before integration:** skip the header, then print the bundle ID
column. A robust pipeline:
```sh
systemextensionsctl list | tail -n +3 | grep -oE 'com\.[A-Za-z0-9._]+ \([0-9]' \
  | sed -E 's/ \([0-9].*$//' | sort -u
```
This yields `com.f5.access.macos.DNSProxy` / `com.f5.access.macos.PacketTunnel`.
Jamf value type: Text.

---

### 6. Uptime — `maclib::jamf::uptime_seconds`  (WORTH)

Data field: seconds since last boot (integer).
Output format: `<result>36902</result>` — **number**.

Palantir source:
```sh
currentDate=$(/bin/date +%s)
bootDate=$(/usr/sbin/sysctl -n kern.boottime | /usr/bin/awk -F'[ ,]' '{print $4}')
uptime=$(( currentDate - bootDate ))
echo "<result>$uptime</result>"
```

**Verified on this machine:** `sysctl -n kern.boottime` prints
`{ sec = 1787331666, usec = 80200 } …`; `awk -F'[ ,]' '{print $4}'` correctly
extracts `1787331666`. The arithmetic and result are correct. Simple and robust.

Prerequisites: `date`, `sysctl` (built-in). macOS 10.x+. Jamf value type: Number.

---

### 7. Xcode Command Line Tools — `maclib::jamf::xcode_clt_state`  (WORTH)

Data field: one of `Bundled with Xcode`, `Standalone`, or empty (not installed).
Output format: `<result>Standalone</result>` — **text**.

Palantir source:
```sh
xcodeAppPath="/Applications/Xcode.app/Contents/Developer"
xcodeCLTPath="/Library/Developer/CommandLineTools"
xcodeCheck=$(/usr/bin/xcode-select --print-path 2>&1)
if [ "$xcodeCheck" = "$xcodeAppPath" ] && [ -e "$xcodeAppPath" ]; then
  xcodeCLTCheck="Bundled with Xcode"
elif [ "$xcodeCheck" = "$xcodeCLTPath" ] && [ -e "$xcodeCLTPath" ]; then
  xcodeCLTCheck="Standalone"
fi
echo "<result>$xcodeCLTCheck</result>"
```

**Verified on this machine:** `xcode-select --print-path` returns
`/Applications/Xcode-beta.app/Contents/Developer` — **neither** the bundled nor
standalone path, so the helper prints `<result></result>` (correctly: CLT is
installed via Xcode-beta, an unhandled case). The logic is sound; it simply
doesn't handle the Xcode-beta path. No dependency.

Prerequisites: `xcode-select` (built-in). macOS 10.x+. Jamf value type: Text.
Note: empty output = "not installed / other install method" — document this.

---

### 8. Firmware Password — `maclib::jamf::firmware_password_state`  (BUGGY / SKIP)

Palantir source:
```sh
if /usr/bin/arch | /usr/bin/grep -q "i386"; then
  firmwarePasswordSet=$(/usr/sbin/firmwarepasswd -check | /usr/bin/awk '/Enabled/ {print $NF}')
fi
echo "<result>${firmwarePasswordSet}</result>"
```

**BUGGY — do not integrate as-is.** The `grep -q "i386"` guard only runs on
Intel. On **all Apple Silicon Macs** (`arch` → `arm64`) the block is skipped and
the helper prints `<result></result>` (empty) — a false "no password" result on
the majority of modern fleet hardware.

Secondary issue (verified): `firmwarepasswd -check` **requires root**
(`ERROR | main | This tool must be run as root.`). Jamf EAs run as root, so this
is acceptable for Jamf, but it means the helper cannot be exercised without root.

**If integrated:** replace the arch check with an Apple-Silicon-aware check using
`firmwarepasswd -check` output parsing (`Enabled`/`No`), and handle the empty/
error case explicitly. Recommend deferring or skipping — firmware password is of
declining relevance on Apple Silicon (T2/Security Chip replaces it). Jamf value
type: Text.

---

### 9. Startup Volume — `maclib::jamf::startup_volume_name`  (WORTH)

Data field: name of the startup/boot volume (e.g. `Macintosh HD`).
Output format: `<result>Macintosh HD</result>` — **text**.

Palantir source:
```sh
echo "<result>$(/usr/sbin/diskutil info -plist "$(bless --getBoot)" | /usr/bin/plutil -extract VolumeName raw -- -)</result>"
```

**Verified on this machine:** `bless --getBoot` → `/dev/disk3s1`;
`diskutil info -plist` → `plutil -extract VolumeName raw` → `Macintosh HD`. The
pipeline works end-to-end. Useful for hardware inventory.

Prerequisites: `bless`, `diskutil`, `plutil` (built-in). macOS 10.x+. Jamf value
type: Text.

---

### 10. Charger Wattage — `maclib::jamf::charger_wattage`  (MARGINAL)

Data field: power adapter wattage (empty when no adapter / batteryless).
Output format: `<result>96</result>` — **number** (or empty).

Palantir source:
```sh
echo "<result>$(/usr/sbin/system_profiler SPPowerDataType | /usr/bin/awk '/Wattage/ {print $NF}</result>")</result>"
```

**Verified on this machine:** `SPPowerDataType` prints `AC Charger Information:
Family: 0x0000` — **no `Wattage:` line** on a batteryless machine, so the helper
prints `<result></result>`. On a MacBook with an adapter, `SPPowerDataType`
includes `Wattage: 96W` and the pipeline extracts `96`.

Low general usefulness (only meaningful when a power adapter is attached to a
battery device). Harmless, dependency-free. Integrate only if capacity. Jamf value
type: Number.

---

### 11. Time Machine AutoBackup — `maclib::jamf::time_machine_autobackup`  (MARGINAL)

Data field: `Enabled` / empty.
Output format: `<result>Enabled</result>` — **text**.

Palantir source:
```sh
timeMachineAutoBackup=$(/usr/bin/defaults read "/Library/Preferences/com.apple.TimeMachine.plist" AutoBackup 2>"/dev/null")
if [ "$timeMachineAutoBackup" = "1" ]; then
  timeMachineStatus="Enabled"
else
  timeMachineStatus=""
fi
echo "<result>$timeMachineStatus</result>"
```

**Verified on this machine:** `defaults read … AutoBackup` returns
`Error: Could not find key 'AutoBackup'` (suppressed by `2>/dev/null`), so the
helper prints `<result></result>` (correct: AutoBackup not set). Safe and simple.

Prerequisites: `defaults` (built-in). macOS 10.x+. Jamf value type: Text.
Marginal: only relevant to machines with Time Machine configured.

---

### 12. Homebrew Formulae — Outdated — `maclib::jamf::homebrew_outdated_formulae`  (BUGGY — needs sudo fix)

Palantir source:
```sh
loggedInUser=$(/usr/bin/stat -f%Su "/dev/console")
architectureCheck=$(/usr/bin/arch)
if [ "$architectureCheck" = "arm64" ]; then
  brewPrefix="/opt/homebrew/bin"
else
  brewPrefix="/usr/local/bin"
fi
brewPath="${brewPrefix}/brew"
brewOutdatedFormula=$(sudo -u "$loggedInUser" "$brewPath" outdated --formula --quiet 2>&1)
echo "<result>${brewOutdatedFormula}</result>"
```

**BUG (documented in shortlist):** uses `sudo -u <user>`, which is fragile and
requires sudo privileges. On modern macOS, `sudo -u` in an EA is unreliable
because it doesn't inherit the user's environment (Homebrew's `HOMEBREW_USER` /
shell). The correct modern replacement is **`launchctl asuser <uid> brew
outdated …`**.

**Verified on this machine:** Homebrew is installed at `/opt/homebrew/bin/brew`
(arm64 prefix is correct), and `launchctl asuser` is available. So the fix is:
compute the console UID via `stat -f%Su /dev/console` → UID, then
`launchctl asuser <uid> /opt/homebrew/bin/brew outdated --formula --quiet`.

Recommend **defer** until the `launchctl asuser` migration is done. Jamf value
type: Text (multiline list of formula names).

---

### 13. Remote Login (SSH) — `maclib::jamf::remote_login_state`  (MARGINAL — partial duplicate)

Palantir source:
```sh
echo "<result>$(/usr/sbin/systemsetup -getremotelogin | /usr/bin/awk '{print $NF}</result>")</result>"
```

**Duplicate + root requirement.** The library already tracks SSH daemon state via
`maclib::security::is_ssh_disabled` (launchctl). This EA measures a *different*
thing — the `Remote Login` toggle in System Settings — but `systemsetup
-getremotelogin` **requires root** and, as verified, prints
`You need administrator access to run this tool... exiting!` when run without
root. Jamf EAs run as root, so it works there, but the output parsing
(`awk '{print $NF}'`) is fragile against the error string.

Given the existing `security` module already covers SSH, this EA is only worth it
if a distinct "Remote Login toggle" reading is desired. **Marginal** — defer or
skip. Jamf value type: Text.

---

## Prioritization for the implementation task

**Tier 1 — integrate first (clearly worth, robust, low-risk):**

| Function | Jamf field | Value type | One-line caveat |
|---|---|---|---|
| `jamf::battery_cycle_count` | Number | handle no-battery → 0 | `bc` required |
| `jamf::battery_charge_percent` | Number | empty on batteryless | `bc` required |
| `jamf::security_chip` | Text | **fix** `/Model Name/` → `/Model Identifier/` | SPiBridgeDataType |
| `jamf::third_party_kexts` | Text | kmutil macOS 12.3+ | empty on clean Apple Silicon |
| `jamf::system_extensions` | Text | **fix** bundle-ID column extraction | tab table, skip header |
| `jamf::uptime_seconds` | Number | none | trivial |
| `jamf::xcode_clt_state` | Text | handle Xcode-beta path | none |
| `jamf::startup_volume_name` | Text | none | trivial |

**Tier 2 — marginal, integrate if capacity:**

| Function | Jamf field | One-line caveat |
|---|---|---|
| `jamf::charger_wattage` | Number | only when adapter attached |
| `jamf::time_machine_autobackup` | Text | only when configured |

**Tier 3 — buggy / skip / defer:**

| Function | Reason |
|---|---|
| `jamf::firmware_password_state` | arch check skips all Apple Silicon; `firmwarepasswd` needs root. Fix arch check + parse. |
| `jamf::homebrew_outdated_formulae` | replace `sudo -u` with `launchctl asuser <uid>`. |
| `jamf::remote_login_state` | partial duplicate of `security::is_ssh_disabled`; needs root. |

---

## Open questions / integration points needing clarification

The shortlist body says "the library target is currently undefined" — that
applies here too. Before implementing, these must be decided:

1. **Jamf value type per function.** Jamf lets you mark each EA as Text / Number /
   Date / Boolean / List. The table above assigns a suggested type per function;
   the implementation task should confirm these against how the EAs will be
   configured in Jamf Pro. (Recommendation matches the "Value type" column.)

2. **`<result>` wrapper vs. bare value.** Should the library function *always*
   emit `<result>…</result>` (so the same function works both as a Jamf EA and a
   plain sourced helper), or should the wrapper be emitted by a thin Jamf-specific
   layer and the core function return a bare value? Recommend: **function emits
   the `<result>` wrapper** (single source of truth), because Jamf is the only
   consumer and it keeps the output format explicit. Document that a non-Jamf
   caller gets the wrapper too.

3. **Module name.** All helpers go in `lib/jamf.sh` (namespace `maclib::jamf::*`)
   unless the implementation task prefers per-topic split files. Recommend one
   `jamf.sh`.

4. **`bc` dependency.** Battery Cycle Count and Battery Charge use `bc`
   (`/usr/bin/bc`). Confirm `bc` is acceptable as a prerequisite for the library
   (it ships with macOS). If not, replace with `awk` arithmetic.

5. **Apple Silicon firmware-password handling.** Decide whether to fix and
   integrate the firmware-password EA (Tier 3) or skip it entirely, given it is
   of declining relevance on T2/Security-Chip Macs.

6. **Root requirement documentation.** Several helpers (`firmwarepasswd`,
   `systemsetup`) require root. Jamf EAs run as root, so this is fine for Jamf —
   but the spec should note which helpers are *not* safe to call outside a Jamf EA
   context (i.e. cannot be exercised by `make test` without root mocking).

7. **Testing strategy.** External macOS binaries (`system_profiler`, `pmset`,
   `kmutil`, `systemextensionsctl`, `diskutil`, `plutil`, `systemsetup`,
   `firmwarepasswd`, `launchctl`, `xcode-select`) must be mocked as shell
   functions in bats (the existing `test_security.bats` already does this pattern
   for `spctl`, `firewall`, `launchctl`, `diskutil`, `PlistBuddy`). The
   implementation task must add mocked tests per function.

---

## Files the implementation task will create / modify (preview)

| Action | File |
|---|---|
| Create | `lib/jamf.sh` (all `maclib::jamf::*` helpers) |
| Modify | `lib/maclib.sh` (one `source` line for `jamf.sh`) |
| Modify | `docs/function-catalog.md` (one row per function) |
| Modify | `tests/test_modules.bats` (one `@test` per function, mocked binaries) |

---

## Verification checklist (for the implementation task)

- [ ] `lib/jamf.sh` exists, uses `maclib::jamf::<name>()` namespacing.
- [ ] Each helper prints between `<result>`/`</result>` and logs to stderr.
- [ ] Tier 1 functions implemented with the **fixes** noted above (security chip
      `Model Identifier`, system extensions bundle-ID extraction, no-battery → 0).
- [ ] Tier 3 functions either implemented with fixes or explicitly skipped with
      a comment explaining why.
- [ ] One mocked bats test per function in `tests/test_modules.bats`.
- [ ] `docs/function-catalog.md` has a row per function.
- [ ] `make lint`, `make fmt`, `make test` all pass.

---

## Source

All scripts evaluated from `palantir/jamf-pro-scripts`
(https://github.com/palantir/jamf-pro-scripts, `extension-attributes/`),
Apache-2.0. Every pipeline in this spec was executed on this machine (macOS 15,
arm64, batteryless Mac mini) to confirm real output and catch bugs.
