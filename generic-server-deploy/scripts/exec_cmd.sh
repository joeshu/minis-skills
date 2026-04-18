#!/bin/sh
# 在服务器执行命令
# 用法: CMD="ls -la" ./exec_cmd.sh

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"
CMD="${CMD:-}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

if [ -z "$CMD" ]; then
  echo "ERROR: 需要设置 CMD 环境变量"
  echo "示例: CMD=\"ls -la\" ./exec_cmd.sh"
  exit 1
fi

echo "=== 执行命令: $CMD ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "$CMD"
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo ""
  echo "WARNING: 命令返回非零退出码: $EXIT_CODE"
fi
