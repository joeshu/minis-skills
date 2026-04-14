# 文件备份技能 (File Backup Skill)

## 技能描述
这是一个专门用于文件和代码修改时自动创建备份的技能，确保所有修改操作都可以安全回退。支持多种备份策略和自动化操作。

## 触发词
- 文件备份、备份文件、代码备份
- create backup、backup file、code backup
- 备份策略、备份机制、安全备份
- backup strategy、backup mechanism、safe backup

## 适用场景
- 修改重要文件前自动备份
- 代码版本控制前的本地备份
- 配置文件修改的安全保障
- 批量文件备份管理

## Phase 1: 基础备份操作

### Step 1: 单文件备份
**功能**: 备份单个文件，支持多种命名策略
**输入**: 文件路径，可选参数
**输出**: 备份文件路径，备份状态

```bash
# 基础备份 - 创建 filename.bak
backup_file /path/to/file.txt

# 时间戳备份 - 创建 filename_20240414_160000.bak
backup_file /path/to/file.txt --timestamp

# 版本号备份 - 自动递增版本号
backup_file /path/to/file.txt --version

# 压缩备份 - 创建 filename.tar.gz
backup_file /path/to/file.txt --compress
```

### Step 2: 目录备份
**功能**: 备整个目录，支持增量备份
**输入**: 目录路径，可选参数
**输出**: 备份目录路径，备份统计信息

```bash
# 完整目录备份
backup_dir /path/to/directory

# 增量备份（只备份修改过的文件）
backup_dir /path/to/directory --incremental

# 排除特定文件备份
backup_dir /path/to/directory --exclude "*.tmp" --exclude "*.log"
```

### Step 3: 批量备份
**功能**: 批量备份多个文件
**输入**: 文件路径列表或配置文件
**输出**: 批量备份结果报告

```bash
# 批量备份多个文件
backup_batch /path/to/file1.txt /path/to/file2.txt /path/to/file3.txt

# 使用配置文件批量备份
backup_batch --config backup_config.json
```

## Phase 2: Git 集成备份

### Step 4: Git 备份确认
**功能**: 在 Git 环境中创建备份并提交
**输入**: 文件/目录路径，提交信息
**输出**: Git 提交哈希，备份状态

```bash
# 备份并提交单个文件
backup_git /path/to/file.txt "修复配置文件错误"

# 备份并提交整个目录
backup_git /path/to/directory "更新项目配置"

# 创建备份分支
backup_git /path/to/file.txt "紧急修复" --branch hotfix
```

### Step 5: 备份策略选择
**功能**: 根据场景选择合适的备份策略
**输入**: 备份需求描述
**输出**: 推荐的备份策略和执行命令

```bash
# 自动推荐备份策略
backup_strategy "重要配置文件修改"

# 查看可用策略
backup_strategy --list

# 自定义策略
backup_strategy --custom "时间戳+压缩+Git提交"
```

## Phase 3: 高级备份管理

### Step 6: 备份配置管理
**功能**: 管理备份配置文件和全局设置
**输入**: 配置参数
**输出**: 配置更新结果

```bash
# 设置默认备份策略
backup_config set default_strategy timestamp

# 设置最大备份数量
backup_config set max_backups 10

# 启用自动清理
backup_config set auto_cleanup true

# 查看当前配置
backup_config show
```

### Step 7: 备份历史和恢复
**功能**: 查看备份历史和恢复文件
**输入**: 文件路径，时间范围等
**输出**: 备份历史列表，恢复选项

```bash
# 查看文件备份历史
backup_history /path/to/file.txt

# 恢复到指定备份
backup_restore /path/to/file.txt --backup /path/to/file_20240414_160000.bak

# 列出所有可恢复的备份
backup_restore --list /path/to/file.txt
```

## 核心功能

### 1. 自动备份
- 修改前自动创建 `.bak` 备份文件
- 支持时间戳命名：`filename_20240414_160000.bak`
- 支持版本号命名：`filename_v1.bak`, `filename_v2.bak`

### 2. Git 备份
- 自动提交到 git 仓库
- 生成清晰的提交信息
- 支持分支备份

### 3. 多级备份策略
- **基础备份**：单文件备份
- **目录备份**：整个目录的增量备份
- **项目备份**：完整项目快照

## Phase 4: 边界条件和错误处理

### Step 8: 错误处理和恢复
**功能**: 处理各种异常情况和恢复操作
**输入**: 错误场景，恢复选项
**输出**: 处理结果，建议操作

```bash
# 处理备份失败
backup_handle_error /path/to/file.txt "permission_denied"

# 自动重试备份
backup_retry /path/to/file.txt --max-attempts 3

# 回滚到上一个成功备份
backup_rollback /path/to/file.txt
```

### Step 9: 用户确认检查点
**功能**: 关键操作前的用户确认
**输入**: 确认信息，用户选择
**输出**: 确认结果，继续执行或取消

```bash
# 备份前确认
backup_confirm "即将备份 /path/to/config.conf，是否继续？"

# 批量备份确认
backup_confirm_batch "发现 5 个文件需要备份，是否继续？"

# 危险操作确认
backup_confirm_danger "即将删除 30 天前的备份文件，是否继续？"
```

## 使用方法

### 基础文件备份
```bash
# 单文件备份
backup_file /path/to/file.txt

# 带时间戳的备份
backup_file /path/to/file.txt --timestamp

# 带版本号的备份
backup_file /path/to/file.txt --version
```

### 目录备份
```bash
# 备份整个目录
backup_dir /path/to/directory

# 增量备份
backup_dir /path/to/directory --incremental
```

