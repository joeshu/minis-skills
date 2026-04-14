#!/bin/sh
# Usage: sh list_required_files.sh <file1> [file2] ...
# Print a markdown list of required files that must be kept.
if [ "$#" -lt 1 ]; then
  echo "usage: sh list_required_files.sh <file1> [file2] ..." >&2
  exit 2
fi
for f in "$@"; do
  [ -n "$f" ] || continue
  echo "- $f"
done
