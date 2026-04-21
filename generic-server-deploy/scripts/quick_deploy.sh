#!/bin/sh
# 快速部署脚本 v2
# 用法: ALI=密码 URL="下载地址" FILE="文件名" sh quick_deploy.sh

set -e

URL="${URL:-}"
FILE="${FILE:-}"
. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

if [ -z "$URL" ] || [ -z "$FILE" ]; then
  echo "ERROR: 需要设置 URL 和 FILE 环境变量"
  echo "示例: URL=\"https://...\" FILE=\"app.rpm\" ./quick_deploy.sh"
  exit 1
fi

TMPDIR="/tmp/deploy_$(date +%s)"
PKG_NAME=$(echo "$FILE" | sed 's/.*-v[0-9].*//; s/-Linux.*//; s/-x86_64.*//; s/\.rpm$//')

echo "=== 部署信息 ==="
echo "应用: $PKG_NAME"
echo "文件: $FILE"
echo "服务器: 以环境变量指定"
echo ""

echo "=== 第1步: 下载 ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "
mkdir -p $TMPDIR
cd $TMPDIR
echo '下载中...'
curl -fsSL -o '$FILE' '$URL' && echo '下载完成' || { echo '下载失败'; exit 1; }
echo '---文件信息---'
ls -lh '$FILE'
echo '---校验---'
sha256sum '$FILE'
"

echo ""
echo "=== 第2步: 尝试正常安装 ==="
INSTALL_OK=0
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "
cd $TMPDIR
rpm -ivh '$FILE' && echo '安装成功' || echo '安装失败，需要处理依赖'
" && INSTALL_OK=1 || INSTALL_OK=0

if [ "$INSTALL_OK" = "0" ]; then
  echo ""
  echo "=== 第3步: 处理依赖 ==="
  sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "
    cd $TMPDIR
    echo '--- 搜索可用兼容包 ---'
    dnf install -y gtk3 webkit2gtk3 libappindicator-gtk3 2>/dev/null || true

    echo '--- 创建符号链接 ---'
    cd /usr/lib64
    [ -f libwebkit2gtk-4.0.so.37 ] && ln -sf libwebkit2gtk-4.0.so.37 libwebkit2gtk-4.1.so.0 2>/dev/null || true
    [ -f libjavascriptcoregtk-4.0.so.18 ] && ln -sf libjavascriptcoregtk-4.0.so.18 libjavascriptcoregtk-4.1.so.0 2>/dev/null || true
    [ -f libappindicator3.so.1 ] && ln -sf libappindicator3.so.1 libayatana-appindicator3.so.1 2>/dev/null || true

    echo '--- 强制安装 ---'
    cd $TMPDIR
    rpm -ivh --nodeps '$FILE'
  "
fi

echo ""
echo "=== 第4步: 验证 ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "
echo '--- 包状态 ---'
rpm -q '$PKG_NAME' 2>/dev/null && echo '包已安装' || echo '包未安装'

echo '--- 查找二进制 ---'
BIN_PATH=\$(rpm -ql '$PKG_NAME' 2>/dev/null | grep '^/usr/bin/' | head -1)
[ -z \"\$BIN_PATH\" ] && BIN_PATH=\$(find /usr/bin -name '*switch*' -o -name '*cc*' 2>/dev/null | head -1)
echo \"二进制: \$BIN_PATH\"

echo '--- 动态链接检查 ---'
[ -n \"\$BIN_PATH\" ] && ldd \"\$BIN_PATH\" 2>&1 | grep -E 'not found|version' && echo '有缺失依赖' || echo '动态链接正常'

echo '--- 运行测试 ---'
[ -n \"\$BIN_PATH\" ] && \"\$BIN_PATH\" --version 2>&1 || echo '无法运行'
"

echo ""
echo "=== 第5步: 可选清理 ==="
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "rm -rf $TMPDIR" && echo "临时目录已清理"

echo ""
echo "=== 部署完成 ==="
echo "包名: $PKG_NAME"
echo "如需回滚: rpm -e $PKG_NAME"
echo "如需清理符号链接:"
echo "  rm -f /usr/lib64/libwebkit2gtk-4.1.so.0"
echo "  rm -f /usr/lib64/libjavascriptcoregtk-4.1.so.0"
echo "  rm -f /usr/lib64/libayatana-appindicator3.so.1"
