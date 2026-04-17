#!/bin/sh
set -eu

MODE="${1:-check}"
REPO_DIR="${2:-/var/minis/mounts/minis-skills}"
TARGET_SUBDIR="${3:-published-systems/memory-topics-governance}"
INCLUDE_GLOBAL="${INCLUDE_GLOBAL:-1}"
RESTORE_GLOBAL="${RESTORE_GLOBAL:-1}"
SRC_DIR="/var/minis/shared/memory_topics"
GLOBAL_FILE="/var/minis/memory/GLOBAL.md"
BACKUP_ROOT="/var/minis/shared/backups/memory-topics-governance"
TS="$(date +%Y%m%d-%H%M%S)"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing command: $1" >&2
    exit 1
  }
}

need_cmd git
need_cmd find
need_cmd cp
need_cmd mkdir
need_cmd rm

if [ ! -d "$REPO_DIR/.git" ]; then
  echo "repo_not_found: $REPO_DIR" >&2
  exit 2
fi

TARGET_DIR="$REPO_DIR/$TARGET_SUBDIR"
MIRROR_DIR="$TARGET_DIR/shared/memory_topics"
MEMORY_DIR="$TARGET_DIR/memory"
SCRIPTS_DIR="$TARGET_DIR/scripts"
BACKUP_DIR="$BACKUP_ROOT/$TS"

list_files() {
  find "$SRC_DIR" -maxdepth 1 -type f \
    \( -name 'TopicIndex.md' -o -name 'SystemArchitecture.md' -o -name 'global_memory_style_and_retrieval_rules.md' \
    -o -name 'ResponseStyle-AGENTS.md' -o -name 'ResponseStyle-HighDensity.md' -o -name 'ResponseModePrefixes.md' \
    -o -name 'RulePriorityAndConflictResolution.md' -o -name 'TaskRoutingMatrix.md' -o -name 'NegativeTriggers.md' \
    -o -name 'OutputAcceptanceChecklist.md' -o -name 'FailurePatterns.md' -o -name 'AnswerScopeBudget.md' \
    -o -name 'TopicMetadataSchema.md' -o -name 'memory-topics-consistency-audit-report.md' -o -name 'README.md' \) | sort
}

generate_assets() {
  mkdir -p "$TARGET_DIR" "$MIRROR_DIR" "$MEMORY_DIR" "$SCRIPTS_DIR"
  rm -f "$MIRROR_DIR"/*.md
  for f in $(list_files); do
    cp "$f" "$MIRROR_DIR/"
  done
  if [ "$INCLUDE_GLOBAL" = "1" ] && [ -f "$GLOBAL_FILE" ]; then
    cp "$GLOBAL_FILE" "$MEMORY_DIR/GLOBAL.md"
  else
    rm -f "$MEMORY_DIR/GLOBAL.md"
  fi
  cat > "$TARGET_DIR/README.md" <<'EOF'
# memory-topics-governance

A publishable mirror of the Minis response-style and retrieval-governance system.

## Source
- `/var/minis/shared/memory_topics/`
- `/var/minis/memory/GLOBAL.md`

## Restore
See `RESTORE.md`.
EOF
  cat > "$TARGET_DIR/REPORT.md" <<'EOF'
# REPORT

## Scope
- Mirrors the current response-style / retrieval-governance system from Minis shared memory topics.
- Includes `GLOBAL.md` by default.
- Keeps the publish set isolated under a dedicated repository folder.

## Safety
- Only adds the target subdirectory.
- Excludes daily memory and unrelated runtime files by default.
EOF
  cat > "$TARGET_DIR/RESTORE.md" <<'EOF'
# RESTORE

## Restore shared topics
- Copy `shared/memory_topics/*.md` to `/var/minis/shared/memory_topics/`

## Restore GLOBAL.md
- Copy `memory/GLOBAL.md` to `/var/minis/memory/GLOBAL.md`
- Restore only after backing up local current version

## Notes
- Do not treat this folder as a full backup of daily memory.
EOF
  cat > "$TARGET_DIR/execution-samples.md" <<'EOF'
# execution samples

- check: inspect repo path, publish scope, and excluded files
- sync: refresh target folder without push
- push: sync, add only target subdir, commit, push
- restore-check: show local files that would be overwritten
- restore-sync: back up local files first, then restore shared topics and GLOBAL.md
EOF
}

check_phase() {
  echo "mode=$MODE"
  echo "repo=$REPO_DIR"
  echo "target=$TARGET_SUBDIR"
  echo "include_global=$INCLUDE_GLOBAL"
  echo "files_to_sync:"
  list_files
  if [ "$INCLUDE_GLOBAL" = "1" ] && [ -f "$GLOBAL_FILE" ]; then
    echo "$GLOBAL_FILE"
  fi
}

sync_phase() {
  generate_assets
  echo "synced_to=$TARGET_DIR"
}

push_phase() {
  generate_assets
  cd "$REPO_DIR"
  git add "$TARGET_SUBDIR"
  if git diff --cached --quiet -- "$TARGET_SUBDIR"; then
    echo "nothing_to_commit"
    exit 0
  fi
  git commit -m "feat: publish memory topics governance system"
  git push
}

restore_check_phase() {
  if [ ! -d "$MIRROR_DIR" ]; then
    echo "mirror_not_found: $MIRROR_DIR" >&2
    exit 4
  fi
  echo "mode=$MODE"
  echo "repo=$REPO_DIR"
  echo "target=$TARGET_SUBDIR"
  echo "backup_dir=$BACKUP_DIR"
  echo "shared_files_to_restore:"
  find "$MIRROR_DIR" -maxdepth 1 -type f -name '*.md' | sort
  if [ "$RESTORE_GLOBAL" = "1" ] && [ -f "$MEMORY_DIR/GLOBAL.md" ]; then
    echo "global_to_restore=$MEMORY_DIR/GLOBAL.md"
  fi
}

restore_sync_phase() {
  if [ ! -d "$MIRROR_DIR" ]; then
    echo "mirror_not_found: $MIRROR_DIR" >&2
    exit 4
  fi
  mkdir -p "$BACKUP_DIR/shared/memory_topics" "$BACKUP_DIR/memory"
  if [ -d "$SRC_DIR" ]; then
    find "$SRC_DIR" -maxdepth 1 -type f -name '*.md' -exec cp {} "$BACKUP_DIR/shared/memory_topics/" \;
  fi
  if [ -f "$GLOBAL_FILE" ]; then
    cp "$GLOBAL_FILE" "$BACKUP_DIR/memory/GLOBAL.md"
  fi
  mkdir -p "$SRC_DIR"
  find "$MIRROR_DIR" -maxdepth 1 -type f -name '*.md' -exec cp {} "$SRC_DIR/" \;
  if [ "$RESTORE_GLOBAL" = "1" ] && [ -f "$MEMORY_DIR/GLOBAL.md" ]; then
    mkdir -p /var/minis/memory
    cp "$MEMORY_DIR/GLOBAL.md" "$GLOBAL_FILE"
  fi
  echo "restored_from=$TARGET_DIR"
  echo "backup_saved_to=$BACKUP_DIR"
}

case "$MODE" in
  check) check_phase ;;
  sync) sync_phase ;;
  push) push_phase ;;
  restore-check) restore_check_phase ;;
  restore-sync) restore_sync_phase ;;
  *) echo "unsupported mode: $MODE" >&2; exit 3 ;;
esac
