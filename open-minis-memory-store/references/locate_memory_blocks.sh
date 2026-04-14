#!/bin/sh
# Usage: sh locate_memory_blocks.sh <keyword1> [keyword2] ...
# Print candidate memory blocks with line ranges from /var/minis/memory/*.md

if [ "$#" -lt 1 ]; then
  echo "usage: sh locate_memory_blocks.sh <keyword1> [keyword2] ..." >&2
  exit 2
fi

for f in /var/minis/memory/*.md; do
  [ -f "$f" ] || continue
  awk -v file="$f" '
    BEGIN { RS=""; FS="\n" }
    {
      block=$0
      ok=1
      for (i=1; i<ARGC; i++) {
        kw=ARGV[i]
        if (kw != "" && index(tolower(block), tolower(kw)) == 0) ok=0
      }
      if (ok) {
        n=split(block, lines, "\n")
        title=""
        for (j=1; j<=n; j++) if (lines[j] ~ /^## /) { title=lines[j]; break }
        print "===== FILE: " file " ====="
        if (title != "") print title
        print block
        print ""
      }
    }
  ' "$@" "$f"
done
