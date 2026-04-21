#!/bin/sh
# 进程管理脚本 v2
# 用法: ACTION=list [KEYWORD=nginx] ./process_manage.sh

ACTION="${ACTION:-list}"
KEYWORD="${KEYWORD:-}"
PID="${PID:-}"
SORT="${SORT:-cpu}"
. /var/minis/skills/generic-server-deploy/scripts/resolve_target.sh

case "$ACTION" in
  list)
    if [ -n "$KEYWORD" ]; then
      sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "ps aux | grep -E \"PID|$KEYWORD\" | grep -v grep"
    else
      sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "ps aux --sort=-%${SORT} | head -20"
    fi
    ;;
  tree)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "ps auxf | head -40"
    ;;
  top)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "top -bn1 -o %${SORT} | head -25"
    ;;
  detail)
    [ -z "$PID" ] && { echo "ERROR: 需要设置 PID"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "
      echo \"=== 进程信息 ===\"; ps -p $PID -o pid,ppid,cmd,%cpu,%mem,etime,nlwp
      echo \"=== 打开文件 ===\"; lsof -p $PID 2>/dev/null | head -20 || echo 'lsof不可用'
      echo \"=== 工作目录 ===\"; readlink /proc/$PID/cwd 2>/dev/null || echo '无法读取'
      echo \"=== 环境变量 ===\"; cat /proc/$PID/environ 2>/dev/null | tr '\0' '\n' | head -10 || echo '无法读取'
    "
    ;;
  kill)
    [ -z "$PID" ] && { echo "ERROR: 需要设置 PID"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "kill -9 $PID && echo '进程 $PID 已终止' || echo '终止失败'"
    ;;
  killsoft)
    [ -z "$PID" ] && { echo "ERROR: 需要设置 PID"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "kill -15 $PID && echo '已发送SIGTERM到 $PID' || echo '失败'"
    ;;
  pkill)
    [ -z "$KEYWORD" ] && { echo "ERROR: 需要设置 KEYWORD"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "pkill -f $KEYWORD && echo '进程已终止' || echo '终止失败或未找到'"
    ;;
  user)
    QUERY_USER="${QUERY_USER:-$TARGET_USER}"
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${TARGET_HOST}" "ps aux -u $QUERY_USER | head -20"
    ;;
  *)
    echo "未知操作: $ACTION"
    exit 1
    ;;
esac
