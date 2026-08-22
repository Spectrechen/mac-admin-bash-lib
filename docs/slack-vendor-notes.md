# Slack — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/slack.sh (maclib::slack::*)`` (`maclib::*)::*`)
App: Slack for Mac

## What the vendor says (current, supported installation method)

Slack ships a signed **.pkg** from its API endpoint. The current build is embedded in the redirect Location header of the request. Slack ships a self-updating installer, so updates are applied by re-installing the latest package.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Package installer URL | https://slack.com/api/desktop.latestRelease?redirect=1&variant=pkg&arch=universal | Installomator `slack` label |
| Version source | redirect `Location` header of the API URL (dotted number) | Installomator |
| Team ID | BQR82RBBHL | Installomator |
| Package ID | com.slack.client. | Installomator |

## Key constraints (from vendor docs)

- Slack bundles a self-updating installer that runs in the background.
- For managed deployments, pin the version and re-deploy the package.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `slack` label.
2. Slack desktop API: `https://slack.com/api/desktop.latestRelease`.

## How ``lib/slack.sh (maclib::slack::*)`` maps to the research

- `url` → the signed .pkg API URL.
- `latest_version` → HEAD-requests the API, extracts the dotted version from the redirect Location.
- `install` → downloads the .pkg and installs it via Apple `installer`.
- `is_installed` / `installed_path` → detect `/Applications/Slack.app`.
