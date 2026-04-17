# opencode2api-aliyun-node-ops 回归样例集

## Sample 1：本地小改动并推送
- 目标：在 `/var/minis/workspace/opencode2api-enhanced` 做小范围代码优化
- 最低流程：`snapshot -> 修改 -> verify:smoke -> prepush -> git commit -> git push`
- 通过标准：本地 smoke 通过，提交粒度清楚，push 成功

## Sample 2：服务器拉库并验证
- 目标：将最新 GitHub 提交部署到 `118.190.200.12`
- 最低流程：`deploy`
- 通过标准：服务器 smoke 通过，`/health/ready` 正常

## Sample 3：线上业务冒烟
- 目标：验证代理真实可用而不只是 ready 正常
- 最低流程：`smoke`
- 通过标准：`v1/models` 正常，`v1/chat/completions` 返回有效结果

## Sample 4：ready 失败排障
- 目标：定位 `live` 正常但 `ready` 失败
- 最低流程：查看 `10000/10001`、serve/proxy 日志、确认是否误走自动管理模式
- 通过标准：找到阻塞点，给出修复或回滚决策

## Sample 5：紧急回滚
- 目标：发布后异常，回退到上一个稳定提交
- 最低流程：记录现场 -> `rollback` -> `ready` 检查 -> 简短发布/事故汇报
- 通过标准：服务恢复、回滚目标明确、汇报清楚

## Sample 6：正式发布汇报
- 目标：输出可复用的上线结果总结
- 最低流程：`report`
- 通过标准：包含改动、Git 信息、本地验证、服务器验证、健康检查、风险与后续
