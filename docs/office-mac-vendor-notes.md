# Office for Mac — Vendor Research Notes

Entry: `lib/office.sh` (`maclib::office::*`)
App: Microsoft Office 365 for Mac (the suite installer).

## What the vendor says (current, supported installation method)

Office for Mac is distributed as an Apple **`.pkg`** installer package from
Microsoft's **Office Content Delivery Network (CDN)**. Installation uses Apple's
Installer technology, so it can be deployed with any standard software
distribution tool (Jamf Pro, Microsoft Intune, Munki, AutoPkg, Remote Desktop).
Source: "Deployment options for admins for Office for Mac"
(learn.microsoft.com).

Two supported paths:

1. **Initial install** — download the suite installer package from the CDN and
   install it with Apple's `installer` (root required).
2. **Updates** — Office for Mac updates are delivered through **Microsoft
   AutoUpdate (MAU)** using the command-line tool `msupdate`
   (`msupdate --install`). Alternatively, re-deploy a newer app bundle.
   Source: "Deploy updates for Office for Mac" (learn.microsoft.com).

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Suite installer fwlink | `https://go.microsoft.com/fwlink/?linkid=525133` | Installomator `Installomator.sh` (`microsoftoffice365` label) |
| fwlink resolves to | `https://res.public.onecdn.static.microsoft/.../Microsoft_365_and_Office_16.112.26081720_Installer.pkg` | Live HEAD request to the fwlink (2026-08) |
| Package file name pattern | `Microsoft_365_and_Office_<version>_Installer.pkg` | fwlink redirect + "Most current packages for Office for Mac" |
| Team ID | `UBF8T346G9` | Installomator |
| Package ID | `com.microsoft.pkg.licensing` | Installomator |
| Update tool | `msupdate --install` (at `/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate`) | Installomator + learn.microsoft.com |

## Key constraints (from vendor docs)

- **No side-by-side installs** — only one Office version per Mac.
- **App bundles are read-only after deploy** — app sandboxing means you cannot
  customize/patch the bundle (e.g. deleting resource files breaks the app).
- The suite installer is smaller than the sum of individual app installers
  (shared fonts/frameworks/proofing tools copied into each app at install).
- **Teams is included** in the Office 365 installer; a separate installer without
  Teams is available.

## Vendor sources (where the information came from)

1. Microsoft Learn — *Deployment options for admins for Office for Mac*:
   https://learn.microsoft.com/en-us/microsoft-365-apps/mac/deployment-options-for-office-for-mac
2. Microsoft Learn — *Most current packages for Office for Mac* (CDN links):
   https://learn.microsoft.com/en-us/microsoft-365-apps/mac/most-current-packages-for-office-for-mac
3. Microsoft Learn — *Deploy updates for Office for Mac* (msupdate):
   https://learn.microsoft.com/en-us/microsoft-365-apps/mac/deploy-updates-for-office-for-mac
4. Installomator `Installomator.sh` — `microsoftoffice365` label entry
   (github.com/Installomator/Installomator), used to cross-check the fwlink,
   package ID, Team ID, and `msupdate` update path.

## How `lib/office.sh` maps to the research

- `suite_installer_url` → the fwlink from source #4.
- `latest_version` → HEAD-requests the fwlink, extracts the version from the
  redirected package file name (source #2/#3 naming).
- `install` → downloads the suite installer and installs it via Apple `installer`
  (matches sources #1/#2).
- `update` → runs `msupdate --install` (source #3) with a fallback to the
  `msupdate` path used by Installomator.
- `is_installed` / `installed_path` → detect core Office app bundles.
