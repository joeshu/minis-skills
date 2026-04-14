# 文件备份技能说明

## 概述
这是一个专门用于文件和代码修改时自动创建备份的技能，确保所有修改操作都可以安全回退。

## 快速开始

### 1. 基础备份
```bash
# 备份单个文件
backup_file /path/to/config.conf

# 带时间戳备份
backup_file /path/to/config.conf timestamp

# 带版本号备份
backup_file /path/to/config.conf version
```

### 2. 批量备份
```bash
# 批量备份多个文件
backup_batch /path/to/file1.txt /path/to/file2.txt /path/to/file3.txt
```

### 3. 查看历史
```bash
# 查看文件备份历史
backup_history /path/to/config.conf
```

## 配置

### 全局配置
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

## 错误处理

### 常见错误代码
- 0: 备份成功
- 1: 备份失败
- 2: 权限不足
- 3: 磁盘空间不足
- 4: 文件不存在

### 错误日志
```bash
# 查看错误日志
tail -f ~/.backup_logs/error.log

# 查看详细统计
backup_stats
```

## 集成使用

### 与其他技能配合
```bash
# 修改文件前备份
backup_file /path/to/code.py
# 然后进行代码修改
```

### 自动化脚本
```bash
#!/bin/bash
# 自动备份脚本
backup_file "$1" "timestamp"
# 执行修改操作
# ...
# 如果需要恢复
# backup_restore "$1" --backup "$1_$(date +%Y%m%d_%H%M%S).bak"
```

## 注意事项

1. 确保对目标文件有读取权限
2. 大文件备份前检查磁盘空间
3. 重要文件建议使用Git备份
4. 定期清理过期备份文件

## 支持
如有问题请查看日志文件或联系技能维护者。