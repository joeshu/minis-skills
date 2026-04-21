#!/bin/sh
set -eu
BASE="/var/minis/shared/minis-skills/published-systems/memory-topics-governance/files"
TS=$(date +%Y%m%d_%H%M%S)
BK="/var/minis/shared/memory_restore_backup_$TS"
mkdir -p "$BK/memory_topics" "$BK/skills/open-minis-memory-store" "$BK/memory"
cp -f /var/minis/shared/memory_topics/*.md "$BK/memory_topics/" 2>/dev/null || true
cp -f /var/minis/skills/open-minis-memory-store/SKILL.md "$BK/skills/open-minis-memory-store/" 2>/dev/null || true
cp -f /var/minis/memory/GLOBAL.md "$BK/memory/" 2>/dev/null || true
mkdir -p /var/minis/shared/memory_topics /var/minis/skills/open-minis-memory-store /var/minis/memory
cp -f "$BASE/memory_topics/"*.md /var/minis/shared/memory_topics/
cp -f "$BASE/skills/open-minis-memory-store/SKILL.md" /var/minis/skills/open-minis-memory-store/
cp -f "$BASE/memory/GLOBAL.md" /var/minis/memory/GLOBAL.md
echo "restored_from=$BASE"
echo "backup_at=$BK"
