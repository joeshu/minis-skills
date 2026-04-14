#!/bin/sh
# Usage: sh rank_required_files.sh <file1> [file2] ...
# Print a simple P0/P1/P2 markdown list.
if [ "$#" -lt 1 ]; then
  echo "usage: sh rank_required_files.sh <file1> [file2] ..." >&2
  exit 2
fi
for f in "$@"; do
  case "$f" in
    *SKILL.md|*session-summary.md|*handoff.md|*execution-context.md)
      echo "- P0 | $f | 删除后会直接影响继续执行"
      ;;
    *README.md|*test-prompts.json|*.sh|*.py|*.json|*.yml|*.yaml)
      echo "- P1 | $f | 建议保留，影响接手效率或执行链完整性"
      ;;
    *)
      echo "- P2 | $f | 可选保留，主要供参考"
      ;;
  esac
done
