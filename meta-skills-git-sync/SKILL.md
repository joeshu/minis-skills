---
name: meta-skills-git-sync
description: Safely sync the Minis meta skills stack to git and support one-step restore back into Minis, including bootstrapper, lifecycle manager, output governor, scoring standards, review docs, and meta system documents, while avoiding unrelated changes and runtime noise. Use for check-only, scoped push, and restore workflows.
compatibility: git, shell_execute, file_read, file_write
---

# meta-skills-git-sync

一个用于**把 Minis 元技能体系安全同步到 git，并支持一键恢复回 Minis**的执行型技能。

目标：解决“这套元技能体系如何稳定发布、只提交相关文件、不混入无关改动、并在重装后一键恢复”的问题。

## 触发词
- 推送这套元技能体系
- 一键恢复元技能体系
- 同步 meta skills 到 git
- restore meta skills
- 把这套元治理系统安全推到仓库
- 重装后恢复元技能体系

## 输入
- 操作模式：`check` / `sync` / `push` / `restore`
- 可选：是否只处理元技能体系相关内容
- 可选：是否生成恢复命令模板
- 可选：是否输出最小检查结果

## 输出
默认返回：
1. 本次操作模式
2. 将同步 / 已同步的文件范围
3. 被排除的无关改动
4. 风险提示
5. 若是 restore，返回恢复顺序与命令模板

## 核心原则
- **只同步元技能体系相关内容**
- **默认排除无关技能改动与临时文件**
- **推送前先检查范围，再提交，再推送**
- **恢复时优先恢复框架，再做最小检查**
- **元技能体系是 git-first 资产，可直接 clone / pull 恢复**

## 操作模式
### Mode A：check
只检查，不提交。
适用：
- 推送前预检
- 看哪些文件会被同步
- 看是否混入无关改动

### Mode B：sync
执行增量同步准备，但不 push。
适用：
- 只刷新元技能体系相关文件范围
- 先做限定 add / status 检查
- 先人工确认再 push

### Mode C：push
完整执行：
- 检查
- 只 add 元技能体系相关文件
- commit
- push

### Mode D：restore
生成或执行恢复流程：
- clone 仓库
- checkout `master`
- 恢复元技能体系文件
- 做最小检查

## 同步范围
### 默认纳入同步
#### A. 核心元技能
- `open-minis-project-bootstrapper/`
- `open-minis-skill-lifecycle-manager/`
- `open-minis-output-governor/`

#### B. 评分与评审规范
- `SKILL_SCORING_STANDARD.md`
- `SKILL_REVIEW_CHECKLIST.md`

#### C. 元系统文档
- `META_SKILLS_INDEX.md`
- `META_SKILLS_REPORT.md`
- `META_SKILLS_FREEZE_NOTE.md`
- `META_SKILLS_EXECUTION_INDEX.md`
- `META_SKILLS_RESTORE_GUIDE.md`

#### D. 方法来源
- `darwin-skill/`

### 默认排除
- 与元技能体系无关的其他技能目录改动
- `.bak` / `.bak-*` / 临时备份文件
- 无关测试残留
- 运行态临时文件

## 安全检查清单
推送前应检查：
1. 是否混入无关技能改动
2. 是否存在 `.bak` 或临时文件
3. 是否提交范围仅限元技能体系
4. 提交信息是否只描述元技能体系本次变更

若检测到风险：
- 默认先提示
- 不建议直接全仓库提交
- 应限定 add 范围后再推送

## 工作流

### 决策树
1. 如果用户只是想看同步范围：用 `check`。
2. 如果用户想先做增量同步准备但不推送：用 `sync`。
3. 如果用户想安全推送元技能体系：用 `push`。
4. 如果用户重装后要恢复：用 `restore`。

### Phase 1: 范围确认
- 只处理元技能体系相关目录与文档
- 排除无关改动与临时文件

### Phase 2: 检查
- 扫描待同步文件
- 标记排除项
- 输出风险项

### Phase 3: 增量同步准备
- 只针对元技能体系相关文件做 `git status -- <scope>` 检查
- 必要时刷新已修改的元技能文档/索引
- 不 push，仅输出本次限定范围

