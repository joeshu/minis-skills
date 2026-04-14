#!/bin/sh
# Usage: sh build_master_memory.sh <title> <input_file>
# Build a draft master memory from scanned topic text.

TITLE="$1"
INPUT="$2"

if [ -z "$TITLE" ] || [ -z "$INPUT" ]; then
  echo "usage: sh build_master_memory.sh <title> <input_file>" >&2
  exit 2
fi

if [ ! -f "$INPUT" ]; then
  echo "input file not found: $INPUT" >&2
  exit 3
fi

OUT="/tmp/master-memory-$$.md"
{
  echo "## $TITLE"
  grep -v '^===== FILE:' "$INPUT" \
    | grep -v '^--$' \
    | sed 's/^[0-9][0-9]*[:-]//g' \
    | sed 's/^\s\+//g' \
    | sed '/^\s*$/d' \
    | head -n 30 \
    | while IFS= read -r line; do
        echo "- $line"
      done
} > "$OUT"

cat "$OUT"
