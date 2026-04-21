#!/bin/sh
# 网络诊断脚本
# 用法: PORT=8080 ./network_diag.sh 或 TARGET=google.com ./network_diag.sh

TARGET="${TARGET:-}"
PORT="${PORT:-}"
. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

if [ -n "$PORT" ]; then
  echo "=== 检查端口 $PORT 监听状态 ==="
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "ss -lntp | grep :$PORT"
elif [ -n "$TARGET" ]; then
  echo "=== 连通性测试 $TARGET ==="
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "ping -c 4 $TARGET"
  echo "=== DNS解析 ==="
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "nslookup $TARGET || dig $TARGET"
else
  echo "ERROR: 需要设置 PORT 或 TARGET 环境变量"
  exit 1
fi

echo "=== 防火墙状态 ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "firewall-cmd --state 2>/dev/null && firewall-cmd --list-all || iptables -L -n | head -20"
