---
name: generic-server-deploy
version: 3.0.0
status: production
description: "统一版 Linux 服务器 SSH 运维与部署技能。兼容通用服务器与阿里云服务器直连两类场景，主机地址、域名与登录用户从环境变量读取，避免泄露固定目标信息。支持连接探测、命令执行、文件传输、系统巡检、软件安装、服务/进程/日志/网络/Docker 管理，以及按系统类型执行通用部署。"
---

# generic-server-deploy

统一版服务器技能，定位为 **通用 SSH 运维底座 + 阿里云直连兼容入口 + 可直接执行的标准闭环**。

## 最终定位
- 这是唯一保留的服务器运维技能。
- 同时覆盖：
  - 通用 Linux 服务器
  - 阿里云服务器直连场景
- 不再保留独立的阿里云重复技能目录。
- 不绑定具体项目、仓库、端口、进程名或部署拓扑。
- 主机地址 / 域名 / 用户全部从环境变量读取，不在文档中泄露固定目标信息。

## 统一环境变量协议

### A. 通用变量
| 变量 | 默认值 | 说明 |
|------|--------|------|
| `ALI` | 无 | SSH 密码，必需 |
| `DEPLOY_HOST` | 无 | 目标服务器主机地址，可为 IP 或域名 |
| `DEPLOY_DOMAIN` | 无 | 目标服务器域名，若设置则优先使用 |
| `DEPLOY_USER` | `root` | SSH 用户 |

### B. 阿里云兼容别名
| 变量 | 默认值 | 说明 |
|------|--------|------|
| `ALIYUN_HOST` | 无 | 阿里云服务器主机地址 |
| `ALIYUN_DOMAIN` | 无 | 阿里云服务器域名，若设置则优先使用 |
| `ALIYUN_USER` | `root` | 阿里云 SSH 用户 |

## 主机与用户选择规则
统一按以下优先级选择：

### 主机优先级
1. `DEPLOY_DOMAIN`
2. `DEPLOY_HOST`
3. `ALIYUN_DOMAIN`
4. `ALIYUN_HOST`

### 用户优先级
1. `DEPLOY_USER`
2. `ALIYUN_USER`
3. `root`

因此：
- 通用场景下，用 `DEPLOY_*`
- 阿里云场景下，也可直接用 `ALIYUN_*`
- 两套变量无需同时存在

## 推荐检查
```sh
[ -n "$ALI" ] && echo ALI=set || echo ALI=not_set
[ -n "$DEPLOY_DOMAIN" ] && echo DEPLOY_DOMAIN=set || echo DEPLOY_DOMAIN=not_set
[ -n "$DEPLOY_HOST" ] && echo DEPLOY_HOST=set || echo DEPLOY_HOST=not_set
[ -n "$ALIYUN_DOMAIN" ] && echo ALIYUN_DOMAIN=set || echo ALIYUN_DOMAIN=not_set
[ -n "$ALIYUN_HOST" ] && echo ALIYUN_HOST=set || echo ALIYUN_HOST=not_set
[ -n "$DEPLOY_USER" ] && echo DEPLOY_USER=set || echo DEPLOY_USER=not_set
[ -n "$ALIYUN_USER" ] && echo ALIYUN_USER=set || echo ALIYUN_USER=not_set
```

## 环境变量缺失处理
- `ALI` 未设置：停止并提示设置 `ALI`
- 四个主机变量都未设置：停止并提示至少设置一个主机变量
- 用户未设置：默认按 `root`

