#!/bin/sh
# Usage: sh write_session_summary.sh <output_file>
# Reads summary markdown from stdin and writes to file.
OUT="$1"
if [ -z "$OUT" ]; then
  echo "usage: sh write_session_summary.sh <output_file>" >&2
  exit 2
fi
cat > "$OUT"
echo "written: $OUT"
