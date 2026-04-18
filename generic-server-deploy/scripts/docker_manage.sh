#!/bin/sh
# Docker 管理脚本
# 用法: ACTION=ps ./docker_manage.sh

ALI="${ALI:-}"
HOST="${DEPLOY_HOST:-118.190.200.12}"
USER="${DEPLOY_USER:-root}"
ACTION="${ACTION:-ps}"
CONTAINER="${CONTAINER:-}"
IMAGE="${IMAGE:-}"

if [ -z "$ALI" ]; then
  echo "ERROR: 环境变量 ALI 未设置"
  exit 1
fi

case "$ACTION" in
  ps)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}'"
    ;;
  images)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}'"
    ;;
  logs)
    if [ -z "$CONTAINER" ]; then
      echo "ERROR: 需要设置 CONTAINER"
      exit 1
    fi
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker logs --tail 100 $CONTAINER"
    ;;
  exec)
    if [ -z "$CONTAINER" ]; then
      echo "ERROR: 需要设置 CONTAINER"
      exit 1
    fi
    CMD="${CMD:-sh}"
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker exec -it $CONTAINER $CMD"
    ;;
  start)
    [ -z "$CONTAINER" ] && { echo "ERROR: 需要设置 CONTAINER"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker start $CONTAINER && echo '已启动' || echo '启动失败'"
    ;;
  stop)
    [ -z "$CONTAINER" ] && { echo "ERROR: 需要设置 CONTAINER"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker stop $CONTAINER && echo '已停止' || echo '停止失败'"
    ;;
  restart)
    [ -z "$CONTAINER" ] && { echo "ERROR: 需要设置 CONTAINER"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker restart $CONTAINER && echo '已重启' || echo '重启失败'"
    ;;
  rm)
    [ -z "$CONTAINER" ] && { echo "ERROR: 需要设置 CONTAINER"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker rm -f $CONTAINER && echo '已删除' || echo '删除失败'"
    ;;
  pull)
    [ -z "$IMAGE" ] && { echo "ERROR: 需要设置 IMAGE"; exit 1; }
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker pull $IMAGE"
    ;;
  run)
    [ -z "$IMAGE" ] && { echo "ERROR: 需要设置 IMAGE"; exit 1; }
    NAME="${NAME:-}"
    PORTS="${PORTS:-}"
    VOLUMES="${VOLUMES:-}"
    ENV="${ENV:-}"
    
    RUN_CMD="docker run -d"
    [ -n "$NAME" ] && RUN_CMD="$RUN_CMD --name $NAME"
    [ -n "$PORTS" ] && RUN_CMD="$RUN_CMD -p $PORTS"
    [ -n "$VOLUMES" ] && RUN_CMD="$RUN_CMD -v $VOLUMES"
    [ -n "$ENV" ] && RUN_CMD="$RUN_CMD -e $ENV"
    RUN_CMD="$RUN_CMD $IMAGE"
    
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "$RUN_CMD && echo '容器已启动' || echo '启动失败'"
    ;;
  compose)
    COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.yml}"
    COMPOSE_ACTION="${COMPOSE_ACTION:-ps}"
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "cd /opt && docker compose -f $COMPOSE_FILE $COMPOSE_ACTION"
    ;;
  prune)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker system prune -f && echo '清理完成' || echo '清理失败'"
    ;;
  info)
    sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "${USER}@${HOST}" "docker info 2>/dev/null | head -30 || echo 'Docker未安装或未启动'"
    ;;
  *)
    echo "未知操作: $ACTION"
    echo "可选: ps/images/logs/exec/start/stop/restart/rm/pull/run/compose/prune/info"
    echo ""
    echo "常用示例:"
    echo "  ACTION=ps                      # 查看所有容器"
    echo "  ACTION=logs CONTAINER=nginx    # 查看容器日志"
    echo "  ACTION=stop CONTAINER=nginx    # 停止容器"
    echo "  ACTION=pull IMAGE=nginx:latest # 拉取镜像"
    echo "  ACTION=run IMAGE=nginx PORTS=80:80 NAME=web  # 启动容器"
    echo "  ACTION=compose COMPOSE_ACTION=up  # 启动Compose"
    exit 1
    ;;
esac
