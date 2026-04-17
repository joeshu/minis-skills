---
name: opencode2api-aliyun-node-ops
version: 1.0.0
description: 通过 SSH 登录阿里云服务器，使用 Node.js 安装、启动、排查、开发和维护 joeshu/opencode2api-enhanced，并覆盖 Open Minis 本地改代码、Git 提交推送、服务器拉取更新、运行测试、查看日志、实现功能、持续优化与回归验证的完整闭环。适用于用户提到 opencode2api-enhanced、阿里云服务器、118.190.200.12、SSH 登录、Node 部署、OpenCode 后端、健康检查、10000/10001 端口、无 OPENCODE_SERVER_PASSWORD 模式、推送 GitHub、服务器拉库、测试、日志、功能开发、代码优化等场景。
status: frozen-production
---

# opencode2api-aliyun-node-ops

用于复用这次已经跑通的 **Open Minis 本地开发 + GitHub 推送 + 阿里云服务器 Node 部署/验证** 工作流。

## 已知固定上下文
- 远端仓库：`https://github.com/joeshu/opencode2api-enhanced.git`
- Open Minis 本地候选工作目录：
  - `/var/minis/workspace/opencode2api-enhanced`
  - `/var/minis/shared/opencode2api-enhanced`
- 默认优先顺序：先看 `workspace`，若不存在或用户明确使用 shared，则切到 `shared`
- 服务器：`118.190.200.12`
- 服务器登录用户：`root`
- SSH 密码环境变量：`ALI`
- 服务器项目目录：`/root/opencode2api-enhanced`
- 系统：Alibaba Cloud Linux 3
- Node 可用版本：20.x
- 代理端口：`10000`
- OpenCode 后端端口：`10001`
- 当前部署结论：
  - **Node 版可运行**
  - **不需要 `OPENCODE_SERVER_PASSWORD`**
  - 推荐采用**分离模式**：
    - 后端：`opencode serve --hostname 127.0.0.1 --port 10001`
    - 代理：`node index.js`
    - `OPENCODE_PROXY_MANAGE_BACKEND=false`
    - `OPENCODE_SERVER_URL=http://127.0.0.1:10001`

## 正式版状态说明
- 版本：`1.0.0`
- 状态：`frozen-production`
- 含义：当前技能已达到生产可用级，默认进入“冻结维护”状态。
- 后续策略：
  - 默认不再随意扩大范围重写
  - 仅在真实使用中发现边界问题、流程缺口、脚本失效或用户明确要求增强时再修改

## 适用边界
此技能适用于：
- `joeshu/opencode2api-enhanced`
- Open Minis 本地工作目录候选：
  - `/var/minis/workspace/opencode2api-enhanced`
  - `/var/minis/shared/opencode2api-enhanced`
- 阿里云服务器 `118.190.200.12`
- `root` 用户 + 环境变量 `ALI`
- Node 分离模式：`opencode serve` + `node index.js`

## 已知限制
1. 当前技能默认绑定到这台固定服务器与固定仓库，不是通用多服务器部署技能。
2. 默认运行模式是 Node 分离模式，不覆盖 Docker 主路径的全部细节。
3. `OPENCODE_SERVER_PASSWORD` 默认不作为 Node 方案必需项；如果未来项目机制变化，需要重新验证。
4. `verify:smoke` 是当前主验证方式，但若项目后续验证体系变化，需要同步更新技能。
5. 若 GitHub / OpenCode CLI / 服务器系统行为发生明显变化，需要根据真实结果修订。


## 使用前检查
优先检查环境变量：
```sh
[ -n "$ALI" ] && echo ALI=set || echo ALI=not_set
[ -n "$API_KEY" ] && echo API_KEY=set || echo API_KEY=not_set
[ -n "$GITHUB_TOKEN" ] && echo GITHUB_TOKEN=set || echo GITHUB_TOKEN=not_set
```

说明：
- `ALI`：服务器 SSH 密码
- `API_KEY`：代理鉴权令牌
- `GITHUB_TOKEN`：仅在 GitHub API / 非交互 HTTPS 推送确实需要时检查；普通 git push 若本地已配好凭据可不强依赖
- **不要默认要求 `OPENCODE_SERVER_PASSWORD`**

