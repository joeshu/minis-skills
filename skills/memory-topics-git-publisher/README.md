# memory-topics-git-publisher

把当前回答风格 / 检索治理体系安全镜像到 `joeshu/minis-skills` 仓库中的单独目录，并支持恢复到本机。

## 默认目标
- 仓库：`https://github.com/joeshu/minis-skills.git`
- 本地优先路径：`/var/minis/mounts/minis-skills/`
- 发布目录：`published-systems/memory-topics-governance/`

## 模式
- `check`：只检查仓库与同步范围
- `sync`：刷新发布目录，不 push
- `push`：检查 + 刷新 + 提交 + 推送
- `restore-check`：检查恢复影响，不真正恢复
- `restore-sync`：先备份，再恢复到本机

## 默认纳入
- `/var/minis/shared/memory_topics/` 下当前体系相关文件
- `/var/minis/memory/GLOBAL.md`
- 发布资产：README / REPORT / RESTORE / execution-samples / sync script

## 默认排除
- daily memory
- 无关旧专题
- `.bak` / 临时文件 / 敏感信息

## 恢复原则
- 先备份本机现状
- 先恢复 `shared/memory_topics/`
- 再恢复 `GLOBAL.md`
- 不恢复真实 daily memory
