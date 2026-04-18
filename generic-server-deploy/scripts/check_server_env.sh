#!/bin/sh
# 服务器环境检查脚本
# 用法: ALI=密码 ./check_server_env.sh

set -e

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

echo "=== 服务器环境检查 ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 "${USER}@${HOST}" '
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
  which dnf yum apt 2>/dev/null | head -1 || echo "none_found"
  echo "--- 磁盘空间 ---"
  df -h /tmp /usr | tail -2
' || {
  echo "ERROR: SSH连接失败"
  exit 1
}

echo "=== 检查完成 ==="
