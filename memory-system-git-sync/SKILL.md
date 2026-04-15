---
name: memory-system-git-sync
description: Safely sync the Minis memory system to git, including selective shared mirrors, system docs, core memory skills, and restore assets. Use for check-only, incremental sync, full push, and one-step restore workflows, while preventing sensitive memory data, runtime noise, and unrelated changes from being committed.
compatibility: git, shell_execute, file_read, file_write
---

# memory-system-git-sync

一个用于**把记忆系统安全同步到 git，并支持一键恢复**的执行型技能。
目标：解决“这套记忆系统如何稳定发布、增量同步、避免误提交敏感内容、并在重装后快速恢复”的问题。

## 触发词
- 推送这套记忆系统
- 增量同步记忆系统到 git
- 一键发布记忆系统
- 同步 shared 文档到仓库
- 重装后恢复这套记忆系统
- memory system git sync / push memory system / restore memory system

## 输入
- 操作模式：`check` / `sync` / `push` / `restore`
- 可选：是否只同步记忆系统相关内容
- 可选：是否包含 shared 镜像刷新
- 可选：是否生成恢复命令模板或恢复摘要

## 输出
默认返回：
1. 本次操作模式
2. 将同步 / 已同步的文件范围
3. 被跳过的文件类型
4. 风险提示
5. 若是 restore，返回恢复顺序与命令模板

## 核心原则
- **只同步记忆系统相关内容**
- **shared 采用镜像进仓库，不直接把运行态 shared 当仓库目录**
- **默认排除敏感记忆与高频运行态噪音**
- **推送前先检查，再同步，再提交，再推送**
- **恢复时先恢复框架，再恢复个人真实记忆数据**

## 操作模式
### Mode A：check
只检查，不提交。
适用：
- 推送前预检
- 看哪些文件会被同步
- 看哪些内容会被排除

### Mode B：sync
执行镜像同步，但不 push。
适用：
- 刷新 shared → 仓库镜像
- 生成同步摘要
- 先人工确认再推送

### Mode C：push
完整执行：
- 检查
- 同步镜像
- git add
- commit
- push

### Mode D：restore
生成或执行恢复流程：
- clone 仓库
- 恢复核心技能目录
- 恢复 shared 镜像资产
- 提示真实个人记忆数据需单独恢复

## 同步范围
### 默认纳入同步
#### A. 核心技能目录
- `memory-topic-router/`
- `memory-write-gatekeeper/`
- `memory-layer-governor/`
- `memory-dedup-auditor/`
- `open-minis-memory-store/`
- `memory-system-maintainer/`
- `open-minis-handoff-orchestrator/`
- `session-context-compactor/`

#### B. 系统级入口与总文档
- `README_MEMORY_SYSTEM.md`
- `MEMORY_SYSTEM_README.md`
- `MEMORY_SYSTEM_REPORT.md`
- `MEMORY_SYSTEM_RESTORE_GUIDE.md`
- `MEMORY_SYSTEM_RESTORE_COMMANDS.md`
- `SHARED_SYNC_POLICY.md`
- `memory-system-execution-index.md`

#### C. shared 镜像目录
- `docs/memory-system/`
- `docs/memory-topics/`

#### D. 已脱敏 memory 镜像（可选）
- `docs/memory-export-sanitized/`
- 来源：`/var/minis/memory/` 的**脱敏副本**，不是原始真实记忆数据

### 默认排除
- `/var/minis/memory/*.md` 真实个人记忆数据
- 含敏感信息的 shared 运行态数据
- `.bak` / `.bak-*` / 临时备份文件
- 与记忆系统无关的技能目录
- 未经过滤的原始运行日志

## shared 镜像规则
### 系统文档镜像
来源：`/var/minis/shared/`
镜像到：`docs/memory-system/`

### 专题样本镜像
来源：`/var/minis/shared/memory_topics/`
镜像到：`docs/memory-topics/`

### 镜像原则
- git 保存的是**稳定镜像层**
- `shared` 保留的是**运行态层**
- 同步动作用复制快照，不直接让仓库目录依赖 shared 运行态

