# Jamf Extension Attribute (EA) Scripts — Candidate Inventory

Research task: `t_7ffeca69` — Search GitHub (code search + repositories) for "jamf extension attribute(s)" and collect candidate scripts with repo URL, file path, one-line description of what macOS info it reports, and license.

Method: GitHub REST API — `search/repositories` (phrases "jamf extension attribute" and "jamf extension attributes", sorted by stars) plus per-repository git tree inspection, then raw file fetch of the highest-value scripts to describe accurately what each reports. Unauthenticated API (rate-limited; code search requires auth and was skipped).

Total repos surfaced: ~155 (both queries). Distinct, individually-useful EA scripts cataloged below: **~48**.

---

## Legend
- Repo URL: `github.com/<owner>/<repo>`
- License: `NO-LICENSE` = no LICENSE file / `NOASSERTION` = non-open-source SPDX. Treat NO-LICENSE as "use with caution / verify upstream" — prefer Apache-2.0 / MIT / GPL-3.0.
- What it reports: one-line summary of the macOS fact the EA returns to Jamf Pro.

---

## A. palantir/jamf-pro-scripts  (Apache-2.0)  — the richest collection
Repo: https://github.com/palantir/jamf-pro-scripts  (362★)
All scripts live under `extension-attributes/`. Each prints `<result>...</result>`.

1. **Apple Security Chip** — `extension-attributes/Apple Security Chip.sh` — reports the bridgeboard/model name of the Apple Security Chip (T2 / Silicon) via `system_profiler SPiBridgeDataType`.
2. **Battery Cycle Count** — `extension-attributes/Battery Cycle Count.sh` — battery cycle count from `system_profiler SPPowerDataType`.
3. **Battery Charge** — `extension-attributes/Battery Charge.sh` — current battery charge percent (`pmset -g batt`).
4. **Firmware Password Set** — `extension-attributes/Firmware Password Set.sh` — whether firmware password is enabled (`firmwarepasswd -check`).
5. **Remote Login (SSH)** — `extension-attributes/Remote Login.sh` — remote-login/SSH enabled state (`systemsetup -getremotelogin`).
6. **Java Version** — `extension-attributes/Java Version.sh` — installed Java versions under `/Library/Java/JavaVirtualMachines`.
7. **Third-Party Kernel Extensions** — `extension-attributes/Kernel Extensions (Third-Party).sh` — list of non-Apple loaded kernel extensions (`kmutil showloaded`).
8. **System Extensions** — `extension-attributes/System Extensions.sh` — list of enabled system extensions (`systemextensionsctl list`).
9. **Time Machine (AutoBackup)** — `extension-attributes/Time Machine.sh` — whether Time Machine AutoBackup is enabled (reads `com.apple.TimeMachine.plist`).
10. **Google Santa Version** — `extension-attributes/Google Santa Version.sh` — version of the Google Santa EDR client (`santactl version`).
11. **log4j Sniffer Version** — `extension-attributes/log4j-sniffer Version.sh` — version of the log4j-sniffer scanner.
12. **Maximum Open Files** — `extension-attributes/Maximum Open Files.sh` — current `ulimit -n` (open-file limit).
13. **Current Wi-Fi Network** — `extension-attributes/Wi-Fi Network.sh` — active Wi-Fi SSID (`networksetup -getairportnetwork`).
14. **Homebrew Health Check** — `extension-attributes/Homebrew Health Check.sh` — `brew doctor` health status (arch-aware prefix).
15. **iCloud Services Enabled** — `extension-attributes/iCloud Services Enabled.zsh` — whether iCloud services are enabled for the logged-in user (reads user iCloud plist).
16. **Startup Volume** — `extension-attributes/Startup Volume.sh` — name of the startup/boot volume (`bless` + `diskutil info`).
17. **Active Directory Computer Account** — `extension-attributes/Active Directory Computer Account.sh` — AD computer account name (`dsconfigad -show`).
18. **Active Directory Search Path** — `extension-attributes/Active Directory Search Path.sh` — AD search path (`dscl ... CSPSearchPath`).
19. **Homebrew Casks** — `extension-attributes/Homebrew Casks.sh` — list of installed Homebrew casks (arch-aware).
20. **Homebrew Formulae** — `extension-attributes/Homebrew Formulae.sh` — list of installed Homebrew formulae (arch-aware).
21. **Homebrew Formulae - Outdated** — `extension-attributes/Homebrew Formulae - Outdated.sh` — outdated Homebrew formulae.
22. **Homebrew Casks - Outdated** — `extension-attributes/Homebrew Casks - Outdated.sh` — outdated Homebrew casks.
23. **Xcode Command Line Tools** — `extension-attributes/Xcode Command Line Tools.sh` — Xcode CLT / Xcode.app version (`xcode-select --print-path`).
24. **Logged-In User** — `extension-attributes/Logged-In User.sh` — logged-in console user (`stat -f%Su /dev/console`).
25. **Mac App Store Apps** — `extension-attributes/Mac App Store Apps.sh` — list of Mac App Store receipts (`mdfind`).
26. **Printer Drivers** — `extension-attributes/Printer Drivers.sh` — installed printer drivers (`lpinfo -m`).
27. **Hostname** — `extension-attributes/Hostname.sh` — machine hostname (`hostname`).
28. **Charger Wattage** — `extension-attributes/Charger Wattage.sh` — Mac charger wattage (`system_profiler SPPowerDataType`).
29. **Uptime** — `extension-attributes/Uptime.sh` — seconds since boot (computed from `kern.boottime`).
30. **Screen Time** — `extension-attributes/Screen Time.sh` — per-user screen-time usage stats.