### Phase 4: 提交与推送
- 只 add 元技能体系相关文件
- 生成或使用明确提交信息
- push 到远端 `master`

### Phase 5: 恢复
恢复顺序：
1. `cd /var/minis`
2. 若需要全量恢复：删除旧 `skills/`
3. `git clone https://github.com/joeshu/minis-skills.git skills`
4. `cd /var/minis/skills && git checkout master`
5. 做最小检查，确认核心元技能与文档存在

## 一键恢复模板
### 全量恢复
```sh
cd /var/minis
rm -rf skills
git clone https://github.com/joeshu/minis-skills.git skills
cd /var/minis/skills
git checkout master
```

### 增量恢复
```sh
cd /var/minis/skills
git checkout master
git pull origin master
```

### 增量同步（不推送）
```sh
cd /var/minis/skills
git checkout master
git status -- \
  open-minis-project-bootstrapper \
  open-minis-skill-lifecycle-manager \
  open-minis-output-governor \
  meta-skills-git-sync \
  darwin-skill \
  SKILL_SCORING_STANDARD.md \
  SKILL_REVIEW_CHECKLIST.md \
  META_SKILLS_INDEX.md \
  META_SKILLS_REPORT.md \
  META_SKILLS_FREEZE_NOTE.md \
  META_SKILLS_EXECUTION_INDEX.md \
  META_SKILLS_RESTORE_GUIDE.md
```

### 最小检查
```sh
cd /var/minis/skills && \
for f in \
  open-minis-project-bootstrapper/SKILL.md \
  open-minis-skill-lifecycle-manager/SKILL.md \
  open-minis-output-governor/SKILL.md \
  SKILL_SCORING_STANDARD.md \
  SKILL_REVIEW_CHECKLIST.md \
  META_SKILLS_INDEX.md \
  META_SKILLS_REPORT.md \
  META_SKILLS_FREEZE_NOTE.md \
  META_SKILLS_EXECUTION_INDEX.md \
  META_SKILLS_RESTORE_GUIDE.md \
  darwin-skill/SKILL.md
  do [ -f "$f" ] && echo OK:$f || echo MISS:$f; done
```

## 输出风格
- `check`：待同步范围 + 排除项 + 风险摘要
- `sync`：限定范围 + 当前变更摘要 + 未推送说明
- `push`：提交摘要 + commit id + push 结果
- `restore`：恢复顺序 + 命令模板 + 最小检查项

## 响应模板
### check 模板
- `我已检查元技能体系同步范围，以下内容可安全同步，以下内容应排除。`

### sync 模板
- `我已整理好元技能体系的增量同步范围，本次先不推送。`

### push 模板
- `我已按限定范围完成元技能体系同步并推送。`

### restore 模板
- `我已整理出元技能体系的一键恢复方案，默认从 https://github.com/joeshu/minis-skills.git 的 master 分支恢复。`

### 风险模板
- `检测到无关改动或临时文件，建议限定范围后再推送。`

## 成功标准
- 只同步元技能体系相关内容
- 不混入无关技能改动
- 支持增量同步准备与增量恢复
- 恢复流程清晰且可执行
- 能通过 git 快速恢复整套元技能框架

## 与相关技能的分工
- `meta-skills-git-sync`：负责**同步与恢复元技能体系**
- `open-minis-skill-lifecycle-manager`：负责**治理单个 skill 生命周期**
- `memory-system-git-sync`：负责**记忆系统同步与恢复**

## 风险与反例
- 把全仓库无关改动一起提交
- 把 `.bak` 和临时文件推进仓库
- 恢复时忘记切回 `master`
- 误以为 restore 需要复杂镜像层；元技能体系本身就是 git-first 资产

## 资源文件
- `README.md`
- `test-prompts.json`
- `execution-samples.md`
- `REPORT.md`

## 测试要求
至少覆盖：
1. check 模式预检
2. sync 模式限定范围增量同步
3. push 模式限定范围推送
4. restore 模式一键恢复
5. 无关改动拦截
6. 最小检查输出
7. 增量恢复方案
