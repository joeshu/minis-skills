#!/bin/sh
# 统一解析服务器目标变量
# 输出:
#   TARGET_HOST=...
#   TARGET_USER=...

TARGET_HOST="${DEPLOY_DOMAIN:-${DEPLOY_HOST:-${ALIYUN_DOMAIN:-${ALIYUN_HOST:-}}}}"
TARGET_USER="${DEPLOY_USER:-${ALIYUN_USER:-root}}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置" >&2
  exit 1
fi

if [ -z "$TARGET_HOST" ]; then
  echo "ERROR: 目标主机未设置，请提供 DEPLOY_DOMAIN / DEPLOY_HOST / ALIYUN_DOMAIN / ALIYUN_HOST" >&2
  exit 1
fi

export TARGET_HOST
export TARGET_USER
