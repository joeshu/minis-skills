#!/bin/sh
# 在服务器执行命令
# 用法: CMD="ls -la" ./exec_cmd.sh

CMD="${CMD:-}"
. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

if [ -z "$CMD" ]; then
  echo "ERROR: 需要设置 CMD 环境变量"
  echo "示例: CMD=\"ls -la\" ./exec_cmd.sh"
  exit 1
fi

echo "=== 执行命令 ==="
echo "目标主机: 以环境变量指定"
echo "目标用户: $TARGET_USER"
echo "命令: $CMD"
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "$CMD"
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo ""
  echo "WARNING: 命令返回非零退出码: $EXIT_CODE"
fi
