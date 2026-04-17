---
name: github-sync-helper
description: Execute common Git and GitHub workflows in Minis, including clone, init, remote setup, branch operations, commit/push/pull, PR creation, upstream sync, and GitHub platform object management. Use when the user asks about GitHub/Git commands, repository sync, branches, remotes, PRs, issues, releases, actions, or wants safe step-by-step repo operations.
compatibility: git and python3 required; optional env GITHUB_TOKEN for GitHub API and non-interactive HTTPS push
---

# github-sync-helper

一个用于 **Git / GitHub 常见操作与协作流程** 的执行型技能。
目标：把高频 Git/GitHub 操作变成**可判断、可执行、可回滚、少误操作**的流程。

## 触发词
- GitHub 怎么用 / git 怎么用
- clone / init / remote / branch / commit / push / pull / fetch
- merge / rebase / tag / release / PR / fork / upstream
- issues / labels / milestones / actions
- 同步到上游 / 删除分支 / 直推 main / 恢复目录 / 清空目录

## 输入
- 用户目标：拉代码 / 提交 / 推送 / 开 PR / 同步分支 / 管理仓库对象
- 仓库路径或仓库地址
- 可选偏好：是否直推 main、是否只替换内容、是否走 PR、是否需要 API 操作

## 输出
默认返回：
1. 当前判断出的操作类型
2. 推荐命令或脚本入口
3. 必要的风险提示
4. 下一步动作

## 风险分级
### L1：低风险
- `status / diff / log / fetch`
- 查看远端 / 查看分支 / 查看 issues / 查看 releases

默认：可直接执行。

### L2：中风险
- `clone / init / add / commit / checkout / create-branch / pull / push`
- 新建 issue / label / milestone / release

默认：先检查仓库状态，再执行。

### L3：高风险
- 删除分支
- `push-main`
- 强覆盖目录 / 清空目录 / restore-dir
- rebase / merge 可能改写历史
- 用户明确要求直推 main

默认：先确认，再执行。

## 工作流

### 决策树
1. 先判断用户是要：本地 Git 操作、远端同步、协作流程，还是 GitHub 平台对象管理。
2. 如果涉及 GitHub 平台对象（issues / labels / releases / actions），优先走 API 分支。
3. 如果涉及 clone / remotes / upstream / pull / push，优先走仓库同步分支。
4. 如果涉及 commit / branch / PR，优先走协作流程分支。
5. 如果涉及删分支、直推 main、覆盖目录、历史改写，则标记为高风险，先确认。
6. 默认优先选择 **分支 + PR**；只有用户明确要求才直推 main。

### Phase 1: 判断操作类型
- 本地仓库操作：`init / status / diff / add / commit / branch / checkout`
- 远端同步：`clone / remote / fetch / pull / push / upstream`
- 协作流程：`branch -> commit -> push -> pr`
- 平台对象：`issues / labels / milestones / releases / actions`

### Phase 2: 预检查
执行以下检查：
1. push / pull / merge / rebase 前先看 `git status`
2. API 操作前检查 `GITHUB_TOKEN` 是否存在
3. 当前目录不是 git 仓库时，先提示 `clone` 或 `init`
4. 如果用户要求“只内容替换”，保持仓库目标路径不变，只覆盖内容

### 仓库状态预检清单
在执行关键操作前，优先检查：
- 当前目录是否为 git 仓库
- 当前分支名称
- 工作区是否干净
- 是否存在未提交改动
- 是否已配置远端 origin/upstream
- push 目标分支是否明确
- 当前用户是否明确要求直推 main
- API 操作是否具备 `GITHUB_TOKEN`

若任一关键条件不满足，先返回检查结论，再给下一步建议。
### Phase 3: 选择命令
| 场景 | 推荐动作 |
|---|---|
| 下载仓库 | `clone --url <url>` |
| 当前目录初始化 | `init` |
| 查看状态 | `status` |
| 查看差异 | `diff [--staged]` |
| 新建分支 | `create-branch --name <b>` |
| 切换分支 | `checkout --name <b>` |
| 提交改动 | `add` -> `commit` |
| 同步远端 | `fetch` / `pull` / `push` |
| 直推 main | `push-main`（仅在明确要求时） |
| 增加 upstream | `add-upstream --upstream <owner/repo>` |
| 创建 PR | `pr --upstream ... --head ... --base ...` |
| 管理 GitHub 对象 | `gh-issues-list` 等 API 命令 |

### 分支 / PR / 直推 选择规则
- 默认：`create-branch -> commit -> push -> pr`
- 用户说“帮我提交并推送”，但未明确要求 main：默认仍优先分支 + PR
- 用户明确说“直接推 main / 不要 PR / 就推上去到主分支”：才允许 `push-main`
- 如果当前仓库是个人临时仓库且用户明确接受风险，可放宽为直推 main
- 只要涉及共享主分支、上游仓库、团队协作，默认优先 PR

### Phase 4: 执行与输出
1. 先给一句短判断。
2. 再给推荐命令或直接执行。
3. 若为高风险，先确认。
4. 执行后返回最关键结果：分支名、commit、push 结果、PR 链接、对象编号等。

## 成功标准
- 能正确区分 Git 本地操作、仓库同步、协作流程、平台对象管理
- 默认优先分支 + PR，而不是直接直推 main
- 高风险操作会触发确认
- 只内容替换场景不会误改路径和文件名
- 失败时能给出明确下一步建议

