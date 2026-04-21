# RESTORE

## 一键恢复（本机已有仓库）

```sh
sh /var/minis/shared/minis-skills/published-systems/memory-topics-governance/restore.sh
```

## 恢复内容
- `memory_topics/*.md` → `/var/minis/shared/memory_topics/`
- `open-minis-memory-store/SKILL.md` → `/var/minis/skills/open-minis-memory-store/`
- `GLOBAL.md` → `/var/minis/memory/GLOBAL.md`

## 不恢复
- `/var/minis/memory/YYYY-MM-DD.md` daily memory

## 恢复前建议
- 先自行备份当前运行态
- 若只是增量更新，先 `git pull` 再执行 `restore.sh`
