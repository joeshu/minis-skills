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
- git 同步与恢复入口

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
| `memory-system-git-sync/` | 同步、发布、恢复这套系统 |

---

## 三、系统级文档入口

### 1. 系统总览
- `MEMORY_SYSTEM_README.md`
- `MEMORY_SYSTEM_REPORT.md`
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

### 4. 同步与恢复
- `SHARED_SYNC_POLICY.md`
- `MEMORY_SYSTEM_RESTORE_GUIDE.md`
- `MEMORY_SYSTEM_RESTORE_COMMANDS.md`
- `memory-system-git-sync/`

### 5. 提交范围说明
- `docs/memory-system/COMMIT-CHECKLIST.md`

### 6. 统一评分标准
- `SKILL_SCORING_STANDARD.md`
- 说明：后续技能优化与评分，默认优先参考这份统一标准；达尔文技能作为方法来源。

### 7. 评审前快检表
- `SKILL_REVIEW_CHECKLIST.md`
- 说明：正式评分、发布或封板前，先用这份清单做快速人工检查。

### 8. 元技能总入口
- `META_SKILLS_INDEX.md`
- 说明：快速判断 bootstrapper / lifecycle manager / output governor / scoring / review checklist 之间该怎么配合。

### 9. 元技能总报告
- `META_SKILLS_REPORT.md`
- 说明：汇总整套元技能体系的目标、分工、成熟度与维护策略。

---

## 四、推荐阅读顺序

### 如果你第一次看这套系统
1. `MEMORY_SYSTEM_README.md`
2. `MEMORY_SYSTEM_REPORT.md`
3. `docs/memory-system/memory-system-index.html`
4. `memory-system-usage-guide.md`

### 如果你想直接用
1. `memory-system-usage-guide.md`
2. 对应技能目录中的 `README.md`
3. 如需同步/恢复，再看 `memory-system-git-sync/` 与恢复指南

### 如果你想继续优化
1. `docs/memory-system/memory-system-final-maturity-report.md`
2. `docs/memory-system/memory-system-regression-report.md`
3. `memory-system-execution-index.md`
4. 对应技能的 `REPORT.md`

---

## 五、当前系统成熟度
当前记忆系统的系统级成熟度：

# **99.2 / 100**

定位：
**接近生产级、具备真实回归与 git 发布/恢复能力的记忆治理框架。**
