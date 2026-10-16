# soundlyshapeit — vendor notes

- **Label (Installomator):** `soundlyshapeit`
- **App:** Shapeit (Soundly AU plugin)
- **Module:** `lib/communication/soundlyshapeit.sh` (`maclib::communication::soundlyshapeit::*`)
- **Installer type:** pkg
- **Package ID:** `com.soundly.pkg.au.shapeit`
- **Apple Developer Team ID:** `67Y6N7VTDG`

## Vendor source

Shapeit (an AU plugin) ships a signed `.pkg` from Google Cloud Storage
(Installomator `soundlyshapeit` label):

```
https://storage.googleapis.com/soundly-plugins/Shapeit.pkg
```

The URL carries no build number, so there is **no vendor version endpoint** —
`latest_version()` returns non-zero (documented constraint). Detection uses the
package receipt (`pkgutil --pkg-info com.soundly.pkg.au.shapeit`).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://storage.googleapis.com/soundly-plugins/Shapeit.pkg` (HTTP/2 200)
- **latest_version:** none (no vendor version source)

## Install / update / uninstall

- **install:** download the pkg and install with `/usr/sbin/installer` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
