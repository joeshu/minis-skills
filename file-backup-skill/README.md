# 文件备份技能

用途：在你需要保留回滚点时创建备份；普通修改默认不强制备份。按达尔文评分标准，这个技能优先强调：触发条件、线性工作流、边界条件、检查点和测试样例。

## 什么时候用
- 你明确要求先备份
- 删除文件/目录前
- 批量替换前
- 重构/迁移前
- 关键配置修改前
- 想恢复最近一次备份
- 想清理旧备份

## 默认策略
- 普通低风险修改：不强制备份
- 关键节点：建议用 `smart`
- 智能备份默认：600 秒窗口，保留最近 5 份

## 常用命令
```sh
/var/minis/skills/file-backup-skill/scripts/backup.sh smart /path/to/file
/var/minis/skills/file-backup-skill/scripts/backup.sh file /path/to/file
/var/minis/skills/file-backup-skill/scripts/backup.sh dir /path/to/dir
/var/minis/skills/file-backup-skill/scripts/backup.sh latest /path/to/file
/var/minis/skills/file-backup-skill/scripts/backup.sh restore-latest /path/to/file
/var/minis/skills/file-backup-skill/scripts/backup.sh clean /path/to/file 5
```

## 检查点
以下情况建议先确认：
- 删除目录前
- 批量替换多个关键文件前
- 清理旧备份前
- restore 会覆盖现有文件时

## 恢复
```sh
# 恢复指定备份
/var/minis/skills/file-backup-skill/scripts/backup.sh restore /path/to/a.txt.20260415_061500.bak

# 恢复最近一次备份
/var/minis/skills/file-backup-skill/scripts/backup.sh restore-latest /path/to/a.txt
```
