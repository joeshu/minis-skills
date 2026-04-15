---
name: open-minis-handoff-orchestrator
description: Orchestrate long-task continuity in Minis by combining topic memory retrieval before work, optional memory updates during work, and session handoff compaction after work. Use when the user wants a reliable start-to-finish continuity workflow across tasks, sessions, and memory layers.
compatibility: memory-topic-router, session-context-compactor, open-minis-memory-store, file_read, memory_get, memory_write
---

# open-minis-handoff-orchestrator

一个用于把 **任务前 / 任务中 / 任务后** 的上下文与记忆流程串起来的执行型技能。
目标：让任务在 Minis 中形成一个完整闭环——**开始前先查对记忆、执行中按需沉淀、结束时生成可继续执行的 handoff，并在必要时归并长期记忆**。

## 触发词
- 帮我把整个流程串起来
- 做一个可持续接力的 handoff 流程
- 这个任务要前后衔接好
- 先查记忆再做，结束后再整理交接
- open minis handoff / continuity workflow / task continuity

## 输入
- 当前任务或项目描述
- 是否跨会话继续
- 是否需要删除历史会话
- 是否需要把新规则沉淀进长期记忆

## 输出
默认返回：
1. 开始前采用的记忆来源
2. 执行中是否需要沉淀记忆
3. 结束后采用的 handoff 策略
4. 必要时建议更新哪一层记忆

## 核心闭环
### 阶段 A：任务开始前
- 优先用 `memory-topic-router` 决定先查哪类长期记忆
- 目标：避免一开始就读错记忆层级

### 阶段 B：任务执行中
- 如出现新的长期规则、稳定流程、重要偏好，再决定是否用 `open-minis-memory-store` 或 daily memory 处理
- 目标：避免边做边把临时变化乱写进长期记忆

### 阶段 C：任务结束后
- 用 `session-context-compactor` 生成执行摘要、必要文件清单和跨会话 handoff
- 若用户要求删除历史会话，必须先完成摘要与确认
- 目标：让下一次继续执行时不依赖当前长会话

## 工作流

### 决策树
1. 如果任务是继续某个项目/站点/流程：先走专题记忆检索。
2. 如果任务中出现新稳定规则：判断该写专题、`GLOBAL.md` 还是 daily memory。
3. 如果任务即将结束或上下文已很长：生成 handoff 摘要。
4. 如果用户还要求删历史会话：先摘要、先保留必要文件、再确认删除。

### 风险分级
#### L1：低风险
- 仅开始前查专题记忆
- 仅生成 handoff，不删历史会话

#### L2：中风险
- 执行中判断新规则写哪层记忆
- 结束后生成 handoff 并更新 latest 摘要

#### L3：高风险
- 整理后删除历史会话
- 将临时变化错误升格为长期规则
- 未确认就归并或删除记忆

### Phase 1: 开始前路由
- 优先调用 `memory-topic-router`
- 判断是否命中项目/平台/工作流/方法论专题
- 若未命中，再回退到 `GLOBAL.md` 与 daily memory

### Phase 2: 执行中记忆沉淀判断
根据新增信息判断写入层级：
- 主题内长期稳定规则 → 专题记忆
- 跨主题通用长期原则 → `GLOBAL.md`
- 近期变化 / 临时例外 / 路径调整 → daily memory
- 若同主题已有多条零散长期记忆 → 交给 `open-minis-memory-store` 归并

### 记忆沉淀判断规则
- 如果信息只在当前一轮执行有效：不要升格为长期记忆
- 如果信息跨多次任务都稳定复用：可考虑专题或 GLOBAL
- 如果信息只影响最近路径、最近调整、最新例外：优先写 daily memory

### Phase 3: 结束后 handoff
- 调用 `session-context-compactor`
- 输出执行摘要
- 列出必要保留文件
- 若跨会话继续：默认写到 `/var/minis/shared/`

### Phase 4: 历史会话删除（可选）
仅当用户明确要求时：
1. 确认摘要已生成
2. 确认必要文件已保留
3. 再执行删除确认

## 角色分工
- `memory-topic-router`：负责“先查哪类记忆”
- `open-minis-memory-store`：负责“如何整理长期记忆”
- `session-context-compactor`：负责“如何压缩当前会话并交接”
- `open-minis-handoff-orchestrator`：负责“把三者串成完整连续工作流”

## 风险与边界
- 不要在任务刚开始时就直接压缩当前会话
- 不要把执行中出现的一次性临时变化直接写成专题长期规则
- 不要在未生成摘要和保留文件前删除历史会话
- 不要在已有明确专题记忆时，直接跳去 daily memory 检索

## 响应模板
### 开始前模板
- `我会先检查这个任务是否命中某个专题记忆，再决定是否补查通用或近期记忆。`

### 执行中模板
- `这个新规则更像长期专题规则 / 通用原则 / 近期变化，我建议写到对应层级。`

### 结束后模板
- `我会把当前会话整理成 handoff 摘要，并列出必要保留文件，方便下次继续。`

### 删除前模板
- `我已整理好摘要并列出必要文件；如果你确认，我再删除历史会话。`

### 完整闭环模板
- `我会先查长期记忆，再在执行中按需沉淀新规则，最后生成 handoff 摘要，保证下次能继续。`

## 成功标准
- 开始前查对记忆层级
- 执行中不乱写长期记忆
- 结束后有可继续执行的 handoff
- 删除历史会话前有明确护栏
- 三个相关技能的职责不混淆

## 资源文件
- `README.md`：速查说明
- `test-prompts.json`：评估样例

## 测试要求
至少覆盖：
1. 继续某项目前先查专题记忆
2. 执行中新增规则时判断写哪层记忆
3. 任务结束后生成 handoff
4. 删除历史会话前先生成摘要并确认
5. 长期记忆整理与当前会话压缩不混用
