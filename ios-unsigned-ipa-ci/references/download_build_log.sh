#!/bin/sh
# Usage: sh download_build_log.sh <owner> <repo> [run_id]
OWNER="$1"
REPO="$2"
RUN_ID="$3"
TMPDIR="/tmp/makeipa-log.$$"
mkdir -p "$TMPDIR"

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
  echo "usage: sh download_build_log.sh <owner> <repo> [run_id]" >&2
  exit 2
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN not set" >&2
  exit 3
fi

api() {
  curl -sSL -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" "$1"
}

if [ -z "$RUN_ID" ]; then
  RUN_ID=$(api "https://api.github.com/repos/$OWNER/$REPO/actions/runs?per_page=10" | jq -r '.workflow_runs[] | select(.conclusion=="failure" or .conclusion=="cancelled" or .conclusion=="timed_out") | .id' | head -n 1)
fi

if [ -z "$RUN_ID" ] || [ "$RUN_ID" = "null" ]; then
  echo "no failed run found" >&2
  exit 4
fi

ZIP="$TMPDIR/run_logs.zip"
curl -sSL \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$OWNER/$REPO/actions/runs/$RUN_ID/logs" \
  -o "$ZIP"

unzip -o -q "$ZIP" -d "$TMPDIR/unzipped" >/dev/null 2>&1
OUT="/var/minis/attachments/build-${OWNER}-${REPO}-${RUN_ID}.log"
find "$TMPDIR/unzipped" -type f | while read -r f; do
  echo "===== $f =====" >> "$OUT"
  cat "$f" >> "$OUT"
  echo >> "$OUT"
done

if [ ! -f "$OUT" ]; then
  echo "failed to extract logs" >&2
  exit 5
fi

printf 'Run ID: %s\n' "$RUN_ID"
printf 'Saved: %s\n' "$OUT"
printf 'Minis URL: minis://attachments/%s\n' "$(basename "$OUT")"