## 核心原则
1. 默认直接执行，不只讲步骤。
2. 本地开发优先在 `opencode2api-enhanced` 的实际存在目录进行：默认先检查 `/var/minis/workspace/opencode2api-enhanced`，若不存在或用户明确使用 shared，则改用 `/var/minis/shared/opencode2api-enhanced`。
3. 改代码时保持最小改动、单一目的、可回滚。
4. 本地验证优先 `npm run verify:smoke`。
5. Git 流程优先：检查状态 → 最小提交 → 推送。
6. 服务器流程优先：拉库 → 安装依赖 → 测试/健康检查 → 重启服务 → 查看日志。
7. Node 模式下，**不要把 `OPENCODE_SERVER_PASSWORD` 当成必需项**。
8. 优先用**分离模式**运行服务，不默认依赖代理自动拉起后端。
9. 当部分关键校验已通过、剩余步骤明显长时间运行时，主动汇报“已通过项 + 阻塞项”，不要长时间无反馈。
10. 若用户要求直接推送 GitHub 并上线，就按闭环执行，不重复询问显而易见步骤。

## Phase A：Open Minis 本地开发

### 0）先确定本地仓库目录
优先按下面顺序选择：
```sh
if [ -d /var/minis/workspace/opencode2api-enhanced ]; then
  REPO_DIR=/var/minis/workspace/opencode2api-enhanced
elif [ -d /var/minis/shared/opencode2api-enhanced ]; then
  REPO_DIR=/var/minis/shared/opencode2api-enhanced
else
  echo "repo_not_found"
fi
```

若用户明确说项目在 shared 下，则直接使用 shared 路径。

### 1）确认本地仓库状态
```sh
cd "$REPO_DIR" && git status --short --branch && git remote -v
```

### 2）修改前预检查
执行前优先看：
```sh
cd "$REPO_DIR" && git status --short --branch && git diff --stat
```

若工作区不干净：
- 先判断这些改动是否属于当前任务
- 不要把无关改动混入本次提交

### 3）本地开发/修改
- 用 `file_read` / `file_edit` / `file_write` 修改文件
- 保持每次改动聚焦一个目标
- 修改后优先运行最小必要验证

### 4）本地验证
优先：
```sh
cd "$REPO_DIR" && npm run verify:smoke
```

可选辅助：
```sh
cd "$REPO_DIR" && npm test
```
但要记住：当前主验证方式是 `verify:smoke`，Jest 不稳定时不作为唯一依据。

## Phase B：推送到 GitHub

### 1）查看改动
```sh
cd "$REPO_DIR" && git status --short && git diff --stat
```

### 2）提交
示例：
```sh
cd "$REPO_DIR" && git add <files> && git commit -m "feat: xxx"
```

原则：
- 提交粒度尽量小
- 提交信息明确说明本次目的
- 避免把无关文件一起提交

### 3）推送
```sh
cd "$REPO_DIR" && git push
```

如果用户明确要直推当前分支并该仓库工作流已接受，直接推送即可；否则按当前仓库实际分支策略处理。

### 4）等待 GitHub Actions 全绿
**服务器部署前置条件：默认先等 GitHub Actions 全绿，再上服务器。**

至少关注：
- `Smoke Check`
- `Publish Docker Image`

检查脚本：
```sh
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/check_github_actions_green.sh
```

判定规则：
- 两个工作流最近一次运行都应为 `completed + success`
- 若任一工作流未绿，默认不进入服务器拉库部署阶段
- 先排查 CI，再决定是否重推或修复

## Phase C：服务器拉库与部署

### 1）登录验证
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 'hostname && whoami && uptime'
```

### 2）服务器仓库状态检查
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
cd /root/opencode2api-enhanced && git status --short --branch && git remote -v
'
```

### 3）拉取最新代码
**注意：为避免旧进程占用端口或继续提供旧版本服务，服务器在重新拉库、重新测试、重新启动前，默认先停旧进程。**

先停旧进程：
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
pkill -f "/root/opencode2api-enhanced/index.js" || true
pkill -f "node index.js" || true
pkill -f "opencode serve --hostname 127.0.0.1 --port 10001" || true
'
```

再拉取最新代码：
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
git config --global --add safe.directory /root/opencode2api-enhanced
chown -R root:root /root/opencode2api-enhanced
cd /root/opencode2api-enhanced && git pull --ff-only
'
```

若服务器还没仓库：
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
git clone https://github.com/joeshu/opencode2api-enhanced.git /root/opencode2api-enhanced
'
```

### 4）安装/更新依赖
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
cd /root/opencode2api-enhanced
npm install
npm install -g opencode-ai
'
```

## Phase D：服务器测试与运行验证