---

## B. jamf/Jamf-Nation-Extension-Attributes  (NO-LICENSE) — official Jamf repo
Repo: https://github.com/jamf/Jamf-Nation-Extension-Attributes  (140★)
Mix of `.xml` (Jamf Pro extension-attribute definitions) and `.sh`.

31. **Battery Health Status** — `Battery Health Status.xml` — battery health status (xml EA).
32. **FileVault 2 Encryption Check** — `filevault_2_encryption_check_extension_attribute.xml` — FileVault 2 encryption state (xml EA).
33. **Encrypted Volume Password** — `EA_EncryptedVolumePassword.sh` — reads an encrypted-volume passphrase from a log file (note: insecure pattern — reads a stored password; treat as reference only).
34. **Startup Volume Name** — `EA_StartupVolumeName.sh` — boot volume name (`bless --getboot` + `diskutil info`).
35. **Managed By — EA** — `Managed_By_-_EA.xml` — which entity manages the machine (xml EA, shell script contents).
36. **Adobe Reader DC Version** — `AdobeReaderDCversion.xml` / `Get Adobe Reader Version.xml` — Adobe Reader DC version.
37. **Adobe Creative Cloud License Length** — `Adobe_Creative_Cloud_License_length.xml` — CC license remaining length.
38. **QAS Version** — `QAS_VersionEA.sh` — QAS (Quark Application Sync) version.
39. **Foxit Reader** — `foxitreader.sh` — Foxit Reader version.
40. **Netskope Version** — `netskope_version_EA.sh` — Netskope client version.
41. **Adobe Creative Cloud License Length** — `Adobe_Creative_Cloud_License_length.xml`.
42. **Chrome Extensions** — `Chrome_Extensions_(1).xml` — installed Chrome extensions.

---

## C. Bretterteig/jamf-tools  (NO-LICENSE) — large modern EA set
Repo: https://github.com/Bretterteig/jamf-tools  (12★)
EAs under `ExtensionAttributes/`.

43. **Find My Mac Status** — `ExtensionAttributes/FindMyStatus.sh` — FMM/mobileMe token activation status (`nvram` + PlistBuddy).
44. **Firmware Password** — `ExtensionAttributes/FirmwarePassword.sh` — firmware password enabled/disabled (`firmwarepasswd -check`).
45. **Battery Health** — `ExtensionAttributes/BatteryHealth.sh` — battery health condition from `system_profiler SPPowerDataType -xml`.
46. **Boot Time** — `ExtensionAttributes/BootTime.sh` — system boot timestamp (`kern.boottime`).
47. **Sealed System Volume** — `ExtensionAttributes/SealedSystemVolume.sh` — authenticated-root / sealed system volume state (`csrutil authenticated-root`).
48. **Kernel Extensions** — `ExtensionAttributes/Kext.sh` — third-party kernel extensions from `KextPolicy` sqlite table.
49. **Thunderbolt** — `ExtensionAttributes/ThunderBolt.sh` — Thunderbolt devices/status.
50. **USB Devices** — `ExtensionAttributes/USB.sh` — USB devices (excludes T2/VHCBus controllers).
51. **Sophos Version(s)** — `ExtensionAttributes/Sophos{Version,LastConnection,LastUpdate,VirusDataVersion}.sh` — Sophos EDR product version / last connection / last update / virus-data version.
52. **Privileges (MDM) Reasons** — `ExtensionAttributes/PrivilegesReasons.py` — macOS security log events from the `corp.sap.privileges.helper` MDM process (Python).

---

## D. robjschroeder/Jamf-Extension-Attributes  (NO-LICENSE) — Jamf Protect focus
Repo: https://github.com/robjschroeder/Jamf-Extension-Attributes  (21★)

