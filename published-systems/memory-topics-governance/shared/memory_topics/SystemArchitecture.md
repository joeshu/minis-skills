## Metadata
- scope: governance
- triggers: 体系总览, 分层关系, 最小执行链, 架构说明
- negative_triggers: 简单问答, 单点专题读取, 已明确局部规则
- priority: medium
- overrides: none
- overridden_by: system-rules, user-explicit-instruction
- conflicts_with: none
- typical_tasks: 体系维护, 架构梳理, 新增专题前总览理解
- load_mode: conditional
- token_budget: medium
- summary: 说明回答风格与检索体系的分层、职责边界、调用顺序与最小执行链。

# 回答风格与检索体系总览

## 目标
- 用一份总览文件说明这套体系的层次结构、职责边界、调用顺序与最小执行链。
- 降低后续维护成本，避免每次都分散读取多个规则文件才知道整体结构。

## 体系压缩结构图

```text
回答风格与检索治理系统
│
├─ 1. 全局默认层
│   └─ GLOBAL.md
│      - 长期稳定默认偏好
│      - 没有更具体规则时生效
│
├─ 2. 规则导航层
│   └─ TopicIndex.md
│      - 体系级规则文件导航
│      - 告诉系统有哪些核心文件
│
├─ 3. 系统总览层
│   └─ SystemArchitecture.md
│      - 说明整套体系怎么分层
│      - 说明最小执行链与裁决关系
│
├─ 4. 专题规则层
│   ├─ ResponseStyle-AGENTS.md
│   ├─ ResponseStyle-HighDensity.md
│   ├─ ResponseModePrefixes.md
│   ├─ RulePriorityAndConflictResolution.md
│   ├─ TaskRoutingMatrix.md
│   ├─ NegativeTriggers.md
│   ├─ AnswerScopeBudget.md
│   └─ TopicMetadataSchema.md
│
├─ 5. 质量控制层
│   ├─ OutputAcceptanceChecklist.md
│   ├─ FailurePatterns.md
│   └─ LightweightScoringFramework.md
│
├─ 6. 科学化维护层
│   ├─ RegressionCases.md
│   ├─ RuleChangeAdmission.md
│   ├─ DeprecationAndMergePolicy.md
│   └─ PrimaryVsDerivedDefinitions.md
│
└─ 7. 汇总说明层
    └─ global_memory_style_and_retrieval_rules.md
       - 汇总说明
       - 不是主定义层
```

## 体系分层

### 1. 全局基线层
- 文件：`GLOBAL.md`
- 职责：提供长期稳定的默认偏好。
- 特点：范围最广，但不是最具体。

### 2. 风格层
- 文件：`ResponseStyle-AGENTS.md`、`ResponseStyle-HighDensity.md`
- 职责：规定中文回答的语气、句法、结构、篇幅与信息密度。
- 特点：主要回答“怎么说”。

### 3. 前缀层
- 文件：`ResponseModePrefixes.md`
- 职责：让用户通过短前缀快速切换输出模式。
- 特点：优先于一般默认风格。

### 4. 总纲层
- 文件：`global_memory_style_and_retrieval_rules.md`
- 职责：汇总风格、前缀、专题触发、检索偏好。
- 特点：适合总入口理解，不适合替代全部专题细则。

### 5. 治理层
- 文件：`RulePriorityAndConflictResolution.md`
- 职责：处理规则冲突、裁决优先级。
- 特点：回答“谁说了算”。

### 6. 路由层
- 文件：`TaskRoutingMatrix.md`
- 职责：把任务类型映射到默认读取路径。
- 特点：回答“先读什么、后读什么”。

### 7. 负触发层
- 文件：`NegativeTriggers.md`
- 职责：规定哪些场景不要触发额外读取。
- 特点：控制体系不过度工作。

### 8. 验收层
- 文件：`OutputAcceptanceChecklist.md`
- 职责：检查输出是否达标。
- 特点：将偏好转成可验收标准。