## 检查点
以下情况应先确认：
- 删除本地或远程分支前
- 清空目录 / restore-dir 覆盖前
- 直推 main 前
- rebase / merge 可能改写历史前
- 用户要求绕过 PR 流程时

### 确认模板
- 删分支前：`这是删除分支操作，可能无法轻易恢复。是否继续？`
- 覆盖目录前：`这会先删除目标目录当前内容，再恢复新内容。是否继续？`
- 直推 main 前：`你要求直接推送到 main，这会绕过 PR 流程。是否继续？`
- 历史改写前：`这一步可能改写提交历史。是否继续？`

## 输出风格
- 普通操作：短结论 + 推荐命令
- 仓库列表：Markdown 表格 + 编号
- 高风险操作：短风险说明 + 确认
- API 操作：结果摘要 + 对象编号/标题
- 失败：失败原因 + 下一步建议

## 列表输出规范
以下场景优先使用 Markdown 表格，并带 `编号` 列：
- 仓库列表
- 分支列表
- issues 列表
- labels 列表
- milestones 列表
- releases 列表
- workflows 列表

建议字段：
- 仓库：`编号 | 仓库(owner/repo) | 可见性 | 默认分支 | 最近更新 | URL`
- 分支：`编号 | 分支名 | 本地/远程 | 是否默认分支 | 最近提交`
- Issue：`编号 | Issue # | 标题 | 状态 | 更新时间 | URL`
- Label：`编号 | 名称 | 颜色 | 描述`
- Milestone：`编号 | 标题 | 状态 | Due Date | URL`
- Release：`编号 | Tag | 名称 | 是否预发布 | 发布时间 | URL`
- Workflow：`编号 | 名称 | 文件 | 状态 | URL`

## 响应模板
### 普通 Git 操作模板
- 结论：一句话说明当前建议
- 动作：给 1 个最直接命令或步骤

### 协作流程模板
- 结论：说明推荐走分支 + PR
- 动作：列出最短命令链
- 默认不鼓励直推 main

### 高风险模板
- 结论：一句话说明风险
- 动作：说明将执行什么
- 确认：`是否继续？`

### API 操作模板
- 结论：说明要管理的 GitHub 对象
- 动作：给 API 命令
- 结果：返回编号 / 标题 / 链接

### 失败模板
- 结论：说明失败点
- 下一步：给一个最直接的修复建议

## 失败处理
- `not inside a git repo`：提示先 `clone` 或 `init`
- push 认证失败：提示检查 `GITHUB_TOKEN`
- API 401/403：提示 token 权限不足或过期
- pull / merge 冲突：提示进入人工冲突处理
- `Author identity unknown`：提示设置 `git config user.name/user.email`

## 冲突与复杂场景边界
以下场景默认**不假装自动安全完成**，而是优先诊断并转人工处理：
- merge 冲突
- rebase 冲突
- cherry-pick 冲突
- 历史重写后需要强推
- 多远端分支状态不一致且用户未明确目标分支

处理原则：
- 先说明当前冲突或不确定点
- 再给最直接的下一步建议
- 必要时建议进入交互式终端处理

### 复杂场景模板
- merge/rebase 冲突：`当前出现冲突，自动安全处理风险较高。建议先查看冲突文件，再决定继续 merge/rebase 还是回退。`
- upstream 同步冲突：`上游与当前分支存在差异，建议先 fetch 后检查差异，再决定 merge 或 rebase。`
- 历史改写风险：`这一步可能改写已存在的提交历史，建议确认是否真的需要继续。`

## 真实脚本入口
统一入口：
```sh
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh <command> [options]
```

## 命令清单
- `clone`
- `remotes` / `add-remote` / `set-remote-url` / `remove-remote` / `add-upstream`
- `status` / `diff` / `log`
- `branches` / `create-branch` / `checkout` / `delete-branches`
- `add` / `commit`
- `fetch` / `pull` / `push` / `push-main`
- `empty-dir` / `restore-dir`
- `pr`
- `gh-issues-list` / `gh-issue-create` / `gh-issue-close`
- `gh-labels-list` / `gh-label-create`
- `gh-milestones-list` / `gh-milestone-create`
- `gh-releases-list` / `gh-release-create`
- `gh-actions-list` / `gh-actions-dispatch`

## 最佳实践
- 默认分支协作走：`create-branch -> add -> commit -> push -> pr`
- 用户明确要求“只内容替换”时：保留目标路径与文件名，只覆盖内容
- 用户明确要求“提交并推送”时，可继续执行，不必重复确认普通步骤
- 高风险步骤仍需单独确认

## 禁止事项
- 输出或暴露 `$GITHUB_TOKEN`
- 默认直接直推 main
- 未检查 `git status` 就贸然 push/pull
- 在复杂冲突场景假装可以自动安全处理

## 资源文件
- `README.md`：速查说明
- `test-prompts.json`：评估样例
- `execution-samples.md`：真实执行样本模板
- `scripts/gh_sync.sh`：统一命令入口脚本

## 测试要求
至少覆盖：
1. 基础 clone / status / commit / push
2. 分支 + PR 协作流
3. 直推 main 的风险确认
4. 只内容替换场景
5. GitHub API 对象管理
6. 脚本入口存在且可直接调用
