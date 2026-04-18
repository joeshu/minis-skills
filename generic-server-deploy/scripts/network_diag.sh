#!/bin/sh
# 网络诊断脚本
# 用法: PORT=8080 ./network_diag.sh 或 HOST=google.com ./network_diag.sh

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"
TARGET="${HOST:-}"
PORT="${PORT:-}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

if [ -n "$PORT" ]; then
  echo "=== 检查端口 $PORT 监听状态 ==="
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "ss -lntp | grep :$PORT"
elif [ -n "$TARGET" ]; then
  echo "=== 连通性测试 $TARGET ==="
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "ping -c 4 $TARGET"
  echo "=== DNS解析 ==="
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "nslookup $TARGET || dig $TARGET"
else
  echo "ERROR: 需要设置 PORT 或 TARGET 环境变量"
  echo "示例: PORT=8080 ./network_diag.sh"
  echo "示例: TARGET=google.com ./network_diag.sh"
  exit 1
fi

echo "=== 防火墙状态 ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "firewall-cmd --state 2>/dev/null && firewall-cmd --list-all || iptables -L -n | head -20"
