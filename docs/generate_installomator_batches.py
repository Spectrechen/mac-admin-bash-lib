#!/usr/bin/env python3
"""Generate macAdmin-library integration batches from the Installomator inventory.

Reads docs/installomator-inventory.json (the machine-readable Installomator
label inventory produced by task t_bed237f4) and writes one JSON file per batch
under docs/installomator-batches/. Each batch file is a plain list of Installomator
labels. A kanban child task integrates every label in one batch file into the
macAdmin library (one lib/<module>.sh entry per app) following docs/entry-template.md.

Usage:
    python3 docs/generate_installomator_batches.py
        [--inventory docs/installomator-inventory.json]
        [--out docs/installomator-batches]
        [--batch-size 150]

The output is deterministic: same inventory + same parameters => same files.
Run it whenever the Installomator inventory changes to refresh the batches.
"""
from __future__ import annotations

import argparse
import json
import os
import re
from collections import defaultdict


# Installomator labels whose app is already integrated into the library (module
# name == label prefix). These are skipped so the generator only emits *remaining*
# labels. Keep in sync with lib/*.sh app module files (NOT vendor clusters such
# as java/adobe/microsoft/jamf, which are still to be integrated).
INTEGRATED_PREFIXES = {
    "office", "chrome", "firefox", "zoom", "1password", "slack", "dropbox",
    "notion", "vlc", "signal", "libreoffice", "iterm", "figma", "chatgpt",
}

# Functional category keyword prefixes. First match wins; "misc" is the fallback.
CATEGORY_RULES = [
    ("devops_and_developer_tools", [
        "docker", "postgres", "postgresql", "anaconda", "androidstudio",
        "netbeans", "intellij", "webstorm", "phpstorm", "pycharm", "goland",
        "rust", "postman", "insomnia", "redis", "electron", "atom", "cursor",
        "vscode", "code", "visualstudio", "xcode", "git", "sourcetree", "fork",
        "sublime", "vim", "neovim", "emacs", "latex", "tex", "pandoc", "node",
        "npm", "yarn", "deno", "homebrew", "podman", "fastlane", "terraform",
        "packer", "vault", "consul", "nomad", "jenkins", "gitlab", "sonar",
        "nexus", "artifactory", "jfrog", "kubectl", "helm",
    ]),
    ("creative_and_media", [
        "camtasia", "snagit", "cut", "finalcut", "logic", "audition",
        "garageband", "imovie", "sketchup", "affinity", "autodesk", "blender",
        "cinema", "max", "substance", "unity", "unreal", "gimp", "krita",
        "inkscape", "photopea", "garmin",
    ]),
    ("communication_and_collaboration", [
        "airtable", "aircall", "airtame", "amadeus", "amazonchime", "anydesk",
        "discord", "facetime", "googlemeet", "hangouts", "jitsi", "skype",
        "teams", "zoom", "mmhmm", "tortalk", "soundly",
    ]),
]


def category(label: str) -> str:
    prefix = re.split(r"[-_.]", label)[0]
    for cat, keywords in CATEGORY_RULES:
        if any(k in prefix for k in keywords):
            return cat
    return "misc"


def is_integrated(label: str) -> bool:
    prefix = re.split(r"[-_.]", label)[0]
    return any(prefix == p or prefix.startswith(p) for p in INTEGRATED_PREFIXES)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--inventory", default="docs/installomator-inventory.json")
    ap.add_argument("--out", default="docs/installomator-batches")
    ap.add_argument("--batch-size", type=int, default=150)
    args = ap.parse_args()

    inventory = json.load(open(args.inventory))
    labels = [x.get("label") for x in inventory if x.get("label")]

    remaining = [l for l in labels if not is_integrated(l)]

    # Group remaining labels by functional category, then split misc into
    # fixed-size sub-batches.
    by_cat: dict[str, list[str]] = defaultdict(list)
    for label in remaining:
        by_cat[category(label)].append(label)

    batches: dict[str, dict] = {}
    for cat, labels_in_cat in by_cat.items():
        if cat == "misc":
            for i in range(0, len(labels_in_cat), args.batch_size):
                chunk = labels_in_cat[i:i + args.batch_size]
                batches[f"misc_batch_{i // args.batch_size}"] = {
                    "category": "misc",
                    "labels": chunk,
                }
        else:
            batches[cat] = {"category": cat, "labels": labels_in_cat}

    os.makedirs(args.out, exist_ok=True)
    written = 0
    for name, spec in sorted(batches.items()):
        path = os.path.join(args.out, f"{name}.json")
        json.dump(spec["labels"], open(path, "w"), indent=2, ensure_ascii=False)
        written += 1
        print(f"{name}: {len(spec['labels'])} labels -> {path}")

    print(f"\nTotal remaining labels: {len(remaining)}")
    print(f"Wrote {written} batch files to {args.out}/")


if __name__ == "__main__":
    main()
