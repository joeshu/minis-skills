## GitHub 平台专题
- 平台相关任务优先检查是否涉及仓库、Issue、Release、Actions、PR、Fork、Upstream。
- 若任务是仓库协作或同步流程，优先联动 `github-sync-helper` 工作流规则。
- GitHub 平台对象操作通常依赖 `GITHUB_TOKEN`；若缺失，应先提示环境变量缺失。
- 涉及共享主分支时，默认优先分支 + PR，而不是直推 main。