### 1）服务器侧最小测试
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
cd /root/opencode2api-enhanced && npm run verify:smoke
'
```

若 smoke 已通过，可视情况决定是否继续更慢的检查。

### 2）分离模式启动/重启
先停旧进程：
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
pkill -f "/root/opencode2api-enhanced/index.js" || true
pkill -f "node index.js" || true
pkill -f "opencode serve --hostname 127.0.0.1 --port 10001" || true
'
```

**重要：停旧进程后必须确认 `10000` 端口已空，再启动新代理。否则很容易出现“磁盘代码已更新，但对外仍是旧进程”的假部署。**

检查方式：
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
ss -lntp | grep ":10000 " || true
'
```

若仍有旧 PID 占用 `10000`，先明确杀掉该 PID，再继续启动新代理。

再启动后端 + 代理：
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
cd /root/opencode2api-enhanced
rm -f /root/opencode-serve.log /root/opencode2api-enhanced/opencode2api.log
nohup /usr/local/bin/opencode serve --hostname 127.0.0.1 --port 10001 >/root/opencode-serve.log 2>&1 </dev/null &
nohup env API_KEY="$API_KEY" OPENCODE_PROXY_MANAGE_BACKEND=false OPENCODE_SERVER_URL="http://127.0.0.1:10001" OPENCODE_PROFILE=stable /usr/bin/node /root/opencode2api-enhanced/index.js >/root/opencode2api-enhanced/opencode2api.log 2>&1 </dev/null &
'
```

### 3）健康检查
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
ss -lntp | grep -E "10000|10001" || true
echo ---
curl -sS -m 10 http://127.0.0.1:10000/health/live
echo
echo ---
curl -sS -m 10 -i http://127.0.0.1:10000/health/ready
'
```

### 4）接口冒烟
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
curl -sS -m 15 http://127.0.0.1:10000/v1/models \
  -H "Authorization: Bearer '$API_KEY'"
'
```

## Phase E：日志、排障、优化

### 查看进程
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 'ps -ef | grep -v grep | grep -E "node|opencode" || true'
```

### 查看端口
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 'ss -lntp | grep -E "10000|10001" || true'
```

