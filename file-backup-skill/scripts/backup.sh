#!/bin/sh
# 文件备份技能实现脚本 (兼容BusyBox ash)

# 配置
BACKUP_DIR="${HOME}/.backup_logs"
LOG_FILE="${BACKUP_DIR}/backup.log"
ERROR_LOG="${BACKUP_DIR}/error.log"

# 创建日志目录
mkdir -p "$BACKUP_DIR"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$ERROR_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1"
}

# 基础文件备份函数
backup_file() {
    local file="$1"
    local strategy="$2"
    
    # 检查文件是否存在
    if [ ! -f "$file" ]; then
        error_log "文件不存在: $file"
        return 4
    fi
    
    # 检查权限
    if [ ! -r "$file" ]; then
        error_log "无法读取文件: $file"
        return 2
    fi
    
    case "$strategy" in
        "timestamp")
            local timestamp=$(date +%Y%m%d_%H%M%S)
            local backup_file="${file}_${timestamp}.bak"
            ;;
        "version")
            local version=1
            while [ -f "${file}_v${version}.bak" ]; do
                version=$((version + 1))
            done
            local backup_file="${file}_v${version}.bak"
            ;;
        *)
            local backup_file="${file}.bak"
            ;;
    esac
    
    # 执行备份
    if cp "$file" "$backup_file"; then
        log "备份成功: $backup_file"
        echo "$backup_file"
        return 0
    else
        error_log "备份失败: $file"
        return 1
    fi
}

# 批量备份函数
backup_batch() {
    local success=0
    local failed=0
    local count=0
    
    # 计算参数数量
    for arg in "$@"; do
        count=$((count + 1))
    done
    
    log "开始批量备份，共 $count 个文件"
    
    # 遍历所有文件参数
    for file in "$@"; do
        if backup_file "$file" "timestamp"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
    done
    
    log "批量备份完成: 成功 $success 个，失败 $failed 个"
    echo "$success $failed"
}

# 显示使用帮助
show_help() {
    cat << EOF
文件备份技能使用方法:

基础备份:
  backup_file <文件路径> [策略]
    策略: basic|timestamp|version

批量备份:
  backup_batch <文件1> <文件2> ...

查看历史:
  backup_history <文件路径>

配置:
  backup_config set <key> <value>
  backup_config show

EOF
}

# 主函数
main() {
    case "$1" in
        "backup_file")
            backup_file "$2" "$3"
            ;;
        "backup_batch")
            shift
            backup_batch "$@"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 如果直接运行脚本
if [ "$1" = "backup_file" ] || [ "$1" = "backup_batch" ] || [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    main "$@"
fi