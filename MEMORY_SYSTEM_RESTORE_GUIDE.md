# Open Minis 重装后快速恢复指南（记忆系统）

生成时间：2026-04-15

## 一、恢复目标
本指南用于在**重装 Open Minis** 后，尽可能快速恢复当前这套记忆系统框架。

恢复对象分为两类：

### A. 可直接从 git 恢复的系统资产
包括：
- 核心记忆技能目录
- 系统 README / 地图 / 手册 / 报告
- 真实专题样本镜像（`docs/memory-topics/`）
- 系统文档镜像（`docs/memory-system/`）

### B. 不应直接进 git 的运行态数据
默认不随仓库恢复：
- `/var/minis/memory/` 下的真实长期记忆内容
- 含私人/敏感/未筛选信息的 shared 运行态数据

> 结论：**git 恢复的是“系统框架和样本镜像”，不是你的全部真实个人记忆数据。**

---

## 二、已纳入 git 的记忆系统内容
当前仓库已包含：
- `memory-topic-router/`
- `memory-write-gatekeeper/`
- `memory-layer-governor/`
- `memory-dedup-auditor/`
- `open-minis-memory-store/`
- `memory-system-maintainer/`
- `open-minis-handoff-orchestrator/`
- `session-context-compactor/`
- `README_MEMORY_SYSTEM.md`
- `MEMORY_SYSTEM_README.md`
- `memory-system-execution-index.md`
- `SHARED_SYNC_POLICY.md`
- `docs/memory-system/`
- `docs/memory-topics/`

---

## 三、重装后最快恢复顺序

### Step 1：恢复技能仓库
在 Open Minis 新环境中：
```sh
git clone https://github.com/joeshu/minis-skills.git /var/minis/workspace/minis-skills-import
```

### Step 2：恢复记忆系统相关技能
将仓库中的相关目录复制到技能目录：
- `memory-topic-router/`
- `memory-write-gatekeeper/`
- `memory-layer-governor/`
- `memory-dedup-auditor/`
- `open-minis-memory-store/`
- `memory-system-maintainer/`
- `open-minis-handoff-orchestrator/`
- `session-context-compactor/`

### Step 3：恢复 shared 镜像文档
将以下镜像恢复到 shared（如需要）：
- `docs/memory-system/` → 可恢复为 `/var/minis/shared/` 的系统文档
- `docs/memory-topics/` → 可恢复为 `/var/minis/shared/memory_topics/` 的真实专题样本库

### Step 4：恢复个人真实记忆（如有备份）
如果你有自己的 `/var/minis/memory/` 备份，再恢复：
- `GLOBAL.md`
- `YYYY-MM-DD.md`

> 这一步不从 git 自动恢复，因为真实记忆可能含私人/敏感信息。

---

## 四、推荐恢复映射

### 仓库内 → shared
- `docs/memory-system/*` → `/var/minis/shared/`
- `docs/memory-topics/*` → `/var/minis/shared/memory_topics/`

### 仓库内 → skills
- 各技能目录直接恢复到 `/var/minis/skills/`

---

## 五、敏感信息处理原则
以下内容**不建议直接进 git**：
- `/var/minis/memory/` 真实用户记忆
- 含私人信息的长期记忆
- Token、密码、API Key、隐私内容
- 未筛选的原始运行态日志

建议：
- git 只保存系统资产、样本镜像、文档和规则
- 真实个人记忆单独本地备份或导出

---

## 六、一句话恢复策略

### 最稳做法
- **git 恢复系统框架**
- **本地备份恢复真实记忆数据**

这样既能：
- 快速恢复整套记忆系统
- 又能避免把敏感个人记忆无差别塞进仓库
