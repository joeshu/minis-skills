---
name: memory-topics-git-publisher
description: Safely mirror the Minis response-style and retrieval governance system into a dedicated folder inside the joeshu/minis-skills repository, with one-command check/sync/push/restore workflows and restore-oriented assets.
compatibility: git, shell_execute, file_read, file_write
---

# memory-topics-git-publisher

一个用于**把当前回答风格 / 检索治理体系，以最稳妥方式同步到 `joeshu/minis-skills` 仓库中的单独文件夹，并支持恢复到本机**的执行型技能。

目标：解决“这套体系如何以单独目录形式稳定上传到 GitHub、避免误推无关内容、支持镜像同步与后续恢复”的问题。

## 适用场景
- 把当前 `/var/minis/shared/memory_topics/` 这套体系单独推到 `https://github.com/joeshu/minis-skills.git`
- 希望只同步这一套体系，不混入其他技能或运行态文件
- 希望生成可恢复、可维护、可增量更新的 Git 镜像目录
- 希望从仓库镜像安全恢复到本机

## 触发词
- 上传这套体系到 minis-skills
- 推送回答风格体系到 git
- 一键同步 memory topics 体系
- 发布这套治理体系到 GitHub
- 从 git 恢复这套体系到本机
- memory topics git publish / push response-style system / restore memory topics system

## 输入
- 操作模式：`check` / `sync` / `push` / `restore-check` / `restore-sync`
- 目标仓库：默认 `https://github.com/joeshu/minis-skills.git`
- 目标子目录：默认 `published-systems/memory-topics-governance/`
- 默认包含：`GLOBAL.md` 镜像副本
- 可选：是否生成恢复说明与发布报告

## 输出
默认返回：
1. 当前模式
2. 仓库定位结果
3. 将同步 / 已同步 / 将恢复 / 已恢复的文件范围
4. 被排除内容
5. 风险项
6. 若为 push，返回 commit 摘要与推送结果

## 核心原则
- **只同步这套体系相关文件**
- **仓库内使用单独文件夹，不污染其他技能目录**
- **默认镜像 shared 侧体系文件 + `GLOBAL.md`**
- **推送前先 check，再 sync，再 push**
- **恢复前先 restore-check，再 restore-sync**
- **恢复前先备份本机现状**
- **不恢复真实 daily memory**

## 仓库与目标目录约定
- 默认仓库：`https://github.com/joeshu/minis-skills.git`
- 优先本地路径：
  1. `/var/minis/mounts/minis-skills/`
  2. 用户明确提供的本地仓库路径
  3. 已克隆本地仓库路径
- 默认发布目录：`published-systems/memory-topics-governance/`

## 同步范围
### 默认纳入
- `/var/minis/shared/memory_topics/` 下当前体系相关文件
- `/var/minis/memory/GLOBAL.md` 镜像副本
- 发布资产：
  - `README.md`
  - `REPORT.md`
  - `RESTORE.md`
  - `execution-samples.md`
  - `scripts/sync_memory_topics_governance.sh`

### 默认排除
- `/var/minis/memory/YYYY-MM-DD.md` 等真实 daily memory
- `/var/minis/shared/memory_topics/` 下与本体系无关、且用户未要求纳管的旧专题文件
- `.bak` / 临时文件 / 日志 / 无关技能目录
- 敏感环境变量、凭据、token、私密路径

## 工作流

### Mode A：check
只检查，不写入仓库。
- 检查目标仓库是否存在且为 git 仓库
- 检查目标发布目录是否已存在
- 识别将纳入同步的文件
- 识别将排除的文件
- 输出风险与下一步建议

### Mode B：sync
刷新镜像，但不 push。
- 创建或刷新目标子目录
- 复制体系文件到发布目录
- 生成 README / REPORT / RESTORE / execution-samples / 同步脚本
- 不执行 git push

### Mode C：push
完整执行：
- check
- sync
- git add 目标子目录
- commit
- push

### Mode D：restore-check
只检查恢复影响，不真正恢复。
- 检查发布目录是否存在
- 检查本机当前文件是否存在
- 列出将覆盖的 shared 文件与 `GLOBAL.md`
- 提示备份路径与恢复风险

### Mode E：restore-sync
执行恢复到本机。
- 先备份 `/var/minis/shared/memory_topics/` 与 `/var/minis/memory/GLOBAL.md`
- 再恢复镜像中的 shared 文件
- 默认恢复 `GLOBAL.md`
- 不恢复 daily memory

## 检查清单
1. 目标仓库路径是否存在
2. 是否为 git 仓库
3. 当前工作区是否有无关改动
4. 目标发布目录是否清晰隔离
5. 是否混入 daily memory 或敏感内容
6. 是否已生成恢复文档与同步脚本
7. 恢复前是否已准备备份路径

## 风险规则
- 若仓库未挂载或不存在：停止在 check 阶段
- 若检测到无关改动：默认只 add 目标子目录，不扩大提交范围
- 若检测到敏感内容：默认停止 push
- 恢复前默认先备份，不直接裸覆盖

## 恢复思路
- 从仓库拉回 `published-systems/memory-topics-governance/`
- 按 `RESTORE.md` 将 `shared/memory_topics/` 恢复回 `/var/minis/shared/memory_topics/`
- 将 `memory/GLOBAL.md` 恢复回 `/var/minis/memory/GLOBAL.md`
- 不处理 daily memory

## 成功标准
- 在 `joeshu/minis-skills` 仓库中形成单独目录
- 只包含这套体系及其发布资产
- 不混入无关技能与敏感运行态
- 支持增量更新与后续恢复
- 恢复时先备份再覆盖

## 资源文件
- `README.md`
- `test-prompts.json`
- `execution-samples.md`
- `REPORT.md`
- `scripts/sync_memory_topics_governance.sh`

## 测试要求
至少覆盖：
1. 仓库未挂载时的 check 阻断
2. 已挂载仓库时的 sync 成功
3. 只 add 目标子目录
4. push 前敏感内容检查
5. restore-check 能列出覆盖范围
6. restore-sync 先备份再恢复
7. `GLOBAL.md` 镜像纳入与恢复
