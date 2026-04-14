#!/bin/sh
# make-ipa / ios-unsigned-ipa-ci mode detector
# Usage: sh mode_detect.sh <repo_dir> [owner] [repo]

REPO_DIR="$1"
OWNER="$2"
REPO="$3"

if [ -z "$REPO_DIR" ]; then
  echo "usage: sh mode_detect.sh <repo_dir> [owner] [repo]" >&2
  exit 2
fi

WORKFLOW_FILE="$REPO_DIR/.github/workflows/build-unsigned-ipa.yml"
HAS_GIT=no
HAS_WORKFLOW=no
HAS_PROJECT=no
HAS_XCODEPROJ=no
MODE=A
TOKEN_SET=no

[ -n "$GITHUB_TOKEN" ] && TOKEN_SET=yes
[ -d "$REPO_DIR/.git" ] && HAS_GIT=yes
[ -f "$WORKFLOW_FILE" ] && HAS_WORKFLOW=yes
[ -f "$REPO_DIR/project.yml" ] && HAS_PROJECT=yes
find "$REPO_DIR" -maxdepth 2 \( -name '*.xcodeproj' -o -name '*.xcworkspace' \) | grep -q . && HAS_XCODEPROJ=yes

if [ "$HAS_WORKFLOW" = yes ] || { [ "$HAS_PROJECT" = yes ] && [ "$HAS_XCODEPROJ" = yes ]; }; then
  MODE=B
fi

printf '{\n'
printf '  "repo_dir": "%s",\n' "$REPO_DIR"
printf '  "token_set": "%s",\n' "$TOKEN_SET"
printf '  "has_git": "%s",\n' "$HAS_GIT"
printf '  "has_workflow": "%s",\n' "$HAS_WORKFLOW"
printf '  "has_project_yml": "%s",\n' "$HAS_PROJECT"
printf '  "has_xcodeproj_or_workspace": "%s",\n' "$HAS_XCODEPROJ"
printf '  "mode": "%s"\n' "$MODE"
printf '}\n'