## 安全检查清单
推送前应检查：
1. 是否包含 `memory/` 真实个人记忆数据
2. 是否包含 Token / API Key / 密码 / 私钥 / 敏感信息
3. 是否包含 `.bak` 与临时文件
4. 是否混入无关技能改动
5. 是否已经刷新 shared 镜像
6. 提交信息是否只描述记忆系统本次变更

### 敏感信息处理规则
以下内容默认不进 git：
- `/var/minis/memory/` 下真实长期记忆
- 私密偏好、私人路径、凭据、密钥、隐私信息
- 未经过滤的真实运行态日志

若检测到敏感信息：
- 默认阻止 push
- 先输出风险说明
- 建议移除后再同步

## 工作流

### 决策树
1. 如果用户只是想看同步范围：用 `check`。
2. 如果用户想先刷新 shared 镜像：用 `sync`。
3. 如果用户想一键发布：用 `push`。
4. 如果用户重装后要恢复：用 `restore`。

### Phase 1: 范围确认
- 只同步记忆系统相关目录与文档
- 排除敏感数据与无关改动

### Phase 2: 检查
- 扫描待同步文件
- 标记排除项
- 识别风险项

### Phase 3: 镜像同步
- `shared/memory-system-*` → `docs/memory-system/`
- `shared/memory_topics/*.md` → `docs/memory-topics/`
- 清理记忆系统相关目录中的 `.bak` 文件

### Phase 4: 提交与推送
- 只 add 记忆系统相关文件
- 生成或使用明确提交信息
- push 到远端

### Phase 5: 恢复
恢复顺序：
1. clone 仓库
2. 恢复核心技能目录
3. 恢复 shared 镜像资产
4. 如有个人真实记忆备份，再恢复 `/var/minis/memory/`

## 恢复模板
### 一键恢复模板
- clone 仓库到临时目录
- 恢复核心技能目录到 `/var/minis/skills/`
- 恢复 `docs/memory-system/*` 到 `/var/minis/shared/`
- 恢复 `docs/memory-topics/*` 到 `/var/minis/shared/memory_topics/`
- 最后人工恢复真实个人记忆数据

### 恢复边界
- git 恢复的是系统框架与镜像资产
- 不是完整恢复你的个人真实记忆数据
- 真实记忆建议单独备份，不建议直接进仓库

## 输出风格
- `check`：问题摘要 + 待同步列表 + 风险项
- `sync`：已镜像文件 + 跳过项
- `push`：提交摘要 + commit id + push 结果
- `restore`：恢复顺序 + 命令模板 + 注意事项

## 响应模板
### check 模板
- `我已检查记忆系统同步范围，以下内容可安全同步，以下内容应排除。`

### sync 模板
- `我已刷新 shared → git 镜像，本次仅处理记忆系统相关资产。`

### push 模板
- `我已按安全范围完成记忆系统同步并推送。`

### restore 模板
- `我已整理出重装后的最快恢复顺序，默认从 https://github.com/joeshu/minis-skills.git 恢复框架，再恢复个人真实记忆。`

### 风险模板
- `检测到敏感或不应同步内容，建议先清理后再推送。`

## 成功标准
- 只同步记忆系统相关内容
- 不把敏感个人记忆误推进仓库
- shared 镜像保持更新
- 恢复流程清晰且可执行
- 记忆系统可以通过 git 快速恢复框架

## 与相关技能的分工
- `memory-system-git-sync`：负责**同步与恢复这套系统**
- `memory-system-maintainer`：负责**治理这套记忆系统本身**
- 前者面向发布/恢复；后者面向内容治理

## 风险与反例
- 把 `/var/minis/memory/` 真实记忆直接推到 git
- 把 shared 运行态数据全量推进仓库
- 混入无关技能改动一起提交
- 未刷新镜像就直接推送
- 恢复时误以为 git 已包含全部个人真实记忆数据

## 资源文件
- `README.md`
- `test-prompts.json`
- `execution-samples.md`
- `REPORT.md`

## 测试要求
至少覆盖：
1. check 模式预检
2. sync 模式镜像刷新
3. push 模式安全推送
4. restore 模式恢复顺序
5. 敏感信息拦截
6. 只提交记忆系统相关内容
