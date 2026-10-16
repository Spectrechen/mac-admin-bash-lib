# AppsAnywhere Client (appsanywhere)

## Vendor
AppsAnywhere (Citrix)

## Source
- Docs Portal: https://docs.appsanywhere.com/appsanywhere/3.2/appsanywhere-client-macos
- GitHub: https://github.com/AppsAnywhere/client-macos (if available)
- AppsAnywhere is a software delivery platform for educational institutions.

## Installer Details
- **Label:** appsanywhere
- **Name:** AppsAnywhere Client (macOS)
- **Type:** pkg
- **Installer URL:** https://docs.appsanywhere.com/appsanywhere/3.2/appsanywhere-client-macos
- **Download URL Pattern:**
  `https://files.appsanywhere.com/clients/appsanywhere/mac/<version>/apps-anywhere-setup-InstitutionId-<version>.pkg`
  Note: InstitutionId is institution-specific; generic fallback uses GitHub releases.
- **Package ID:** com.appsanywhere.client (inferred from app bundle)
- **Team ID:** 9ZNX23CMVD
- **App Location:** /Applications/AppsAnywhere/AppsAnywhere.app
- **Update Tool:** /Applications/AppsAnywhere/AppsAnywhere Updater.app

## Versioning
- `latest_version()` scrapes the docs page for version pattern:
  `id="AppsAnywhereClient(macOS)-VersionX.Y.Z(CurrentVersion)"`
- Fallback: tries GitHub Releases API, then returns "0" on failure

## Install/Update/Uninstall
- **Install:** Downloads the PKG from the institution-specific URL or GitHub releases, installs via `installer`. Requires root.
- **Update:** Same as install (reinstalls latest).
- **Uninstall:** Removes app bundle, support files, launch daemons, and launch agents.

## Notes
- Institution-specific installer URLs may not work for all deployments.
- The GitHub releases fallback provides a more universal installer.
- Background services run as a LaunchDaemon for continuous monitoring.
- Used for software catalog delivery in educational environments.
