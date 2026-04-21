#!/bin/sh
# 查看服务器系统状态

. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" '
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