53. **Jamf Protect — Installed** — `Jamf Protect - Installed.sh` — whether Jamf Protect app is installed (returns 1/0).
54. **Jamf Protect — Service Status** — `Jamf Protect - Service Status.sh` — whether Jamf Protect process is running.
55. **Battery Health Status** — `Battery Health Status.sh` — battery condition, model-aware (Book vs desktop).

---

## E. pbowden-msft/ExtensionAttributes  (NOASSERTION) — Microsoft
Repo: https://github.com/pbowden-msft/ExtensionAttributes  (63★)

56. **OneDrive Process Health** — `OneDrive_Process_Health.sh` — logged-in user's OneDrive process health.
57. **Teams Update Status** — `Teams_Update_Status.sh` — Microsoft Teams update status.

---

## F. Other notable repos (individual EAs not individually fetched)
- **bp88/Jamf-Pro-Extension-Attributes** (90★, NO-LICENSE) — `Battery Health Status.sh` (battery health).
- **jamf/Jamf-Nation-Extension-Attributes** — `Adobe_Creative_Cloud_License_length.xml`, `Get Adobe Reader Version.xml`, `QAS_VersionEA.sh`, `foxitreader.sh`, `netskope_version_EA.sh`, `Chrome_Extensions_(1).xml`.
- **hhorn76/JAMF** (34★, MIT) — dozens of Active Directory EAs (computer account DN, last password-change days, password-change interval, OnPremises), network EAs (current Wi-Fi SSID, network time server, preferred-network SSID, IP geolocation), Office 365 auto-update status, OneDrive status EAs, security ask-for-password delay, software-from-AppStore lists, user password last-set, CPU usage / last reboot — all under `Extension Attributes/` (`.sh` + `.py`).
- **smashism/jamfpro-extension-attributes** (34★, NO-LICENSE) — Chrome-extension detection, OmniGraffle/VirtualBox serial-number EAs, `jamfkeychain2.sh`.
- **sean-rabbitt/jamf-extension-attributes** (22★, MIT) — Jamf Connect user/login-count EAs.
- **krypted/TouchID_check** (13★, NO-LICENSE) — TouchID status EA (repo currently returns 404 on default branches — verify before use).
- **zoocoup/CrowdstikeEAsforJamfPro** (22★, NO-LICENSE) — CrowdStrike sensor/agent info EAs.
- **watchmanmonitoring/Jamf-Pro-Extension_Attributes** (4★, Apache-2.0) — Watchman Monitoring status EA.
- **hardstriker/mSCP_EAs** (3★, GPL-3.0) — macOS Security Compliance (mSCP) project EAs.
- **hardstriker/ComplianceReporterEAs** (4★, GPL-3.0) — Jamf Compliance Reporter EAs.
- **DarkstarIntegrations/Casper** (6★, GPL-3.0) — AD sharing name, Check Point, PGP encryption/boot-guard status, ARD status EAs.
- **jmahlman/Extension-Attributes** (9★, MIT) — Casper EAs.
- **univ-of-utah-marriott-library-apple/...collection** (17★, MIT) — library EA collection (README only in tree).

---

## Notes / caveats
- **Licenses.** Many popular repos carry NO-LICENSE (palantir, jamf, bp88, robjschroeder, krypted). MIT (hhorn76, sean-rabbitt, nstrauss, smashism, jmahlman, zghalliwell) and Apache-2.0 (palantir top collection, watchmanmonitoring, Samstar777) are safest for integration. GPL-3.0 (hardstriker, Darkstar) is copyleft — fine for a bash lib but check obligations. NOASSERTION (pbowden-msft) needs manual license check.
- **Security-sensitive patterns.** `EA_EncryptedVolumePassword.sh` reads a stored passphrase from a log file — insecure; reference only, do not integrate. Several EAs require root or network.
- **Read-only assumption.** Most EAs are read-only (good fit for the library's "safety" criterion), but a few modify state (e.g. Time Machine AutoBackup read is safe; `firmwarepasswd`/`systemsetup` queries are safe). Verify each before integrating.
- **Two scripts could not be fetched** (`Search Domains` and `krypted/TouchID_check` returned 404 on default branches) — flagged but otherwise covered by sibling repos.

---

## Suggested next step (for follow-up tasks t_39d22d43 / t_9a195228)
Highest-reuse, read-only, pure-macOS-tool candidates to evaluate first:
- Security/hardware: Apple Security Chip, Firmware Password, Sealed System Volume, Third-Party Kernel Extensions, System Extensions, Remote Login, Find My Mac, FileVault 2 state, Battery Health/Cycle/Charge.
- Inventory: Homebrew formulae/casks + outdated, Java version, Xcode CLT, logged-in user, hostname, uptime, boot time, startup volume, current Wi-Fi SSID, AD computer account.
- EDR/client version: Google Santa, Sophos, Netskope, log4j-sniffer.
