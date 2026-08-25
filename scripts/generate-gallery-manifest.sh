#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
assets_dir="$repo_dir/assets"

find "$assets_dir/hospitality" -maxdepth 1 -type f -name '*.webp' -printf '%f\n' | sort -V | jq -Rsc 'split("\n") | map(select(length > 0))' > /tmp/sovann-hospitality.json
find "$assets_dir/healthcare" -maxdepth 1 -type f -name '*.webp' -printf '%f\n' | sort -V | jq -Rsc 'split("\n") | map(select(length > 0))' > /tmp/sovann-healthcare.json

jq -n \
  --slurpfile hospitality /tmp/sovann-hospitality.json \
  --slurpfile healthcare /tmp/sovann-healthcare.json \
  '{hospitality: $hospitality[0], healthcare: $healthcare[0]}' > "$assets_dir/gallery.json"

echo "Updated assets/gallery.json"
