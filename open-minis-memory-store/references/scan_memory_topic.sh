#!/bin/sh
# Usage: sh scan_memory_topic.sh <keyword1> [keyword2] [keyword3] ...
# Scan Minis memory files for topic-related entries.

if [ "$#" -lt 1 ]; then
  echo "usage: sh scan_memory_topic.sh <keyword1> [keyword2] ..." >&2
  exit 2
fi

MEM_DIR="/var/minis/memory"
TMP="/tmp/memory-scan.$$"
mkdir -p "$TMP"
OUT="$TMP/result.txt"
: > "$OUT"

for f in "$MEM_DIR"/*.md; do
  [ -f "$f" ] || continue
  hit=yes
  for kw in "$@"; do
    grep -qi "$kw" "$f" || { hit=no; break; }
  done
  if [ "$hit" = yes ]; then
    echo "===== FILE: $f =====" >> "$OUT"
    grep -Ein -C 2 "$(printf '%s' "$1")" "$f" >> "$OUT" 2>/dev/null || sed -n '1,220p' "$f" >> "$OUT"
    echo >> "$OUT"
  fi
done

cat "$OUT"
