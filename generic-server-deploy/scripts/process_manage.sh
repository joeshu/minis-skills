#!/bin/sh
# 进程管理脚本 v2
# 用法: ACTION=list [KEYWORD=nginx] ./process_manage.sh

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"
ACTION="${ACTION:-list}"
KEYWORD="${KEYWORD:-}"
PID="${PID:-}"
SORT="${SORT:-cpu}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

case "$ACTION" in
  list)
    if [ -n "$KEYWORD" ]; then
      sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "ps aux | grep -E \"PID|$KEYWORD\" | grep -v grep"
    else
      sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "ps aux --sort=-%${SORT} | head -20"
    fi
    ;;
  tree)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "ps auxf | head -40"
    ;;
  top)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "top -bn1 -o %${SORT} | head -25"
    ;;
  detail)
    if [ -z "$PID" ]; then
      echo "ERROR: 需要设置 PID"
      exit 1
    fi
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "
      echo \"=== 进程信息 ===\"; ps -p $PID -o pid,ppid,cmd,%cpu,%mem,etime,nlwp
      echo \"=== 打开文件 ===\"; lsof -p $PID 2>/dev/null | head -20 || echo 'lsof不可用'
      echo \"=== 工作目录 ===\"; readlink /proc/$PID/cwd 2>/dev/null || echo '无法读取'
      echo \"=== 环境变量 ===\"; cat /proc/$PID/environ 2>/dev/null | tr '\0' '\n' | head -10 || echo '无法读取'
    "
    ;;
  kill)
    if [ -z "$PID" ]; then
      echo "ERROR: 需要设置 PID"
      exit 1
    fi
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "kill -9 $PID && echo '进程 $PID 已终止' || echo '终止失败'"
    ;;
  killsoft)
    if [ -z "$PID" ]; then
      echo "ERROR: 需要设置 PID"
      exit 1
    fi
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "kill -15 $PID && echo '已发送SIGTERM到 $PID' || echo '失败'"
    ;;
  pkill)
    if [ -z "$KEYWORD" ]; then
      echo "ERROR: 需要设置 KEYWORD"
      exit 1
    fi
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "pkill -f $KEYWORD && echo '进程已终止' || echo '终止失败或未找到'"
    ;;
  user)
    TARGET_USER="${TARGET_USER:-$USER}"
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "ps aux -u $TARGET_USER | head -20"
    ;;
  *)
    echo "未知操作: $ACTION"
    echo "可选: list/tree/top/detail/kill/killsoft/pkill/user"
    echo ""
    echo "常用示例:"
    echo "  ACTION=list                    # 查看所有进程（按CPU排序）"
    echo "  ACTION=list SORT=mem           # 按内存排序"
    echo "  ACTION=list KEYWORD=nginx      # 过滤nginx进程"
    echo "  ACTION=tree                    # 进程树"
    echo "  ACTION=detail PID=1234         # 进程详情"
    echo "  ACTION=killsoft PID=1234       # 优雅终止"
    echo "  ACTION=kill PID=1234           # 强制终止"
    echo "  ACTION=user TARGET_USER=www    # 查看用户进程"
    exit 1
    ;;
esac
