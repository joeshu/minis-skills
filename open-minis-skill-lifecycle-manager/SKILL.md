---
name: open-minis-skill-lifecycle-manager
description: Orchestrate the full lifecycle of a Minis skill from bootstrap, drafting, optimization, scoring, regression, publishing, syncing, maintenance, and freeze decisions. Use when the user wants to create, evolve, audit, or release a skill with a stable end-to-end workflow instead of ad hoc edits.
compatibility: file_read, file_write, file_edit, shell_execute, memory_get, memory_write
---

# open-minis-skill-lifecycle-manager

一个用于**统一编排技能全生命周期**的执行型技能。

目标：把技能从“先搭出来”推进到“可维护、可评分、可回归、可发布、可封板”的稳定状态，而不是停留在零散修改。

覆盖生命周期：
- 新建 / bootstrap
- 初版起草
- 结构优化
- 达尔文式评分
- 测试样例补齐
- execution samples / REPORT 补齐
- git 提交与推送
- 回归维护
- freeze / maintenance 模式切换

## 触发词
- 帮我做一个技能全生命周期方案
- 把这个 skill 做成完整闭环
- skill lifecycle manager
- 从创建一路做到发布
- 帮我把这个技能做成可维护版本

## 输入
- 技能名
- 当前阶段（新建 / 半成品 / 已发布 / 维护中）
- 目标（上线 / 冲高分 / 回归 / 封板 / 修边界）
- 是否需要 git 同步
- 是否需要回归与报告

## 输出
默认返回：
1. 当前技能所处阶段
2. 下一步应执行的生命周期动作
3. 缺失资产清单
4. 建议补齐顺序
5. 若适用，给出发布/维护建议
6. 当前更适合走的路线：冲分 / 发布 / 维护

## 生命周期阶段
### Stage 0：发现阶段
判断当前技能是：
- 不存在
- 只有 SKILL.md
- 有 SKILL/README 但无测试
- 已有测试但无报告
- 已可用但未封板
- 已封板进入维护态

### Stage 1：Bootstrap
适用：技能还不存在或结构很散。

最低骨架：
- `SKILL.md`
- `README.md`
- `test-prompts.json`

推荐骨架：
- `SKILL.md`
- `README.md`
- `test-prompts.json`
- `execution-samples.md`
- `REPORT.md`

### Stage 2：Draft / 初版起草
目标：
- 明确触发词
- 明确工作流
- 明确边界条件
- 明确响应模板

最低要求：
- 能说明何时用
- 能说明怎么做
- 能说明何时不该用

### Stage 3：Optimization / 结构优化
重点优化：
- frontmatter
- workflow
- checkpoint
- fallback
- 风险边界
- 与相邻技能分工
- 输出模板

### Stage 4：Evaluation / 评分
优先用统一评分框架评估：
- Frontmatter质量
- 工作流清晰度
- 边界覆盖
- 检查点设计
- 指令具体性
- 资源整合度
- 整体架构
- 实测表现

### Stage 5：Regression / 回归
至少确认：
- 核心触发词能命中
- 关键场景有测试样例
- 常见误用场景有边界约束
- baseline vs with-skill 对照成立

### Stage 6：Publish / 发布
发布动作可包括：
- 补齐 `REPORT.md`
- 补齐 `execution-samples.md`
- `git add/commit/push`
- 必要时同步 docs / shared 镜像

### Stage 7：Maintenance / 维护
维护态关注：
- 回归发现的新边界
- 与其他技能职责重叠
- 文档与实现漂移
- 是否需要 freeze note

### Stage 8：Freeze / 封板
适用：
- 技能已稳定
- 核心测试覆盖充分
- 后续以小修为主

封板后原则：
- 不再默认大改结构
- 以回归、样本、边界修正为主
- 如新增大能力，应评估是否拆新技能

## 决策树
1. 先识别当前阶段。
2. 先补最低骨架还是直接进入优化。
3. 判断是否缺测试/样本/报告。
4. 判断是继续冲分还是转维护态。
5. 判断是否需要 git 发布。
6. 如果用户目标是“冲 100 分”，优先补边界、测试样例、execution samples、REPORT，再做评分收口。

## 生命周期检查点
### Checkpoint A：骨架完整性
- 是否有 `SKILL.md`
- 是否有 `README.md`
- 是否有 `test-prompts.json`

### Checkpoint B：可优化性
- 是否已有清晰触发词
- 是否已有工作流
- 是否已有边界规则
- 是否能分辨相邻技能职责

### Checkpoint C：可发布性
- 是否有 `execution-samples.md`
- 是否有 `REPORT.md`
- 是否已有可解释评分
- 是否已有最小回归样例

### Checkpoint D：维护态判断
- 是否核心结构已稳定
- 是否后续以边界修正为主
- 是否已有 freeze 倾向

## 缺失资产检查表
按优先级检查：
1. `SKILL.md`
2. `README.md`
3. `test-prompts.json`
4. `execution-samples.md`
5. `REPORT.md`

若缺：
- 缺 1~3：先补基础骨架
- 缺 4~5：说明已进入中后期但发布资产不完整

## 输出风格
- 先判断阶段
- 再列缺失资产
- 再给下一步顺序
- 最后说明当前更适合“冲分 / 发布 / 维护”哪条路线

## 响应模板
### 新建阶段
- `这个技能还处于新建阶段，我建议先补齐最小骨架，再进入结构优化。`

### 冲高阶段
- `这个技能已具备基础可用性，下一步更适合做边界补强、测试扩展和评分收口。`

### 发布阶段
- `这个技能已接近发布态，建议补 REPORT / execution-samples 后再提交推送。`

### 维护阶段
- `这个技能已进入维护态，后续以回归、样本、边界修正为主，不建议默认大改。`

## 边界规则
- 不要在只有模糊想法时直接做重型发布流程
- 不要在骨架缺失时先做复杂评分
- 不要把维护态技能重新打回大改态，除非用户明确要求
- 不要忽略技能间职责边界
- 不要只写 SKILL.md 而缺 README / tests / REPORT 的后续资产
- 如果只是小修边界，不要强行重走完整生命周期
- 如果技能已高分稳定，优先判断是否进入 maintenance / freeze，而不是默认继续扩功能

## 生命周期路线模板
### Route A：从零新建
Bootstrap → Draft → Optimization → Evaluation → Publish

### Route B：半成品补齐
发现缺失资产 → 补骨架 → 优化 → 评分 → 发布

### Route C：高分冲刺
边界补强 → 测试扩展 → execution samples / REPORT → 评分收口 → 发布

### Route D：维护修边界
回归定位 → 小修 → 重新验证 → 需要时再发布

### Route E：封板/冻结
确认稳定 → 写明维护态原则 → 后续仅做小修与回归

## 成功标准
- 能准确判断技能所处生命周期阶段
- 能给出当前最该做的动作顺序
- 能把 bootstrap、优化、评分、回归、发布、维护串成闭环
- 用户不需要每次手工判断下一步

## 关联技能
- `open-minis-project-bootstrapper`
- `open-minis-output-governor`
- `session-context-compactor`
- `memory-topic-router`
- `memory-system-maintainer`
- `github-sync-helper`

## 测试要求
至少覆盖：
1. 从零新建技能
2. 半成品技能补骨架
3. 可用技能冲高分
4. 已高分技能转维护态
5. 已发布技能做回归修边界
