#!/bin/sh
# 连接服务器并汇报状态

. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

echo "=== 连接目标服务器 ==="
echo "用户: $TARGET_USER"
echo "主机: 以环境变量指定"

AUTH_TEST=$(sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o PreferredAuthentications=password -o PubkeyAuthentication=no "${TARGET_USER}@${TARGET_HOST}" 'echo ssh_password_ok' 2>&1)

if echo "$AUTH_TEST" | grep -q "ssh_password_ok"; then
  echo "认证方式: 密码认证"
elif echo "$AUTH_TEST" | grep -q "Permission denied.*publickey"; then
  echo "ERROR: 服务器已禁用密码认证，仅允许公钥认证"
  exit 1
elif echo "$AUTH_TEST" | grep -q "Connection refused\|Connection timed out"; then
  echo "ERROR: 连接失败，SSH服务未启动或网络不可达"
  exit 1
else
  echo "ERROR: 连接失败"
  echo "$AUTH_TEST"
  exit 1
fi

sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 "${TARGET_USER}@${TARGET_HOST}" '
  echo "--- 服务器信息 ---"
  echo "主机名: $(hostname)"
  echo "当前用户: $(whoami)"
  echo "运行时间: $(uptime | awk -F"," "{print \$1}")"
  echo "系统: $(uname -s) $(uname -r)"
  echo "架构: $(uname -m)"
  echo "--- 资源状态 ---"
  echo "磁盘:"
  df -h / | tail -1
  echo "内存:"
  free -h | grep "Mem:"
  echo "--- 连通成功 ---"
' || {
  echo "ERROR: 连接失败"
  echo "可能原因: 网络不可达 / 密码错误 / SSH服务未启动"
  exit 1
}