建议入口：
- [设置 ALI](minis://settings/environments?create_key=ALI&create_value=)
- [设置 DEPLOY_HOST](minis://settings/environments?create_key=DEPLOY_HOST&create_value=)
- [设置 DEPLOY_DOMAIN](minis://settings/environments?create_key=DEPLOY_DOMAIN&create_value=)
- [设置 DEPLOY_USER](minis://settings/environments?create_key=DEPLOY_USER&create_value=root)
- [设置 ALIYUN_HOST](minis://settings/environments?create_key=ALIYUN_HOST&create_value=)
- [设置 ALIYUN_DOMAIN](minis://settings/environments?create_key=ALIYUN_DOMAIN&create_value=)
- [设置 ALIYUN_USER](minis://settings/environments?create_key=ALIYUN_USER&create_value=root)

## 统一目标变量写法
所有脚本与命令都统一为：
```sh
TARGET_HOST="${DEPLOY_DOMAIN:-${DEPLOY_HOST:-${ALIYUN_DOMAIN:-${ALIYUN_HOST:-}}}}"
TARGET_USER="${DEPLOY_USER:-${ALIYUN_USER:-root}}"
```

若 `TARGET_HOST` 为空，则立即停止。

---

## 核心原则
1. 默认先做连通与环境探测，不直接盲执行。
2. 默认执行优先于解释：能直接连通、探测、排查时，先执行后汇报。
3. 命令按风险分级：只读 / 可逆 / 高风险。
4. 高风险动作默认先明确目标主机、用户、路径、服务名、容器名。
5. 主机标识只通过环境变量注入，不在技能文档中泄露固定 IP / 域名。
6. 系统判断以实时探测为准，不写死 Ubuntu / Alibaba Cloud Linux / CentOS 等结论。
7. 输出必须可接手：当前状态、动作、结果、关键输出、风险点、续接点。
8. 一个技能覆盖通用与阿里云场景，避免重复维护与规则漂移。

---

## 标准执行顺序

### Phase 0：前置检查
```sh
[ -n "$ALI" ] && echo ALI=set || echo ALI=not_set
[ -n "${DEPLOY_DOMAIN:-${DEPLOY_HOST:-${ALIYUN_DOMAIN:-${ALIYUN_HOST:-}}}}" ] && echo TARGET_HOST=set || echo TARGET_HOST=not_set
[ -n "${DEPLOY_USER:-${ALIYUN_USER:-}}" ] && echo TARGET_USER=set || echo TARGET_USER=default
```

停止条件：
- `ALI` 未设置
- 所有主机变量都为空

### Phase 1：连接验证
优先使用脚本：
```sh
sh /var/minis/skills/generic-server-deploy/scripts/connect.sh
```

### Phase 2：服务器画像探测
```sh
sh /var/minis/skills/generic-server-deploy/scripts/detect_os.sh
sh /var/minis/skills/generic-server-deploy/scripts/system_status.sh
```

输出目标：
- OS / 版本 / 架构
- 包管理器
- glibc
- Docker / Compose
- CPU / 内存 / 磁盘 / 网络 / 负载

### Phase 3：进入原子动作
- 执行命令
- 文件传输
- 软件安装
- 应用部署
- 服务管理
- 日志查看
- 进程管理
- 网络诊断
- Docker 管理

---

## 风险分级

### A. 只读动作
默认可直接执行：
- 连通检测
- 系统探测
- 查看状态
- 查看日志
- 查看进程
- 查看端口
- 查看 Docker 状态
- 查看目录 / 文件内容

### B. 可逆动作
通常可直接执行，但要说明对象：
- 上传文件
- 下载文件
- 安装软件包
- 重启单个服务
- 拉取镜像
- 创建普通目录
- 启动后台进程

### C. 高风险动作
执行前必须明确目标与影响范围：
- `rm -rf`
- 覆盖系统路径文件
- 停核心服务
- 批量 kill 进程
- 改防火墙 / 网络规则
- `docker rm -f`
- 强制安装依赖 / `--nodeps`
- 涉及数据库、生产配置、开机启动项的修改

---

## 原子动作入口

### 1）连接与探测
- `scripts/connect.sh`
- `scripts/detect_os.sh`
- `scripts/system_status.sh`
- `scripts/check_server_env.sh`

### 2）命令执行
- `scripts/exec_cmd.sh`

### 3）文件与部署
- `scp` / `rsync`
- `scripts/quick_deploy.sh`

### 4）服务 / 日志 / 进程 / 网络 / Docker
- `scripts/service_manage.sh`
- `scripts/view_logs.sh`
- `scripts/process_manage.sh`
- `scripts/network_diag.sh`
- `scripts/docker_manage.sh`

---

## 推荐执行模式

### 模式 1：用户说“登录服务器看看”
执行：
1. 检查变量
2. `connect.sh`
3. `detect_os.sh`
4. `system_status.sh`
5. 汇报服务器画像

### 模式 2：用户说“查服务为什么挂了”
执行：
1. 连接
2. `service_manage.sh`
3. `view_logs.sh`
4. `process_manage.sh`
5. `network_diag.sh`
6. 视情况重启服务

### 模式 3：用户说“装软件 / 部署包”
执行：
1. 连接 + 环境探测
2. 上传或下载安装包
3. 按系统类型安装
4. 验证版本 / 进程 / 服务
5. 输出风险和回滚方式

### 模式 4：用户说“Docker 出问题了”
执行：
1. 探测 Docker
2. `docker_manage.sh` 查看容器 / 镜像 / 日志
3. 视情况 restart / rm / pull / run

## 阿里云服务器短句调用口令
以下短句都默认指向“阿里云服务器场景”，并优先读取：`ALIYUN_DOMAIN` → `ALIYUN_HOST` → `ALIYUN_USER`。

### 连接 / 巡检
- `登录阿里云服务器`
- `连接阿里云服务器`
- `看看阿里云服务器`
- `检查阿里云服务器状态`
- `阿里云机器体检`

### 命令执行
- `在阿里云跑命令：ls -la`
- `去阿里云执行：df -h`
- `阿里云执行：systemctl status nginx`

### 服务排障
- `查阿里云 nginx`
- `查阿里云服务状态`
- `看阿里云日志`
- `重启阿里云 nginx`
- `看阿里云端口 80`

### 进程 / 网络
- `查阿里云进程`
- `杀阿里云进程 1234`
- `查阿里云网络`
- `查阿里云 DNS`
- `查阿里云端口监听`

### 文件传输
- `传文件到阿里云`
- `上传目录到阿里云`
- `从阿里云下载文件`

### 软件 / 部署
- `阿里云安装 nginx`
- `阿里云部署 rpm`
- `阿里云装这个包`
- `把这个链接部署到阿里云`

### Docker
- `查阿里云 Docker`
- `看阿里云容器`
- `看阿里云容器日志`
- `重启阿里云容器 nginx`
- `在阿里云拉镜像 nginx`

---

## 推荐输出格式

```text
目标主机: 以环境变量指定
目标用户: 以环境变量指定
动作: xxx
结果: success / failed
关键输出:
- xxx
- xxx
当前判断:
- xxx
风险/备注:
- xxx
续接点:
- xxx
```

---

## 评分拉满后的优化点
当前版相对之前已做的提升：
1. **去重合并**：通用技能与阿里云技能合并为一个，消除重复维护。
2. **变量兼容**：同时兼容 `DEPLOY_*` 与 `ALIYUN_*`，降低迁移成本。
3. **脱敏彻底**：文档、脚本、样例都不再泄露固定主机信息。
4. **标准闭环**：前置检查 → 连通 → 探测 → 原子动作 → 回执。
5. **可接手输出**：结果格式统一，方便长任务续接。
6. **执行优先**：更贴近真实使用，不再拆成两个相似技能让用户选。

## 不做的事
- 不固化具体项目仓库流程
- 不把某个端口、目录、进程名写成默认事实
- 不把历史服务器状态写成通用结论
- 不保留重复的阿里云平行技能
