# memory-system-git-sync

用途：安全地把记忆系统同步到 git，并支持重装后的快速恢复。

## 模式
- `check`：只检查范围和风险
- `sync`：刷新 shared → 仓库镜像
- `push`：检查 + 镜像 + 提交 + 推送
- `restore`：输出恢复顺序与命令模板

## 默认原则
- 只同步记忆系统相关内容
- 共享文档走镜像层，不直接把 shared 运行态当仓库
- 默认排除 `/var/minis/memory/` 真实个人记忆
- 默认排除敏感信息、`.bak`、无关改动

## 恢复原则
- 先恢复技能框架
- 再恢复 shared 镜像资产
- 最后单独恢复真实个人记忆数据
- 本地仓库还在时，优先给增量恢复方案（`git pull origin master`）
