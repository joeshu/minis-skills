# opencode2api-aliyun-node-ops

用途：通过 SSH 登录固定阿里云服务器 `118.190.200.12`，以 Node 分离模式维护 `joeshu/opencode2api-enhanced`，覆盖 Open Minis 本地改动、Git 推送、GitHub Actions 检查、服务器拉库、测试、重启、健康检查、线上冒烟、回滚与发布汇报的闭环。

## 适用范围
- 固定仓库：`joeshu/opencode2api-enhanced`
- 固定服务器：`118.190.200.12`
- 固定用户：`root`
- 固定模式：Node 分离模式（`opencode serve` + `node index.js`）
- 默认不依赖 `OPENCODE_SERVER_PASSWORD`

## 默认顺序
1. 先确认本地仓库路径（workspace / shared）
2. 先做本地验证：`npm run verify:smoke`
3. 再做 Git 提交与 push
4. 再检查 GitHub Actions 是否全绿
5. 再上服务器停旧进程、拉库、安装依赖、服务器 smoke
6. 再重启分离模式服务
7. 再做 `/health/live`、`/health/ready` 与接口冒烟
8. 若失败，优先日志定位；必要时回滚

## 核心原则
- 默认直接执行，不空讲步骤
- 本地改动保持最小、聚焦、可回滚
- Git 提交不混入无关文件
- 服务器上线前默认先等 Actions 全绿
- 服务重启前先停旧进程，避免旧版本干扰
- 验证优先级：本地 smoke → 服务器 smoke → ready / models / chat 冒烟
- 长步骤中主动汇报“已通过项 + 当前阻塞项”

## 常用脚本
- `scripts/opencode_ops.sh`：总入口
- `scripts/local_repo_snapshot.sh`：本地仓库快照
- `scripts/pre_push_check.sh`：提交前检查
- `scripts/check_github_actions_green.sh`：检查 CI 全绿
- `scripts/deploy_verify_remote.sh`：服务器部署 + 验证
- `scripts/smoke_api_remote.sh`：远程业务冒烟
- `scripts/rollback_remote.sh`：服务器回滚
- `scripts/release_report_template.sh`：发布报告模板

## 最常见路线
### 1. 本地改动并推送
`snapshot -> 修改 -> verify:smoke -> prepush -> git commit -> git push`

### 2. 服务器部署验证
`check actions -> deploy -> ready -> models`

### 3. 线上业务冒烟
`smoke`

### 4. 发布异常回滚
`rollback -> ready -> 简短汇报`

## 已知限制
- 这是固定服务器/固定仓库专属技能，不是通用部署技能
- 默认只覆盖 Node 分离模式主路径，不扩展 Docker 主路径
- 若 OpenCode / GitHub Actions / 服务器系统行为变化，需要按真实结果修订
- `verify:smoke` 目前是主验证方式，若项目验证体系变化需要同步更新技能

## 配套文件
- `SKILL.md`：完整工作流、边界、脚本入口、评分标准
- `REPORT.md`：评分与成熟度结论
- `test-prompts.json`：关键测试场景
- `execution-samples.md`：真实执行样本模板
- `references/REGRESSION_SAMPLES.md`：回归样例集
