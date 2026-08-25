# macAdmin Library — App Entry Template

Repeatable schema for integrating an application into the macAdmin Bash Library
following the `maclib::<module>::<name>` convention used by `lib/office.sh`
(Microsoft Office 365 for Mac).

Use this template to add any remaining app from the Installomator master
inventory consistently — without re-deriving the structure each time.

---

## 1. What an "entry" is

An entry is a single module file `lib/<module>.sh` exposing a set of
`maclib::<module>::<function>()` helpers, wired into:

- `lib/maclib.sh` (a `source` line),
- `docs/function-catalog.md` (one row per function),
- `tests/test_modules.bats` (one `@test` per function),
- optionally `docs/<app>-vendor-notes.md` (the vendor research behind the values).

The Office entry (`lib/office.sh`) is the reference implementation.

---

## 2. Required fields (one per entry)

Every entry MUST document these fields. If a field cannot be filled from a
trusted vendor source, that is a blocker — do not guess.

| # | Field | Where it lives | Office example |
|---|-------|---------------|----------------|
| 1 | **App name** | module filename + namespace | Office 365 for Mac → `lib/office.sh`, `maclib::office::*` |
| 2 | **Vendor source** | the authoritative doc(s) / Installomator label that the values were taken from | learn.microsoft.com mac deployment pages + Installomator `microsoftoffice365` label |
| 3 | **Installer type** | how the vendor ships the product (`.pkg`, `.dmg`, `.zip`, `.app`, `.app+helper`) | Apple `.pkg` suite installer from the Office CDN |
| 4 | **Download strategy** | how to fetch the artifact (direct URL, fwlink/redirect, archive, app-copy) and whether root is required | `curl -fsL <fwlink> -o <tmp.pkg>` then `/usr/sbin/installer -pkg <tmp> -target` (root) |
| 5 | **Version handling** | how `latest_version` derives the current build (parse package name, `CFBundleShortVersionString`, vendor JSON) | HEAD the fwlink, parse dotted version from the redirected package file name (`16.112.26081720`) |
| 6 | **Install behavior** | what `install()` does, root requirement, side effects | download suite installer + Apple `installer` |
| 7 | **Update behavior** | how updates are applied (vendor updater tool, reinstall, MAU) | `msupdate --install` (Microsoft AutoUpdate), fall back to `msupdate` on PATH |
| 8 | **Uninstall behavior** | how to remove it (bundle removal, pkg receipt cleanup, or "no clean uninstall") | *none* — documented constraint (Office has no clean uninstall; only one version per Mac) |
| 9 | **Detection** | how `is_installed` / `installed_path` identify it (app bundle names, package ID, receipt) | core app bundles Word/Excel/Outlook/PowerPoint/OneNote in `/Applications` and `$HOME/Applications` |
| 10 | **Tests** | bats coverage per function, including mocked network | 5 tests: url, version (mocked redirect), version-failure, is_installed, installed_path |

---

## 3. Filled example — Microsoft Office 365 for Mac

- **App name:** Office 365 for Mac (the suite installer) — module `office`
- **Vendor source:**
  - `learn.microsoft.com/en-us/microsoft-365-apps/mac/deployment-options-for-office-for-mac`
  - `learn.microsoft.com/en-us/microsoft-365-apps/mac/most-current-packages-for-office-for-mac`
  - `learn.microsoft.com/en-us/microsoft-365-apps/mac/deploy-updates-for-office-for-mac`
  - Installomator `Installomator.sh` `microsoftoffice365` label (fwlink, package ID, Team ID cross-check)
- **Installer type:** Apple `.pkg` suite installer, distributed from the Office CDN.
- **Download strategy:** HEAD the fwlink `https://go.microsoft.com/fwlink/?linkid=525133`
  → resolves (200+ redirect) to `…/Microsoft_365_and_Office_<version>_Installer.pkg`.
  Download with `curl -fsL`, install with `/usr/sbin/installer -pkg <tmp> -target` (root).
