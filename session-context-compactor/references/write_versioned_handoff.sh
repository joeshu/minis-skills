#!/bin/sh
# Usage: sh write_versioned_handoff.sh <topic_slug> <base_dir>
# Reads handoff markdown from stdin, writes timestamped file, and updates latest copy.
TOPIC="$1"
BASE_DIR="$2"
TS=$(date +%Y%m%d-%H%M)

if [ -z "$TOPIC" ] || [ -z "$BASE_DIR" ]; then
  echo "usage: sh write_versioned_handoff.sh <topic_slug> <base_dir>" >&2
  exit 2
fi

mkdir -p "$BASE_DIR/$TOPIC"
OUT="$BASE_DIR/$TOPIC/${TS}-handoff.md"
LATEST="$BASE_DIR/$TOPIC/handoff-latest.md"
cat > "$OUT"
cp "$OUT" "$LATEST"
echo "written: $OUT"
echo "latest: $LATEST"
