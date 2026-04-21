#!/bin/sh
# 服务管理脚本
# 用法: ACTION=status SERVICE=nginx ./service_manage.sh

ACTION="${ACTION:-status}"
SERVICE="${SERVICE:-}"
. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

if [ -z "$SERVICE" ] && [ "$ACTION" != "list" ]; then
  echo "ERROR: 需要设置 SERVICE 环境变量"
  exit 1
fi

case "$ACTION" in
  status)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "systemctl status $SERVICE"
    ;;
  start)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "systemctl start $SERVICE"
    ;;
  stop)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "systemctl stop $SERVICE"
    ;;
  restart)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "systemctl restart $SERVICE"
    ;;
  enable)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "systemctl enable $SERVICE"
    ;;
  list)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "systemctl list-units --type=service --state=running"
    ;;
  *)
    echo "未知操作: $ACTION"
    exit 1
    ;;
esac
