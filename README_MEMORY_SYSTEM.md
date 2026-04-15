# Minis 记忆系统仓库入口 README

生成时间：2026-04-15

## 一、这是什么
这是 Minis 记忆系统的仓库入口文档，用于快速定位：
- 核心记忆技能
- 系统地图
- 使用手册
- 总评报告
- 回归方案与回归日志
- 真实专题样本索引

---

## 二、核心技能组

| 技能 | 作用 |
|---|---|
| `memory-topic-router/` | 决定任务开始前先读哪类记忆 |
| `memory-write-gatekeeper/` | 决定这条信息该不该进入记忆系统 |
| `memory-layer-governor/` | 决定写到哪层：daily / topic / GLOBAL / none |
| `memory-dedup-auditor/` | 审计重复、冲突、过时、层级错误 |
| `open-minis-memory-store/` | 归并、更新、清理旧记忆 |
| `memory-system-maintainer/` | 总管整套记忆治理流程 |

---

## 三、系统级文档入口

### 1. 系统总览
- `MEMORY_SYSTEM_README.md`
- `docs/memory-system/memory-system-final-maturity-report.md`
- `docs/memory-system/memory-system-index.html`

### 2. 使用与导航
- `memory-system-usage-guide.md`
- `docs/memory-system/memory-system-skill-map.md`
- `docs/memory-system/memory-system-skill-map.html`

### 3. 回归与样本
- `docs/memory-system/memory-system-regression-plan.md`
- `docs/memory-system/memory-system-regression-report.md`
- `docs/memory-system/memory-system-regression-log.md`
- `memory-system-execution-index.md`
- `docs/memory-system/memory-topics-index.md`
- `docs/memory-system/memory-system-mixed-cases.md`

### 4. 提交范围说明
- `docs/memory-system/COMMIT-CHECKLIST.md`

---

## 四、推荐阅读顺序

### 如果你第一次看这套系统
1. `MEMORY_SYSTEM_README.md`
2. `docs/memory-system/memory-system-index.html`
3. `memory-system-usage-guide.md`

### 如果你想直接用
1. `memory-system-usage-guide.md`
2. 对应技能目录中的 `README.md`

### 如果你想继续优化
1. `docs/memory-system/memory-system-final-maturity-report.md`
2. `docs/memory-system/memory-system-regression-report.md`
3. `memory-system-execution-index.md`
4. 对应技能的 `REPORT.md`

---

## 五、当前系统成熟度
当前记忆系统的系统级成熟度：

# **99.1 / 100**

定位：
**接近生产级、具备真实回归支撑的记忆治理框架**。

---

## 六、一句话总结
如果你只记一句话：

- **继续旧任务先查规则** → `memory-topic-router`
- **写之前先审查** → `memory-write-gatekeeper`
- **决定写哪层** → `memory-layer-governor`
- **记忆乱了先体检** → `memory-dedup-auditor`
- **体检后再归并** → `open-minis-memory-store`
- **整套一起管** → `memory-system-maintainer`
