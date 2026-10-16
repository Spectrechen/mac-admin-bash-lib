# tortalk_en — vendor notes

- **Label (Installomator):** `tortalk_en`
- **App:** TorTalk EN
- **Module:** `lib/communication/tortalk_en.sh` (`maclib::communication::tortalk_en::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `QUT3D5SU72`

## Vendor source

TorTalk ships signed `.pkg` installers from Azure Blob Storage. The current
build is discovered by fetching the student/pupil download page and reading the
`.pkg` link it redirects to (Installomator `tortalk_en` label):

```
https://tortalk.se/student-or-pupil/?lang=en
```

resolves to e.g.:

```
https://tortalkfiles.blob.core.windows.net/tortalkmac/TorTalk_installer_2.4.2_EN.pkg
```

## Concrete values (2026-08-25)

- **suite_installer_url:** discovered from the download page (e.g.
  `https://tortalkfiles.blob.core.windows.net/tortalkmac/TorTalk_installer_2.4.2_EN.pkg`)
- **latest_version:** `2.4.2` (parsed from the discovered `.pkg` file name)

## Install / update / uninstall

- **install:** download the pkg and install with `/usr/sbin/installer` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
