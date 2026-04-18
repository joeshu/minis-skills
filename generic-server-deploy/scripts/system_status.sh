#!/bin/sh
# 查看服务器系统状态

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" '
  echo "=== CPU ==="
  top -bn1 | head -3
  echo "=== 内存 ==="
  free -h
  echo "=== 磁盘 ==="
  df -h
  echo "=== 网络 ==="
  ip addr | grep inet
  echo "=== 负载 ==="
  cat /proc/loadavg
'
