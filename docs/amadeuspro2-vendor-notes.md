# amadeuspro2 — vendor notes

- **Label (Installomator):** `amadeuspro2`
- **App:** Amadeus Pro
- **Module:** `lib/communication/amadeuspro2.sh` (`maclib::communication::amadeuspro2::*`)
- **Installer type:** zip
- **Apple Developer Team ID:** `FWDH9W45C2`

## Vendor source

Amadeus Pro ships a signed zip from AWS S3 (Installomator `amadeuspro2`
label):

```
https://s3.amazonaws.com/AmadeusPro2/AmadeusPro.zip
```

The current build is read from the vendor page:

```
https://www.hairersoft.com/pro.html
```

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://s3.amazonaws.com/AmadeusPro2/AmadeusPro.zip` (HTTP/1.1 200)
- **latest_version:** `3.0` (parsed from `pro.html`)

## Install / update / uninstall

- **install:** download the zip, unzip, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
