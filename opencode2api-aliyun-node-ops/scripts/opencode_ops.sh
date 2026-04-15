#!/bin/sh
set -e
CMD="$1"
shift || true
BASE="/var/minis/skills/opencode2api-aliyun-node-ops/scripts"
case "$CMD" in
  snapshot)
    exec sh "$BASE/local_repo_snapshot.sh" "$@"
    ;;
  prepush)
    exec sh "$BASE/pre_push_check.sh" "$@"
    ;;
  deploy)
    exec sh "$BASE/deploy_verify_remote.sh" "$@"
    ;;
  smoke)
    exec sh "$BASE/smoke_api_remote.sh" "$@"
    ;;
  rollback)
    exec sh "$BASE/rollback_remote.sh" "$@"
    ;;
  report)
    exec sh "$BASE/release_report_template.sh" "$@"
    ;;
  *)
    echo "Usage: sh $BASE/opencode_ops.sh {snapshot|prepush|deploy|smoke|rollback|report}"
    echo "  snapshot  Show local repo snapshot"
    echo "  prepush   Show pre-push checks"
    echo "  deploy    Check Actions green, then deploy/verify remote"
    echo "  smoke     Run remote API smoke checks (models/chat/responses)"
    echo "  rollback  Roll back remote repo (requires TARGET env)"
    echo "  report    Print release report template"
    exit 1
    ;;
esac
