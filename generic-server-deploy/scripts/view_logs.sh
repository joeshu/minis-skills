#!/bin/sh
# 日志查看脚本
# 用法: SERVICE=nginx [LINES=100] ./view_logs.sh

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"
SERVICE="${SERVICE:-}"
LINES="${LINES:-100}"
FILE="${FILE:-}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

if [ -n "$SERVICE" ]; then
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "journalctl -u $SERVICE -n $LINES --no-pager"
elif [ -n "$FILE" ]; then
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "tail -n $LINES $FILE"
else
  echo "ERROR: 需要设置 SERVICE 或 FILE 环境变量"
  echo "示例: SERVICE=nginx ./view_logs.sh"
  echo "示例: FILE=/var/log/syslog ./view_logs.sh"
  exit 1
fi