### Git 备份
```bash
# Git 备份单个文件
backup_git /path/to/file.txt "修改描述"

# Git 备份目录
backup_git /path/to/directory "目录修改描述"
```

## 高级功能

### 备份策略配置
```json
{
  "backup_strategy": "timestamp",
  "max_backups": 10,
  "compression": true,
  "auto_cleanup": true
}
```

### 批量备份
```bash
# 批量备份多个文件
backup_batch /path/to/file1.txt /path/to/file2.txt /path/to/file3.txt

# 备配配置文件批量备份
backup_batch --config backup_config.json
```

## 最佳实践

### 1. 修改前检查
- 自动检查文件是否已存在备份
- 提示用户确认备份策略
- 检查磁盘空间是否充足

### 2. 错误处理
- 备份失败时自动回滚
- 提供详细的错误日志
- 支持自动重试机制

### 3. 清理机制
- 自动清理过期备份
- 保留最近 N 个备份版本
- 可配置备份保留策略

### 4. 安全性
- 备份文件设置适当权限
- 敏感文件加密备份
- 支持备份文件完整性校验

### 5. 性能优化
- 大文件分块备份
- 并行处理多个文件
- 增量备份减少时间消耗

## 配置文件示例

```bash
# ~/.backup_config
DEFAULT_STRATEGY=timestamp
MAX_BACKUPS=5
COMPRESSION=true
AUTO_CLEANUP=true
LOG_LEVEL=info
```

## 边界条件处理

### 文件不存在情况
```bash
# 自动处理文件不存在
backup_file /path/to/nonexistent.txt --create-if-missing

# 跳过不存在的文件
backup_file /path/to/nonexistent.txt --skip-missing
```

### 权限不足情况
```bash
# 自动提升权限
backup_file /path/to/protected.txt --sudo

# 跳过无权限文件
backup_file /path/to/protected.txt --skip-permission-denied
```

### 磁盘空间不足
```bash
# 自动清理空间后重试
backup_file /path/to/largefile.txt --auto-cleanup

# 压缩备份节省空间
backup_file /path/to/largefile.txt --compress --force
```

### 网络文件系统
```bash
# 增加超时时间
backup_file /path/to/nfs/file.txt --timeout 300

# 使用本地缓存
backup_file /path/to/nfs/file.txt --local-cache
```

## 故障排除

### 常见问题
- **权限不足**：检查文件权限，使用 `--sudo` 参数或 `chmod` 修改权限
- **磁盘空间不足**：清理旧备份或使用 `--compress` 参数
- **Git 未初始化**：先运行 `git init` 初始化仓库
- **文件被占用**：关闭文件后重试或使用 `--force` 参数

### 错误代码
- `BACKUP_SUCCESS` (0): 备份成功
- `BACKUP_FAILED` (1): 备份失败
- `PERMISSION_DENIED` (2): 权限不足
- `NO_SPACE_LEFT` (3): 磁盘空间不足
- `FILE_NOT_FOUND` (4): 文件不存在
- `NETWORK_ERROR` (5): 网络错误

### 日志查看
```bash
# 查看备份日志
tail -f ~/.backup_logs/backup.log

# 查看备份历史
backup_history

# 查看错误日志
tail -f ~/.backup_logs/error.log

# 查看详细统计
backup_stats
```

## 技能集成

此技能可以与其他技能集成：

### 与代码编辑技能集成
```bash
# 修改文件前自动备份
backup_file /path/to/code.py
edit_file /path/to/code.py "修复bug"
```

### 与部署技能集成
```bash
# 部署前备份当前版本
backup_dir /path/to/app "部署前备份"
deploy_app /path/to/app
```

### 与版本控制技能集成
```bash
# 创建Git备份分支
backup_git /path/to/config "配置更新" --branch backup-$(date +%Y%m%d)
```

### 与文件管理技能集成
```bash
# 批量备份特定类型文件
backup_batch /path/to/project/*.md /path/to/project/*.json
```

## 实现脚本

### 基础备份脚本 (backup.sh)
```bash
#!/bin/bash
# 基础文件备份功能

backup_file() {
    local file="$1"
    local strategy="${2:-basic}"
    
    if [[ ! -f "$file" ]]; then
        echo "错误: 文件不存在: $file"
        return 4
    fi
    
    case "$strategy" in
        "timestamp")
            local timestamp=$(date +%Y%m%d_%H%M%S)
            local backup_file="${file}_${timestamp}.bak"
            ;;
        "version")
            local version=1
            while [[ -f "${file}_v${version}.bak" ]]; do
                ((version++))
            done
            local backup_file="${file}_v${version}.bak"
            ;;
        *)
            local backup_file="${file}.bak"
            ;;
    esac
    
    cp "$file" "$backup_file"
    echo "备份成功: $backup_file"
}

# 使用示例
backup_file "/path/to/config.conf" "timestamp"
```

### Git备份脚本 (backup_git.sh)
```bash
#!/bin/bash
# Git集成备份功能

backup_git() {
    local path="$1"
    local message="$2"
    local branch="${3:-main}"
    
    # 检查是否在git仓库中
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "错误: 不在git仓库中"
        return 1
    fi
    
    # 创建备份分支
    local backup_branch="backup-$(date +%Y%m%d_%H%M%S)"
    git checkout -b "$backup_branch"
    
    # 提交更改
    git add "$path"
    git commit -m "$message"
    
    # 切换回原分支
    git checkout "$branch"
    
    echo "Git备份完成: $backup_branch"
}
```