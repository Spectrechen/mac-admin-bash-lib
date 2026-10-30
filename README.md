# macadminLibrary

A Bash library of functions macOS admins keep rewriting: small, namespaced (`maclib::...`),
tested, and safe to source from MDM scripts.

**Status:** v2 is a restart of this project and is under active construction. The previous
implementation is preserved at the `v1-archive` tag.

## Goals
- Bash 3.2 compatible (the `/bin/bash` that ships with macOS)
- MDM-agnostic core; vendor adapters (Jamf, Kandji, Mosyle, Intune, ...) kept separate
- Supports the latest two macOS releases
- CI-backed quality: shellcheck, shfmt, bats

## Development
Requires `shellcheck`, `shfmt` and `bats-core`.

```bash
make check
```

## License
Apache License 2.0, see [LICENSE](LICENSE).