- **Version handling:** `latest_version()` HEADs the fwlink, extracts the dotted
  version embedded in the redirected package file name (last two underscores).
- **Install behavior:** `install()` downloads the suite installer to a temp file
  (cleanup via `trap … RETURN`) and runs `/usr/sbin/installer` with passthrough
  `-target` options. Requires root.
- **Update behavior:** `update()` runs `msupdate --install` (Microsoft AutoUpdate),
  locating the tool at
  `/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate`
  or falling back to `msupdate` on PATH.
- **Uninstall behavior:** *No clean uninstall.* Vendor constraint: only one Office
  version per Mac; app bundles are read-only after deploy (sandboxing). Documented,
  not implemented.
- **Detection:** `is_installed()` returns 0 if any core bundle (Word/Excel/Outlook/
  PowerPoint/OneNote) exists in `/Applications` or `$HOME/Applications`;
  `installed_path()` prints the first match.
- **Tests (5):** url returns the fwlink; version extracts `16.112.26081720` from a
  mocked redirect; version fails when no redirect is returned; `is_installed` and
  `installed_path` behave when Office is absent.

---

## 4. How to apply this to any Installomator app

1. **Inventory.** Clone/refresh the Installomator repo and read `Labels.txt` plus
   the per-label case in `Installomator.sh` to find the target app's label.
2. **Vendor source.** Locate the authoritative vendor doc for that app's install
   and update method. Record the URLs (field #2). If no trusted source exists,
   **block** the entry rather than guessing.
3. **Installer type.** Determine how the vendor ships it (`.pkg`/`.dmg`/`.zip`/
   `.app`) and whether it requires root (field #3).
4. **Download strategy.** Decide the fetch method: direct URL, fwlink/redirect,
   archive extraction, or app-copy. Write the `install()` function to fetch and
   apply it (field #4).
5. **Version handling.** Pick how to derive the current build — parse a package
   name, read `CFBundleShortVersionString` from an installed bundle, or parse
   vendor JSON. Write `latest_version()` (field #5).
6. **Detection.** Write `is_installed()` / `installed_path()` (field #9).
7. **Update.** Write `update()` (field #7) — vendor updater tool, reinstall, or
   document "no update path".
8. **Uninstall.** Write `uninstall()` if a clean removal exists; otherwise document
   the constraint as "no clean uninstall" (field #8).
9. **Wire it up.** Add the `source` line to `lib/maclib.sh`, a catalog row to
   `docs/function-catalog.md`, and bats tests to `tests/test_modules.bats`.
10. **Vendor notes.** Write `docs/<app>-vendor-notes.md` recording the sources and
    the concrete vendor-sourced values (fwlink, package ID, Team ID, update tool).
11. **Verify.** Run `make lint`, `make fmt`, `make test` — all must pass.

---

## 5. Files created / modified per entry

| Action | File |
|--------|------|
| Create | `lib/<module>.sh` (the functions) |
| Modify | `lib/maclib.sh` (one `source` line) |
| Modify | `docs/function-catalog.md` (one row per function) |
| Modify | `tests/test_modules.bats` (one `@test` per function) |
| Create (recommended) | `docs/<app>-vendor-notes.md` (sources + concrete values) |

---

## 6. Acceptance checklist

- [ ] `lib/<module>.sh` exists and uses `maclib::<module>::<name>()` namespacing.
- [ ] All 10 required fields documented (this doc, section 2).
- [ ] Vendor source(s) recorded with URLs (field #2).
- [ ] `install()` handles download + apply, with root requirement noted.
- [ ] `latest_version()` derives the current build from a real source.
- [ ] `is_installed()` / `installed_path()` implemented.
- [ ] `update()` implemented OR documented as "no update path".
- [ ] `uninstall()` implemented OR documented as "no clean uninstall".
- [ ] Registered in `lib/maclib.sh`; catalog row added; bats tests added.
- [ ] Vendor notes doc written (if applicable).
- [ ] `make lint`, `make fmt`, `make test` all pass.
