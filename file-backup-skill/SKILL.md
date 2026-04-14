---
name: file-backup-skill
description: Create file or directory backups when the user explicitly asks for a rollback point, or when a high-risk operation such as delete, batch replace, refactor, migration, or key config change is about to happen. Use this skill for smart backup, latest-backup lookup, restore, restore-latest, and cleanup.
---

# file-backup-skill

一个用于**按需备份**的执行型技能。普通低风险修改默认不强制备份；只有在用户明确要求，或遇到关键节点操作时，才建议或执行备份。

## 触发词
- 先备份一下
- 留个回滚点
- 删除前备份
- 批量改之前先备份
- 恢复最近一次备份
- 清理旧备份
- smart backup / restore latest / clean backups

## 输入
- 目标文件路径或目录路径
- 操作类型：普通修改 / 删除 / 批量替换 / 重构 / 迁移 / 恢复 / 清理
- 可选参数：窗口秒数、保留份数、恢复目标路径

## 输出
执行后至少返回：
1. 是否创建了新备份，还是因限频/同内容被跳过
2. 备份路径或恢复目标路径
3. 若失败，失败原因
4. 若执行清理，返回保留份数与删除数量

## 关键节点定义
以下场景视为关键节点，应该**主动建议**备份：
1. 删除文件前
2. 删除目录前
3. 批量替换前
4. 重构前
5. 迁移/重命名前
6. 修改关键配置前
7. 发布/提交前

## 工作流

### Phase 1: 判断是否需要备份
1. 判断用户是否明确要求备份。
2. 若未明确要求，再判断当前操作是否属于关键节点。
3. 若都不是，则可直接修改，不强制备份。
4. 若是关键节点或用户要求备份，则进入 Phase 2。

### Phase 2: 选择备份方式
1. **单文件**：优先使用 `smart`。
2. **多个关键文件**：逐个使用 `smart`，必要时汇总结果。
3. **目录级快照**：使用 `dir`。
4. **只想强制生成一份备份**：使用 `file`。

推荐命令：
```sh
/var/minis/skills/file-backup-skill/scripts/backup.sh smart <文件> [窗口秒数] [保留份数]
/var/minis/skills/file-backup-skill/scripts/backup.sh file <文件>
/var/minis/skills/file-backup-skill/scripts/backup.sh dir <目录>
```

### Phase 3: 执行修改或删除
1. 记录备份结果。
2. 再执行 `file_edit`、删除或其他修改操作。
3. 若是批量任务，汇总 success/failed 后再继续。

### Phase 4: 恢复或清理
1. 已知具体备份路径：使用 `restore`。
2. 只想恢复最近一次：使用 `restore-latest`。
3. 备份过多：使用 `clean`，只保留最近 N 份。
4. 需要查看最近备份：使用 `latest` 或 `list`。

## 命令选择矩阵
| 场景 | 推荐命令 | 原因 |
|---|---|---|
| 普通低风险修改 | 无需备份，直接修改 | 避免过度备份 |
| 单文件关键节点 | `smart <文件>` | 限频、去重、自动清理 |
| 明确要求立即生成备份 | `file <文件>` | 强制创建一份新备份 |
| 多个关键文件 | 对每个文件执行 `smart` | 逐个建立可恢复点 |
| 整个目录重构/删除前 | `dir <目录>` | 适合做目录级快照 |
| 想找最近备份 | `latest <原路径>` | 快速定位最近回滚点 |
| 想恢复最近备份 | `restore-latest <原路径>` | 最短恢复路径 |
| 旧备份过多 | `clean <原路径> [保留份数]` | 控制备份数量 |

## Fallback 路径
- `smart` 因窗口限频被跳过，但用户明确说“必须新建一份备份”时：改用 `file`
- `restore-latest` 找不到备份时：先用 `list` 检查是否路径不匹配
- 无法自动推断恢复目标时：要求用户提供 `restore <备份路径> <目标路径>`
- 批量任务中部分文件备份失败时：先汇报失败清单，再决定是否继续剩余修改
- 目录删除前若用户不想做完整快照：明确告知无回滚点风险后再继续

## 检查点设计
以下情况应先向用户确认，再执行：
1. **删除目录前**：建议先做目录快照，确认后再删。
2. **批量替换多个关键文件前**：确认是否对全部目标执行备份。
3. **执行 clean 删除旧备份前**：确认保留份数是否正确。
4. **restore 将覆盖现有文件时**：提醒用户会覆盖当前内容。

若用户已明确表达“直接做”“继续”“就按这个来”，可直接执行，无需重复确认。

## 真实可用命令
```sh
/var/minis/skills/file-backup-skill/scripts/backup.sh file <文件>
/var/minis/skills/file-backup-skill/scripts/backup.sh smart <文件> [窗口秒数] [保留份数]
/var/minis/skills/file-backup-skill/scripts/backup.sh batch <文件1> <文件2> ...
/var/minis/skills/file-backup-skill/scripts/backup.sh dir <目录>
/var/minis/skills/file-backup-skill/scripts/backup.sh list <原路径>
/var/minis/skills/file-backup-skill/scripts/backup.sh latest <原路径>
/var/minis/skills/file-backup-skill/scripts/backup.sh restore <备份路径> [恢复目标路径]
/var/minis/skills/file-backup-skill/scripts/backup.sh restore-latest <原路径>
/var/minis/skills/file-backup-skill/scripts/backup.sh clean <原路径> [保留份数]
```

## 默认策略
- `smart` 默认窗口：600 秒
- `smart` 默认保留：5 份
- 普通修改：不强制备份
- 关键节点：优先建议 `smart` 或 `dir`

## 边界条件
- 文件不存在：停止并报错
- 不是普通文件/目录：停止并报错
- 最近备份不存在：明确告知无法 `restore-latest`
- 无法自动推断恢复目标：要求用户显式提供目标路径
- 清理时保留份数大于现有数量：不报错，返回 removed=0
- 目录快照恢复会覆盖目标目录：先提醒用户

## 与 Minis 工具配合
- 新建文件：`file_write`
- 修改已有文件：按需决定是否先运行 `backup.sh`，再 `file_edit`
- 删除/批量替换/重构：优先评估是否属于关键节点
- 复杂项目：文件备份可与 git commit 同时使用，但 git 不能替代文件备份

## 禁止事项
- 把“所有修改都必须备份”写成硬规则
- 在文档里写出脚本不支持的命令
- 默认全盘搜索或全盘备份
- 在需要确认的高风险场景里跳过提醒

## 测试要求
使用 `test-prompts.json` 做 2-3 个典型场景验证，至少覆盖：
1. 普通小改，不强制备份
2. 关键节点智能备份
3. 最近备份恢复或旧备份清理

如果无法做完整对子测试，至少做 dry_run，检查：
- 是否会错误地对所有修改都强制备份
- 是否能在关键节点给出明确建议
- 是否能正确选择 `smart` / `dir` / `restore-latest` / `clean`
