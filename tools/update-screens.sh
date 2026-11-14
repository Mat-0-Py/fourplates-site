#!/bin/bash
set -euo pipefail

# Copies the app's website screens into screens/ as WebP. Make them first in the app's repository:
#   scripts/screenshots.sh, scripts/watch-screenshots.sh, then swift scripts/frame-screenshots.swift
# which writes Screenshots/website/{light,dark}/. Needs cwebp (Homebrew's webp).
SITE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SOURCE="${1:-$SITE/../FitnessApp/Screenshots/website}"
names=(logger today summary history progress home-screen medal-detail watch-rest)
for appearance in light dark; do
    mkdir -p "$SITE/screens/$appearance"
    for name in "${names[@]}"; do
        cwebp -quiet -q 84 -alpha_q 100 -m 6 "$SOURCE/$appearance/$name.png" -o "$SITE/screens/$appearance/$name.webp"
    done
done
# The Watch looks the same in both appearances: keep one copy.
mv "$SITE/screens/light/watch-rest.webp" "$SITE/screens/watch-rest.webp"
rm "$SITE/screens/dark/watch-rest.webp"
du -ch "$SITE"/screens/*/*.webp "$SITE"/screens/*.webp | tail -1
