#!/bin/sh
# 检测远程服务器操作系统版本和包管理器
# 输出: OS_TYPE PKG_MANAGER OS_VERSION

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"

if [ -z "$ALI" ]; then
  echo "ERROR: ALI未设置"
  exit 1
fi

sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" '
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "OS_NAME=$NAME"
    echo "OS_ID=$ID"
    echo "OS_VERSION=$VERSION_ID"
    echo "OS_LIKE=$ID_LIKE"
  fi
  
  if command -v dnf >/dev/null 2>&1; then
    echo "PKG_MANAGER=dnf"
  elif command -v yum >/dev/null 2>&1; then
    echo "PKG_MANAGER=yum"
  elif command -v apt-get >/dev/null 2>&1; then
    echo "PKG_MANAGER=apt"
  elif command -v apk >/dev/null 2>&1; then
    echo "PKG_MANAGER=apk"
  elif command -v zypper >/dev/null 2>&1; then
    echo "PKG_MANAGER=zypper"
  else
    echo "PKG_MANAGER=unknown"
  fi
  
  echo "GLIBC=$(ldd --version | head -1 | awk "{print \$NF}")"
  echo "ARCH=$(uname -m)"
  
  if command -v docker >/dev/null 2>&1; then
    echo "DOCKER=$(docker --version | awk "{print \$3}" | tr -d ",")"
    echo "DOCKER_COMPOSE=$(docker compose version 2>/dev/null | awk "{print \$4}" || echo "not_installed")"
  else
    echo "DOCKER=not_installed"
    echo "DOCKER_COMPOSE=not_installed"
  fi
'