### 查看日志
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
echo ---serve-log---
sed -n "1,120p" /root/opencode-serve.log 2>/dev/null || echo no_serve_log
echo ---proxy-log---
sed -n "1,160p" /root/opencode2api-enhanced/opencode2api.log 2>/dev/null || echo no_proxy_log
'
```

### 常见判断
#### 情况 1：`/health/live` 正常，`/health/ready` 失败
优先检查：
- `10001` 是否监听
- `opencode serve` 是否已启动
- 代理是否仍错误地试图走自动管理模式

#### 情况 2：项目错误要求 `OPENCODE_SERVER_PASSWORD`
处理原则：
- 先确认用户是否明确说“Node 版不需要 `OPENCODE_SERVER_PASSWORD`”
- 若是，则直接切到**分离模式**
- 不再沿用需要 `--password` 的旧判断

#### 情况 3：`opencode serve` 前台能启动，代理却判后端失败
处理原则：
- 优先判定为“自动管理逻辑不兼容”
- 直接手动后台启动 `opencode serve`
- 代理显式设置 `OPENCODE_PROXY_MANAGE_BACKEND=false`

#### 情况 4：`v1/models` 返回 Unauthorized
说明代理鉴权开启，调用时必须带：
```sh
-H "Authorization: Bearer $API_KEY"
```

## 默认执行策略
当用户说：
- “优化这个项目”
- “改完推 GitHub”
- “服务器拉最新代码并验证”
- “看日志排查一下”
- “实现这个功能并上线”

默认按下面顺序执行：
1. 进入本地仓库
2. 看状态
3. 修改代码
4. 跑本地 smoke
5. git add / commit / push
6. 检查 GitHub Actions 是否全绿（至少 Smoke Check + Publish Docker Image）
7. **只有全绿后**再 SSH 登录服务器
8. 先停旧进程
9. git pull --ff-only
10. npm install（如需要）
11. 服务器 smoke / 健康检查
12. 重启分离模式服务
13. 看日志 / 返回结果

## 提交信息规范
默认优先使用简洁的 Conventional Commits 风格：
- `feat: ...` 新功能
- `fix: ...` 修复问题
- `refactor: ...` 重构，不改外部行为
- `perf: ...` 性能优化
- `docs: ...` 文档更新
- `test: ...` 测试相关
- `chore: ...` 杂项维护

建议格式：
```sh
git commit -m "feat: add xxx"
```

选择规则：
- 实现功能：`feat`
- 修 bug：`fix`
- 只重构结构：`refactor`
- 提升性能：`perf`
- 只改脚本/流程/依赖：`chore`
- 一次提交只表达一个主目标

## 自动提交建议规则
当用户没有明确 commit message 时，按改动类型自动建议：
- 新增 API / 能力 / 配置支持：`feat: ...`
- 修复 ready / health / 路由 / 鉴权 / 兼容性：`fix: ...`
- 拆文件、整理结构、抽辅助函数：`refactor: ...`
- 减少延迟、减少重复调用、优化缓存/并发：`perf: ...`
- 更新脚本、部署流程、技能文档：`chore: ...`

建议生成规则：
1. 先看本次改动的主目标
2. 再看是否影响外部行为
3. 用最短短语概括结果，而不是描述过程

示例：
- `fix: run proxy in split backend mode`
- `feat: add responses stream event normalization`
- `refactor: extract backend health helpers`
- `perf: reduce duplicate active model updates`
- `chore: add remote deploy verify script`

## 上线前检查清单
执行上线前，优先按顺序确认：
1. 本地仓库状态清楚，未混入无关改动
2. 本地 `npm run verify:smoke` 已通过
3. 目标提交已 push 到 GitHub
4. 服务器 `git pull --ff-only` 已成功
5. 服务器 `npm install` 已完成（如有依赖变更）
6. 服务器 `npm run verify:smoke` 已通过
7. `10000` / `10001` 端口正常监听
8. `/health/live` 正常
9. `/health/ready` 正常
10. `v1/models` 冒烟通过或至少确认鉴权行为符合预期
11. 查看日志无明显致命错误

当部分检查已通过、少数步骤长时间运行或受外部条件限制时，应主动汇报：
- 已通过项
- 当前阻塞项
- 是否建议继续等待或先进入下一步

## 改动类型 → 验证策略矩阵
| 改动类型 | 最低验证要求 | 推荐附加验证 |
|---|---|---|
| 文档 / 注释 / 非运行逻辑说明 | `git diff` 自查 | 无 |
| 部署脚本 / 技能脚本 | 脚本静态检查 + 目标命令 dry-run 思维校验 | 运行对应脚本入口 |
| 健康检查 / ready / live 路由 | 本地 `verify:smoke` | 服务器 `/health/live` + `/health/ready` |
| 鉴权 / API_KEY / 请求头 | 本地 `verify:smoke` | 服务器 `v1/models` 未授权/已授权各测一次 |
| models 路由 / 模型解析 | 本地 `verify:smoke` | 服务器 `v1/models` |
| chat / responses 主链路 | 本地 `verify:smoke` | 服务器 `smoke_api_remote.sh` |
| 流式输出 / SSE | 本地最小相关验证 | 服务器真实流式请求冒烟 |
| 后端拉起 / 分离模式 / 端口管理 | 本地静态检查 | 服务器 `10000/10001` + ready |
| 日志 / 清理 / session 生命周期 | 本地 `verify:smoke` | 服务器日志观察 |
| 重构但声称不改行为 | 本地 `verify:smoke` | 服务器 `v1/models` 或 chat 冒烟 |

原则：
- 改动越靠近主链路，越要补服务器真实冒烟
- 若改动触及 chat/responses、ready、鉴权、后端启动，默认不要只停留在本地验证

## 脚本入口
### 0）总入口脚本
```sh
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/opencode_ops.sh snapshot
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/opencode_ops.sh prepush
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/opencode_ops.sh deploy
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/opencode_ops.sh smoke
TARGET=HEAD~1 sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/opencode_ops.sh rollback
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/opencode_ops.sh report
```
作用：统一入口调用常用子能力：本地快照 / 提交前检查 / 远程部署验证 / 远程业务冒烟 / 回滚 / 发布报告。

说明：
- `deploy` 子命令内部默认会先检查 GitHub Actions 是否全绿，再进入服务器部署阶段。

### 1）本地仓库快照
```sh
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/local_repo_snapshot.sh
```
作用：快速查看本地分支、远端、改动统计、最近提交。

### 1.5）提交前检查
```sh
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/pre_push_check.sh
```
作用：在 push 前查看 branch、remotes、diff、staged files、recent commits，并提醒运行 `verify:smoke`。

### 2）服务器一键部署 + 验证
```sh
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/deploy_verify_remote.sh
```
作用：自动执行：
- 先检查 GitHub Actions 是否全绿（至少 Smoke Check + Publish Docker Image）
- 先停旧进程，避免旧版本服务影响拉库、测试与重启验证
- 服务器拉库
- `npm install`
- `npm install -g opencode-ai`
- `npm run verify:smoke`
- 重启分离模式服务
- 健康检查
- `v1/models` 冒烟

使用前提：
- `ALI` 已设置
- `API_KEY` 已设置

### 2.5）远程业务冒烟
```sh
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/smoke_api_remote.sh
```
作用：执行真实远程 API 冒烟：
- `v1/models`
- `v1/chat/completions`

使用前提：
- `ALI` 已设置
- `API_KEY` 已设置

### 3）服务器回滚
```sh
TARGET=HEAD~1 sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/rollback_remote.sh
```
或：
```sh
TARGET=<commit> sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/rollback_remote.sh
```
作用：
- 服务器仓库硬回退到目标提交
- 重新安装依赖
- 重启分离模式服务
- 检查 `/health/ready`

使用前提：
- `ALI` 已设置
- `API_KEY` 已设置
- `TARGET` 已明确

### 4）发布报告模板
```sh
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/release_report_template.sh
```
作用：输出一份标准发布报告骨架，便于汇总本次改动、验证结果、风险和后续动作。

## 回滚流程
当上线后异常、ready 失败、关键功能回归或日志显示明显致命问题时，优先考虑回滚。

### 回滚前确认
先确认：
1. 当前问题是否可通过快速重启恢复
2. 是否已经定位到本次发布引入的问题
3. 目标回滚提交是否明确
4. 是否需要同时保留现场日志

### 推荐回滚顺序
1. 记录当前 HEAD 和最近提交
2. 保存关键日志结论
3. 服务器执行回滚到目标提交
4. `npm install`
5. 重启分离模式服务
6. 检查 `/health/ready`
7. 必要时做 `v1/models` 冒烟
8. 向用户汇报“已回滚到哪个提交 + 当前服务状态”

### 最小手动回滚命令
```sh
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
cd /root/opencode2api-enhanced
git --no-pager log --oneline -3
git reset --hard HEAD~1
npm install
pkill -f "/root/opencode2api-enhanced/index.js" || true
pkill -f "node index.js" || true
pkill -f "opencode serve --hostname 127.0.0.1 --port 10001" || true
nohup /usr/local/bin/opencode serve --hostname 127.0.0.1 --port 10001 >/root/opencode-serve.log 2>&1 </dev/null &
nohup env API_KEY="$API_KEY" OPENCODE_PROXY_MANAGE_BACKEND=false OPENCODE_SERVER_URL="http://127.0.0.1:10001" OPENCODE_PROFILE=stable /usr/bin/node /root/opencode2api-enhanced/index.js >/root/opencode2api-enhanced/opencode2api.log 2>&1 </dev/null &
'
```

## 发布报告模板
发布完成后，默认可按下面结构汇报：
- 本次改动
- Git 信息（分支 / commit / message）
- 本地验证结果
- 服务器动作（pull / install / smoke / restart）
- 健康检查结果
- 日志观察
- 风险与后续

如果用户要正式发布总结，优先使用模板脚本生成骨架再填入本次结果。

## 任务完成评分标准
用于自检当前一次任务是否达到“接近 100 分”的完成度。

### 评分维度
1. **改动质量（20）**
   - 改动聚焦、结构清晰、无无关改动
2. **本地验证（20）**
   - `verify:smoke` 完成，必要时补充其他验证
3. **Git 质量（10）**
   - 提交信息清晰，提交粒度合理，push 成功
4. **服务器部署（20）**
   - pull / install / restart 顺利，端口与进程正常
5. **线上验证（20）**
   - `/health/live`、`/health/ready`、必要接口冒烟通过
6. **汇报与回滚准备（10）**
   - 有清晰结论、阻塞说明、必要时可立即回滚

### 判定建议
- `90-100`：可认为达到高质量闭环
- `75-89`：主线可用，但还有补强空间
- `<75`：不建议当作高质量完成，需继续补验证或修正流程

### 默认目标
除非用户明确只要快速试验，否则默认目标是：
- **尽量做到 90+**
- 若要“冲 100 分”，至少同时满足：
  - 本地 smoke 通过
  - Git push 完成
  - 服务器 smoke 通过
  - ready 正常
  - 关键日志已看
  - 可给出简洁发布报告

## 输出要求
默认输出：
1. 当前阶段（本地开发 / 已推送 / 服务器验证 / 已上线）
2. 已执行的关键动作
3. 本地验证结果
4. 服务器测试/健康检查结果
5. 若失败，给出阻塞点和下一步

长任务时：
- 及时汇报“已完成项 + 当前阻塞项”
- 不要长时间静默
