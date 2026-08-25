#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
assets_dir="$repo_dir/assets"

find "$assets_dir/design" -maxdepth 1 -type f -name '*.webp' -printf '%f\n' | sort -V | jq -Rsc 'split("\n") | map(select(length > 0))' > /tmp/sovann-design.json
find "$assets_dir/poster" -maxdepth 1 -type f -name '*.webp' -printf '%f\n' | sort -V | jq -Rsc 'split("\n") | map(select(length > 0))' > /tmp/sovann-poster.json
find "$assets_dir/photography" -maxdepth 1 -type f -name '*.webp' ! -name 'profile-*' -printf '%f\n' | sort -V | jq -Rsc 'split("\n") | map(select(length > 0))' > /tmp/sovann-photography.json

jq -n \
  --slurpfile design /tmp/sovann-design.json \
  --slurpfile poster /tmp/sovann-poster.json \
  --slurpfile photography /tmp/sovann-photography.json \
  '{design: $design[0], poster: $poster[0], photography: $photography[0], video: []}' > "$assets_dir/gallery.json"

echo "Updated assets/gallery.json"
