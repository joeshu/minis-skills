# 一键恢复命令模板（记忆系统）

生成时间：2026-04-15

> 用途：重装 Open Minis 后，快速恢复当前这套记忆系统框架。
> 说明：以下模板恢复的是**系统框架与镜像资产**，不是你的全部真实个人记忆数据。

---

## 一、clone 仓库

默认仓库地址：
```sh
https://github.com/joeshu/minis-skills.git
```

```sh
git clone https://github.com/joeshu/minis-skills.git /var/minis/workspace/minis-skills-import
```

---

## 二、恢复技能目录

```sh
set -e
src=/var/minis/workspace/minis-skills-import
skills=/var/minis/skills

for d in \
  memory-topic-router \
  memory-write-gatekeeper \
  memory-layer-governor \
  memory-dedup-auditor \
  open-minis-memory-store \
  memory-system-maintainer \
  open-minis-handoff-orchestrator \
  session-context-compactor
 do
  rm -rf "$skills/$d"
  cp -R "$src/$d" "$skills/"
 done
```

---

## 三、恢复 shared 镜像资产

### 1. 系统文档
```sh
set -e
src=/var/minis/workspace/minis-skills-import/docs/memory-system
shared=/var/minis/shared

for f in "$src"/*; do
  [ -f "$f" ] && cp "$f" "$shared/"
done
```

### 2. 专题样本库
```sh
set -e
src=/var/minis/workspace/minis-skills-import/docs/memory-topics
shared_topics=/var/minis/shared/memory_topics
mkdir -p "$shared_topics"

for f in "$src"/*.md; do
  [ -f "$f" ] && cp "$f" "$shared_topics/"
done
```

---

## 四、恢复系统入口文档（可选）

```sh
set -e
src=/var/minis/workspace/minis-skills-import
cp "$src/MEMORY_SYSTEM_README.md" /var/minis/skills/
cp "$src/README_MEMORY_SYSTEM.md" /var/minis/skills/
cp "$src/MEMORY_SYSTEM_RESTORE_GUIDE.md" /var/minis/skills/
cp "$src/SHARED_SYNC_POLICY.md" /var/minis/skills/
cp "$src/memory-system-execution-index.md" /var/minis/skills/
```

---

## 五、恢复后校验

```sh
echo '--- skills ---'
find /var/minis/skills -maxdepth 1 -type d | sort | grep 'memory\|handoff\|context-compactor'

echo '--- shared docs ---'
find /var/minis/shared -maxdepth 1 -type f | sort | grep 'memory-system\|memory-topics-index'

echo '--- shared topics ---'
find /var/minis/shared/memory_topics -maxdepth 1 -type f | sort
```

---

## 六、恢复真实个人记忆（如果你有单独备份）

> 注意：这部分默认**不通过 git 恢复**。
> 如果你有自己的 `/var/minis/memory/` 备份，再手动恢复：

```sh
# 示例：把你备份的 memory 文件恢复回来
# cp /path/to/backup/GLOBAL.md /var/minis/memory/
# cp /path/to/backup/*.md /var/minis/memory/
```

---

## 七、一句话最短恢复流程

```sh
# 1. clone
# 2. 恢复 8 个核心技能目录
# 3. 恢复 docs/memory-system -> /var/minis/shared/
# 4. 恢复 docs/memory-topics -> /var/minis/shared/memory_topics/
# 5. 校验目录和文件
```
