#!/bin/sh
# 服务器环境检查脚本
# 用法: ALI=密码 ./check_server_env.sh

set -e

. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

echo "=== 服务器环境检查 ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 "${TARGET_USER}@${TARGET_HOST}" '
  echo "--- 系统信息 ---"
  uname -a
  echo "--- OS版本 ---"
  cat /etc/os-release | head -5
  echo "--- 架构 ---"
  arch
  echo "--- glibc版本 ---"
  ldd --version | head -1
  echo "--- OpenSSL版本 ---"
  openssl version
  echo "--- 可用包管理器 ---"
  which dnf yum apt apk 2>/dev/null | head -4 || echo "none_found"
  echo "--- 磁盘空间 ---"
  df -h /tmp /usr | tail -2
' || {
  echo "ERROR: SSH连接失败"
  exit 1
}

echo "=== 检查完成 ==="
