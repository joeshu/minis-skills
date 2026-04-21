#!/bin/sh
# 日志查看脚本
# 用法: SERVICE=nginx [LINES=100] ./view_logs.sh

SERVICE="${SERVICE:-}"
LINES="${LINES:-100}"
FILE="${FILE:-}"
. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

if [ -n "$SERVICE" ]; then
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "journalctl -u $SERVICE -n $LINES --no-pager"
elif [ -n "$FILE" ]; then
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "tail -n $LINES $FILE"
else
  echo "ERROR: 需要设置 SERVICE 或 FILE 环境变量"
  exit 1
fi
