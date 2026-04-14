#!/bin/sh
# Usage: sh check_actions.sh <owner> <repo> [limit]
OWNER="$1"
REPO="$2"
LIMIT="${3:-5}"

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
  echo "usage: sh check_actions.sh <owner> <repo> [limit]" >&2
  exit 2
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo '{"error":"GITHUB_TOKEN not set"}'
  exit 3
fi

URL="https://api.github.com/repos/$OWNER/$REPO/actions/runs?per_page=$LIMIT"
curl -sSL \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "$URL" | jq '{total_count, runs: [.workflow_runs[] | {id, run_number, name, status, conclusion, head_branch, head_sha, html_url}]}'
