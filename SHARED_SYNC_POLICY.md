# shared → git 同步策略

生成时间：2026-04-15

## 一、目标
将 `/var/minis/shared/` 中**稳定、可恢复、值得版本管理**的系统资产同步到 git 仓库，同时避免把高频变动日志、运行态噪音或敏感数据无差别推入仓库。

---

## 二、同步原则

### 1. 应同步到 git 的内容
满足以下任一条件，建议同步：
- 属于系统级文档资产
- 属于真实样本库或模板库
- 重装后需要恢复
- 适合版本管理与回滚
- 内容相对稳定，不是纯运行态噪音

### 2. 不应直接同步到 git 的内容
满足以下任一条件，默认不同步：
- 高频追加日志、原始运行日志
- 临时草稿、缓存、一次性导出
- 敏感数据、凭据、私人信息
- 尚未整理的中间产物
- `/var/minis/memory/` 原始真实记忆数据

### 2.1 可同步的 memory 安全版本
若确有恢复/归档需要，可同步：
- `/var/minis/memory/` 的**脱敏镜像副本**
- 目标目录建议：`docs/memory-export-sanitized/`
- 脱敏后方可提交，不应直接提交原始记忆文件

### 3. 同步方式
- `shared` 保留为**运行态层**
- 仓库内保留为**稳定镜像层**
- 同步动作以“复制快照”方式进行，而不是直接把仓库工作目录指向 shared

---

## 三、当前记忆系统的同步映射

### A. 系统文档类
来源：`/var/minis/shared/`
镜像到：`/var/minis/skills/docs/memory-system/`

包括：
- `memory-system-final-maturity-report.md`
- `memory-system-index.html`
- `memory-system-mixed-cases.md`
- `memory-system-regression-log.md`
- `memory-system-regression-plan.md`
- `memory-system-regression-report.md`
- `memory-system-skill-map.html`
- `memory-system-skill-map.md`
- `memory-system-usage-guide.md`
- `memory-topics-index.md`

### B. 专题样本类
来源：`/var/minis/shared/memory_topics/`
镜像到：`/var/minis/skills/docs/memory-topics/`

包括：
- `README.md`
- `UnifiedVIP.md`
- `bilibili.md`
- `context-compaction.md`
- `github-sync.md`
- `github.md`
- `memory-maintenance.md`
- `notion.md`
- `skill-design.md`

---

## 四、同步优先级
1. 真实专题样本库
2. 系统级说明文档
3. 回归方案与阶段报告
4. 回归日志（仅在已经整理、可读、无敏感信息时）

---

## 五、执行检查清单
同步前：
- 检查是否包含敏感信息
- 检查是否属于稳定资产
- 检查目标仓库路径是否存在

同步后：
- 检查镜像文件列表
- 生成或更新提交清单
- 独立提交与推送

---

## 六、当前执行约定
对记忆系统相关 shared 内容：
- 允许同步到 git
- 仓库内镜像目录固定为：
  - `docs/memory-system/`
  - `docs/memory-topics/`
- 新增系统级文档或专题样本后，应按本策略增量同步
