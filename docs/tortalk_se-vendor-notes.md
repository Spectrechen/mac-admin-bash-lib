# tortalk_se — vendor notes

- **Label (Installomator):** `tortalk_se`
- **App:** TorTalk SE
- **Module:** `lib/communication/tortalk_se.sh` (`maclib::communication::tortalk_se::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `QUT3D5SU72`

## Vendor source

TorTalk ships signed `.pkg` installers from Azure Blob Storage. The current
build is discovered by fetching the student/pupil download page and reading the
`.pkg` link it redirects to (Installomator `tortalk_se` label):

```
https://tortalk.se/student-elev/
```

resolves to e.g.:

```
https://tortalkfiles.blob.core.windows.net/tortalkmac/TorTalk_installer_2.4.3_SV.pkg
```

## Concrete values (2026-08-25)

- **suite_installer_url:** discovered from the download page (e.g.
  `https://tortalkfiles.blob.core.windows.net/tortalkmac/TorTalk_installer_2.4.3_SV.pkg`)
- **latest_version:** `2.4.3` (parsed from the discovered `.pkg` file name)

## Install / update / uninstall

- **install:** download the pkg and install with `/usr/sbin/installer` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
