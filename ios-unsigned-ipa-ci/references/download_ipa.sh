#!/bin/sh
# Usage: sh download_ipa.sh <owner> <repo> [run_id]
OWNER="$1"
REPO="$2"
RUN_ID="$3"
TMPDIR="/tmp/makeipa.$$"
mkdir -p "$TMPDIR"

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
  echo "usage: sh download_ipa.sh <owner> <repo> [run_id]" >&2
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
  RUN_ID=$(api "https://api.github.com/repos/$OWNER/$REPO/actions/runs?per_page=10" | jq -r '.workflow_runs[] | select(.conclusion=="success") | .id' | head -n 1)
fi

if [ -z "$RUN_ID" ] || [ "$RUN_ID" = "null" ]; then
  echo "no successful run found" >&2
  exit 4
fi

ART_JSON="$TMPDIR/artifacts.json"
api "https://api.github.com/repos/$OWNER/$REPO/actions/runs/$RUN_ID/artifacts" > "$ART_JSON"
DL_URL=$(jq -r '.artifacts[] | select((.name|ascii_downcase|test("ipa")) or (.archive_download_url != null)) | .archive_download_url' "$ART_JSON" | head -n 1)

if [ -z "$DL_URL" ] || [ "$DL_URL" = "null" ]; then
  echo "no artifact download url found for run $RUN_ID" >&2
  exit 5
fi

ZIP="$TMPDIR/artifact.zip"
curl -sSL -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" "$DL_URL" -o "$ZIP"
unzip -o -q "$ZIP" -d "$TMPDIR/unzipped" >/dev/null 2>&1
IPA=$(find "$TMPDIR/unzipped" -name '*.ipa' | head -n 1)

if [ -z "$IPA" ]; then
  echo "artifact downloaded but no .ipa found" >&2
  exit 6
fi

BASENAME=$(basename "$IPA")
DEST="/var/minis/attachments/$BASENAME"
cp "$IPA" "$DEST"
printf 'Run ID: %s\n' "$RUN_ID"
printf 'Saved: %s\n' "$DEST"
printf 'Minis URL: minis://attachments/%s\n' "$BASENAME"
