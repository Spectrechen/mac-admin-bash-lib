# Jamf Extension Attribute Candidates — Ranked Shortlist

Evaluation task: `t_39d22d43` (scored against `docs/jamf-ea-candidates.md`, ~48 cataloged scripts).

Scoring criteria (per task body): usefulness to macOS users, correctness/robustness of the script, safety (read-only, no system changes), maintainability (repo activity, language, dependencies), licensing.

Library coverage already present (from `docs/function-catalog.md`): FileVault, SIP, Gatekeeper, Firewall, SSH daemon, MDM status, logged-in user, hostname, system_profiler. Anything duplicating those is a lower priority.

All top entries are from `palantir/jamf-pro-scripts` (Apache-2.0, ~362 stars, actively maintained, pure bash/sh, no third-party deps) — the only cataloged repo with a per-file license header plus broad adoption. Lower-tier entries mix NO-LICENSE / GPL-3.0 / NOASSERTION repos and are noted as such.

---

## Ranked shortlist (13 entries)

1. **Battery Cycle Count** (`palantir`, Apache-2.0) — Read-only `system_profiler SPPowerDataType` cycle count; battery health data is entirely missing from the library, making this the highest-value addition (minor: depends on `bc`).

2. **Battery Charge** (`palantir`, Apache-2.0) — Read-only current charge % via `pmset -g batt`; trivial, robust, and useful for field/MDM dashboards.

3. **Apple Security Chip** (`palantir`, Apache-2.0) — Read-only reports T2 / Silicon chip generation via `system_profiler SPiBridgeDataType`; fills a security-hardware gap, no deps.

4. **Third-Party Kernel Extensions** (`palantir`, Apache-2.0) — Read-only lists non-Apple loaded kexts via `kmutil showloaded`; security-relevant and not otherwise covered.

5. **System Extensions** (`palantir`, Apache-2.0) — Read-only lists enabled system extensions via `systemextensionsctl list`; complements the kext check, no deps.

6. **Uptime** (`palantir`, Apache-2.0) — Read-only seconds since boot from `kern.boottime`; simple and robust, useful for MDM inventory.

7. **Xcode Command Line Tools** (`palantir`, Apache-2.0) — Read-only distinguishes bundled-vs-standalone CLT via `xcode-select --print-path`; useful for developer-machine audits, no deps.

8. **Firmware Password Set** (`palantir`, Apache-2.0) — Read-only firmware-password state is valuable, **but the script is buggy**: it only runs on `i386`, so it returns empty on all Apple Silicon Macs — integrate only after fixing the arch check.

9. **Startup Volume** (`palantir`, Apache-2.0) — Read-only boot-volume name via `bless` + `diskutil info`; useful for hardware inventory, no deps.

10. **Charger Wattage** (`palantir`, Apache-2.0) — Read-only charger wattage via `system_profiler`; low usefulness but harmless and dependency-free.

11. **Time Machine AutoBackup** (`palantir`, Apache-2.0) — Read-only reads the `com.apple.TimeMachine.plist` flag; safe and simple, but narrow usefulness.

12. **Homebrew Formulae — Outdated** (`palantir`, Apache-2.0) — Read-only outdated-formula list, **but uses `sudo -u <user>`** which is fragile/needs sudo — integrate only if the sudo requirement is replaced with `launchctl asuser`.

13. **Remote Login (SSH)** (`palantir`, Apache-2.0) — Read-only `systemsetup -getremotelogin`; useful for compliance, though the library already tracks SSH daemon state.

---

## Discarded (with reason)

- **EA_EncryptedVolumePassword.sh** (`jamf`, NO-LICENSE) — **INSECURE**: reads a stored passphrase from a log file. Reference only; never integrate.
- **Logged-In User** (`palantir`) — duplicate of existing `maclib::user::current_user` / `user::whoami`.
- **Hostname** (`palantir`) — duplicate of existing `maclib::network::hostname`.
- **Battery Health / Battery Health Status** (`jamf`, `bp88`, `robjschroeder`) — three near-duplicate repos across the catalog; superseded by #1/#2.
- **Adobe Reader / Creative Cloud / QAS / Foxit / Netskope / CrowdStrike / Google Santa / Sophos EDR EAs** — vendor-specific version probes; marginal general usefulness and most carry NO-LICENSE.
- **All `.xml` EAs** (`jamf/Jamf-Nation-Extension-Attributes`) — not standalone scripts; they are Jamf Pro extension-attribute definitions (XML), not reusable bash.
- **krypted/TouchID_check** — repo returns 404 on default branches; cannot verify.
- **Privileges (MDM) Reasons.py** (`Bretterteig`) — Python, not bash; out of library scope.
- **Scripts requiring root or network** (e.g. some EDR status probes) — fail the library's read-only safety criterion.

---

## Licensing summary

- **Safest for integration:** Apache-2.0 — all 13 shortlisted entries (from `palantir/jamf-pro-scripts`).
- **Copyleft (fine for a bash lib, check obligations):** GPL-3.0 — `hardstriker/*`, `DarkstarIntegrations/Casper`.
- **Verify before use:** NO-LICENSE — `jamf`, `bp88`, `robjschroeder`, `smashism`; NOASSERTION — `pbowden-msft`. Recommend re-licensing or removing these if ever integrated.

---

## Suggested next step (for follow-up task `t_9a195228`)

For each shortlisted entry, produce an integration spec: the exact EA script, the data field exposed, expected output format (`<result>...</result>` text), and prerequisites (e.g. `bc` for battery cycle, `kmutil` for kexts, macOS version for sealed-system-volume). Prioritize the 9 non-duplicate, non-buggy entries (#1–#3, #5–#9, #10–#11) first; defer #8 and #12 until their known bugs are fixed.
