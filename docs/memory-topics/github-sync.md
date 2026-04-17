## GitHub 同步工作流专题
- 默认协作顺序：`create-branch -> add -> commit -> push -> pr`
- 用户明确要求时才允许直推 main。
- push / pull / merge / rebase 前先检查 `git status`。
- 删除分支、覆盖目录、历史改写属于高风险动作，先确认。
- 只内容替换场景：保留仓库目标路径和文件名，只覆盖内容。
