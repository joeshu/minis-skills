# github-sync-helper

用途：执行常见 Git / GitHub 工作流，并在高风险操作前给出确认。

## 一眼判断
- 看仓库状态：`status / diff / log`
- 拉代码：`clone`
- 新建分支开发：`create-branch -> add -> commit -> push -> pr`
- 只内容替换：覆盖仓库目标文件内容，不改目标路径
- 直推 main：仅在用户明确要求时执行

## 默认行为
- push / pull 前先看 `git status`
- 默认优先 **分支 + PR**
- 高风险操作先确认
- API 操作需要 `GITHUB_TOKEN`
- 关键操作前先做仓库状态预检

## 分支与直推规则
- 默认：分支开发后开 PR
- 只有用户明确要求时才直推 main
- 团队协作 / 上游仓库默认不建议直推 main

## 高风险操作
- 删除分支
- `push-main`
- `empty-dir` / `restore-dir`
- rebase / merge 改写历史

## 响应模板
- 普通 Git：一句结论 + 一个命令
- 协作流程：一句建议 + 最短命令链
- 高风险：风险说明 + 确认
- API 操作：对象说明 + API 命令
- 失败：失败原因 + 下一步建议

## 常用命令
```sh
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh clone --url <url>
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh status
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh create-branch --name <branch>
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh commit --message "msg"
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh push
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh push-main
sh /var/minis/skills/github-sync-helper/scripts/gh_sync.sh pr --upstream <owner/repo> --head <owner:branch> --base main --title "..." --body "..."
```

## 失败速查
- 不在 git 仓库：先 `clone` 或 `init`
- push 认证失败：检查 `GITHUB_TOKEN`
- API 401/403：检查 token 权限
- `Author identity unknown`：设置 `git config user.name/user.email`
- merge/rebase 冲突：改用人工处理
