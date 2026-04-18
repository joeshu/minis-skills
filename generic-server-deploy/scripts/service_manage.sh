#!/bin/sh
# 服务管理脚本
# 用法: ACTION=status SERVICE=nginx ./service_manage.sh

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"
ACTION="${ACTION:-status}"
SERVICE="${SERVICE:-}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

if [ -z "$SERVICE" ]; then
  echo "ERROR: 需要设置 SERVICE 环境变量"
  echo "示例: ACTION=status SERVICE=nginx ./service_manage.sh"
  exit 1
fi

case "$ACTION" in
  status)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "systemctl status $SERVICE"
    ;;
  start)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "systemctl start $SERVICE"
    ;;
  stop)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "systemctl stop $SERVICE"
    ;;
  restart)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "systemctl restart $SERVICE"
    ;;
  enable)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "systemctl enable $SERVICE"
    ;;
  list)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "systemctl list-units --type=service --state=running"
    ;;
  *)
    echo "未知操作: $ACTION"
    echo "可选: status/start/stop/restart/enable/list"
    exit 1
    ;;
esac
