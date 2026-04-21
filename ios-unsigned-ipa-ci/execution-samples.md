# execution-samples

## Sample 1：首轮打通未签名 IPA 流水线
**场景**：用户给一个新的 SwiftUI / XcodeGen 仓库，希望首次建好 GitHub Actions 并生成未签名 IPA。

**执行要点**：
- 先检查 `GITHUB_TOKEN` 是否已设置
- 判定为模式 A
- 生成或校验 `project.yml`、workflow、必要模板
- 首次 push 后查询 Actions run
- 成功则下载 IPA；失败则下载日志

**期望输出**：
- 明确是模式 A
- 给出 CI run 状态
- 成功时给 IPA 路径；失败时给日志路径与诊断

---

## Sample 2：已有成功 CI 的后续代码迭代
**场景**：用户说“这个 iOS 项目继续优化代码并重新打包”。

**执行要点**：
- 先用 `mode_detect.sh` 判定是否已打通
- 判定为模式 B
- 默认只改代码，不动 workflow
- push 后查询最新 run
- 成功则下载最新 IPA

**期望输出**：
- 明确本次走模式 B
- 说明本次只改代码，没有无故修改 workflow
- 给出最新构建结果和 IPA 下载信息

---

## Sample 3：构建失败排查
**场景**：用户说“CI 构建失败了，帮我排查并修复”。

**执行要点**：
- 先查询最近失败 run
- 下载 build log
- 优先判断是代码问题、工程问题还是 workflow 问题
- 默认先做最小修复，不直接重写整个工程

**期望输出**：
- 给出失败类型
- 给出最小修复路径
- 附日志文件或日志摘要