### 9. 反例层
- 文件：`FailurePatterns.md`
- 职责：记录常见失配模式与纠偏方式。
- 特点：帮助发现体系失效点。

### 10. 元数据层
- 文件：`TopicMetadataSchema.md`
- 职责：统一专题文件头部 metadata 规范。
- 特点：提升可调度性与可维护性。

### 11. 预算层
- 文件：`AnswerScopeBudget.md`
- 职责：控制回答、读取、搜索、分析的扩展范围。
- 特点：回答“什么时候该停”。

## 最小执行链

### 简单技术问答
1. 先看用户当前要求与前缀
2. 必要时参考 `ResponseStyle-HighDensity.md`
3. 直接回答
4. 用 `OutputAcceptanceChecklist.md` 快速自检

### 技术解释 / 报错分析
1. 先看用户要求与前缀
2. 读 `TaskRoutingMatrix.md` 判断是否需要更多专题
3. 读 `ResponseStyle-AGENTS.md` + `ResponseStyle-HighDensity.md`
4. 回答后按验收清单自检

### 复杂复合任务
1. 先用 `TaskRoutingMatrix.md` 判断主路径
2. 若出现冲突，读 `RulePriorityAndConflictResolution.md`
3. 用 `NegativeTriggers.md` 减少无意义读取
4. 用 `AnswerScopeBudget.md` 控制扩展范围
5. 最后按 `OutputAcceptanceChecklist.md` 验收

## 裁决关系
- 系统规则 > 用户当前显式要求 > 前缀协议 > 当前任务命中的专题文件 > `GLOBAL.md` > 其他默认规则
- 具体专题 > 抽象专题
- 任务专题 > 一般风格专题
- 新近明确更新的专题 > 旧专题

## 主定义与派生职责
- `ResponseStyle-HighDensity.md`：高信息密度、结论先行、低冗余的主定义。
- `ResponseStyle-AGENTS.md`：中文表达、语气、句法与技术完整性的主定义。
- `AnswerScopeBudget.md`：篇幅、停止条件、读取/搜索/分析预算的主定义。
- `NegativeTriggers.md`：不触发读取与降噪场景的主定义。
- `RulePriorityAndConflictResolution.md`：冲突裁决顺序的主定义。
- `TaskRoutingMatrix.md`：任务类型到读取路径的主定义。
- `OutputAcceptanceChecklist.md`：输出验收入口；负责检查，不承担上述约束的主定义职责。
- `FailurePatterns.md`：反例与纠偏入口；负责归类，不承担上述约束的主定义职责。

## 设计原则
- 默认追求最短可用闭环。
- 不为形式读取全部专题文件。
- 不为完整感扩写。
- 输出风格服从任务目标。
- 简洁不能损害正确性与可执行性。
- 在 OpenMinis 中，可执行任务默认优先执行闭环，而非解释闭环。
- 工具调用与文件落点应服从最短可用闭环原则：能直接执行则先执行，能稳定落文件则不只停留在聊天输出。

## 维护闭环
- 问题出现 → `FailurePatterns.md` 归类
- 归类后 → 写入或补充 `RegressionCases.md`
- 若样本反复出现，先判断是否需要规则升格
- 需要升格时 → 进入 `RuleChangeAdmission.md` 做准入判断
- 准入通过后 → 优先修改对应主定义文件
- 修改后 → 用 `OutputAcceptanceChecklist.md` 验收
- 验收通过后 → 可用 `LightweightScoringFramework.md` 做版本比较
- 若后续长期无样本支撑、或已被更高层文件吸收 → 进入 `DeprecationAndMergePolicy.md`

## 维护建议
- 新增专题时，优先补 metadata 头。
- 修改专题时，检查是否影响路由、冲突裁决、预算与验收。
- 若出现新的失配类型，优先写入 `FailurePatterns.md`，而不是立刻扩大全局规则。
