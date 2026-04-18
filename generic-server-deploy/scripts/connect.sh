#!/bin/sh
# 连接服务器并汇报状态

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  echo "请设置: [设置环境变量](minis://settings/environments?create_key=ALI)"
  exit 1
fi

echo "=== 连接服务器 ${USER}@${HOST} ==="

# 尝试连接，检测认证方式
AUTH_TEST=$(sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o PreferredAuthentications=password -o PubkeyAuthentication=no "${USER}@${HOST}" 'echo ssh_password_ok' 2>&1)

if echo "$AUTH_TEST" | grep -q "ssh_password_ok"; then
  echo "认证方式: 密码认证"
elif echo "$AUTH_TEST" | grep -q "Permission denied.*publickey"; then
  echo "ERROR: 服务器已禁用密码认证，仅允许公钥认证"
  echo "解决方案:"
  echo "  1. 在服务器上启用密码认证: PasswordAuthentication yes"
  echo "  2. 或使用密钥对登录: ssh -i ~/.ssh/id_rsa ${USER}@${HOST}"
  exit 1
elif echo "$AUTH_TEST" | grep -q "Connection refused\|Connection timed out"; then
  echo "ERROR: 连接失败，SSH服务未启动或网络不可达"
  exit 1
else
  echo "ERROR: 连接失败"
  echo "$AUTH_TEST"
  exit 1
fi

sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 "${USER}@${HOST}" '
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

echo ""
echo "服务器已连通。请告诉我接下来要做什么:"
echo "  - 执行命令: '执行 ls -la'"
echo "  - 部署应用: '部署 https://.../app.rpm'"
echo "  - 上传文件: '上传 本地文件 到 /远程路径'"
echo "  - 查看状态: '查看系统状态'"
