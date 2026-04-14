#!/bin/sh
# Usage: sh backup_memory_files.sh <file1> [file2] ...
TS=$(date +%Y%m%d-%H%M%S)
if [ "$#" -lt 1 ]; then
  echo "usage: sh backup_memory_files.sh <file1> [file2] ..." >&2
  exit 2
fi
for f in "$@"; do
  [ -f "$f" ] || continue
  cp "$f" "$f.bak-$TS"
  echo "backup: $f.bak-$TS"
done
