---
name: open-minis-project-bootstrapper
description: Bootstrap a new Minis project with a consistent working structure, including README, REPORT, test prompts, execution samples, handoff files, topic memory stub, and optional docs directories. Use when starting a new project, skill family, workflow system, or reusable toolkit and you want a stable skeleton instead of creating files ad hoc.
compatibility: file_write, shell_execute, file_read
---

# open-minis-project-bootstrapper

一个用于**为新项目快速建立标准骨架**的执行型技能。
目标：避免每次新开项目都从零散文件开始，而是一次性搭好：
- README
- REPORT
- test-prompts
- execution-samples
- handoff / session-handoffs
- topic memory stub
- docs 目录

## 触发词
- 给我初始化一个项目骨架
- 新建一个标准项目结构
- 帮我搭一个可持续维护的项目目录
- bootstrap project / scaffold project / init project structure

## 输入
- 项目名
- 项目类型（代码 / 技能 / 文档 / 系统 / 混合）
- 是否需要 docs
- 是否需要 topic memory stub
- 是否需要回归测试与执行样本模板
- 是否要求最小骨架

## 输出
默认返回：
1. 建议创建的目录结构
2. 已创建的文件清单
3. 该项目后续建议使用的配套技能
4. 下一步优先补充项

## 核心原则
- **先搭骨架，再往里填内容**
- **项目结构尽量统一，降低后续维护成本**
- **根据项目类型裁剪，而不是一刀切全塞进去**
- **让 README / REPORT / tests / handoff 能自然协作**
- **优先最小可维护结构，而不是最大想象结构**

## 项目类型
### A. 代码项目
适用：
- 代码开发
- 工具脚本
- 服务 / 代理 / CLI 项目

### B. 技能项目
适用：
- 新技能
- 技能家族
- 方法论 skill

### C. 文档 / 研究项目
适用：
- 资料整理
- 报告
- 长文研究

### D. 系统项目
适用：
- 多技能系统
- 方法体系
- 可持续治理框架

## 工作流

### 决策树
1. 先判断项目类型。
2. 判断用户是要最小骨架，还是完整骨架。
3. 决定是否需要 docs、test-prompts、execution-samples、handoff。
4. 决定是否需要 topic memory stub。
5. 生成最小可维护骨架。

### 骨架评分原则
给候选目录/文件按必要性打分：
- README：+3
- REPORT：+3
- test-prompts：+2
- execution-samples：+2
- docs：+1（文档/系统项目 +2）
- session-handoffs：+1（跨会话项目 +2）
- topic memory stub：+1（系统/长期项目 +2）
- 无明确用途的空目录：-3

结论：
- 高分项优先保留
- 低分且无明确用途的目录不生成

### Phase 1: 创建基础目录
默认候选：
- `README.md`
- `REPORT.md`
- `test-prompts.json`
- `execution-samples.md`
- `docs/`
- `session-handoffs/`

### Phase 2: 按项目类型裁剪
#### 代码项目
- `README.md`
- `REPORT.md`
- `test-prompts.json`
- `execution-samples.md`
- 可选 `docs/`

#### 技能项目
- `SKILL.md`
- `README.md`
- `REPORT.md`
- `test-prompts.json`
- `execution-samples.md`

#### 文档/研究项目
- `README.md`
- `REPORT.md`
- 可选 `docs/`
- 可选 `session-handoffs/`

#### 系统项目
- `README.md`
- `REPORT.md`
- `test-prompts.json`
- `execution-samples.md`
- `docs/`
- `session-handoffs/`
- topic memory stub

### Phase 3: 生成模板文件
- README：项目说明与入口
- REPORT：阶段报告入口
- test-prompts：测试样例占位
- execution-samples：真实执行样本模板
- handoff：交接摘要目录或模板
- topic memory stub：专题记忆初始文件

### Phase 4: 生成下一步建议
默认给出：
- 首先补 README 的核心目标
- 再补 test-prompts
- 再确定是否需要 docs 与 handoff

## 输出风格
- 先给项目骨架摘要
- 再列已创建文件
- 最后给下一步建议
- 不默认长篇解释每个文件的历史背景

## 响应模板
### 创建模板
- `我已为这个项目搭好基础骨架，后续可以直接往里填内容。`

### 裁剪模板
- `这是一个 <项目类型> 项目，我已按该类型保留最必要结构。`

### 最小骨架模板
- `我已按最小可维护原则生成骨架，没有加入无明确用途的空目录。`

### 下一步模板
- `下一步建议先补 README / test-prompts / REPORT 中最关键的部分。`

## 风险与边界
- 不要给所有项目都塞进完全相同的重型骨架
- 不要缺 README / REPORT 这类后续入口文件
- 不要一开始就生成大量空目录而没有明确用途
- 不要把 topic memory stub 与真实专题记忆混淆
- 不要把文档项目做成代码项目那样的重结构

## 成功标准
- 骨架足够统一
- 不同项目类型有合理裁剪
- README / REPORT / tests / handoff 能自然接上
- 新项目不再需要临时拼目录结构
- 最小骨架需求时不过度生成目录

## 资源文件
- `README.md`
- `test-prompts.json`
- `REPORT.md`
- `execution-samples.md`（可选）

## 测试要求
至少覆盖：
1. 代码项目骨架
2. 技能项目骨架
3. 文档/研究项目骨架
4. 系统项目骨架
5. 含 topic memory stub 的情况
6. 最小骨架需求
