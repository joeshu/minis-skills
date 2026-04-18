# 主定义与派生定义关系梳理

## 目的
- 识别这套体系中同一约束被多个文件重复描述的情况。
- 明确哪些文件应作为主定义，哪些文件只保留派生、引用、验收或反例职责。
- 降低规则漂移、重复维护与文件间耦合。

## 总体结论
- 当前体系已经具备分层，但仍存在若干约束在多个文件中平行描述。
- 最需要收口的不是内容正确性，而是“同一约束的主定义位置”。
- 建议采用：
  - **主定义文件**：负责定义规则本身
  - **派生文件**：负责触发、验收、反例、预算控制或失败纠偏

## 一、最应收口的重复约束

### 1. 篇幅 / 扩展 / 停止条件
#### 当前分布
- `ResponseStyle-HighDensity.md`
- `AnswerScopeBudget.md`
- `OutputAcceptanceChecklist.md`
- `FailurePatterns.md`

#### 问题
- 多个文件都在讲“不要扩写”“控制篇幅”“不要过度延伸”。
- 目前逻辑上可理解，但维护时容易改一处忘另一处。

#### 建议主定义
- **主定义：`AnswerScopeBudget.md`**

#### 建议派生职责
- `ResponseStyle-HighDensity.md`：只保留“高信息密度输出应服从预算层”这一句，不再展开重复预算细节。
- `OutputAcceptanceChecklist.md`：只检查是否违反预算层。
- `FailurePatterns.md`：只保留“预算失控型失败模式”作为反例。

#### 建议动作
- 后续若再改“篇幅 / 扩展 / 停止条件”，优先只改 `AnswerScopeBudget.md`。

---

### 2. 读取抑制 / 不要乱读专题
#### 当前分布
- `TaskRoutingMatrix.md`
- `NegativeTriggers.md`
- `AnswerScopeBudget.md`
- `FailurePatterns.md`

#### 问题
- 多个文件都在描述“不要多读”“不要重复读”“简单任务不必读”。
- 当前差异主要在语气，不够像职责分离。

#### 建议主定义
- **主定义：`NegativeTriggers.md`**

#### 建议派生职责
- `TaskRoutingMatrix.md`：只定义“该读什么”，不再详细扩写“不该读什么”。
- `AnswerScopeBudget.md`：只保留“读取数量预算”，不再枚举细场景。
- `FailurePatterns.md`：只记录“过度读取导致上下文拥挤”的反例。

#### 建议动作
- “不该触发什么”统一归到 `NegativeTriggers.md`。
- “最多读多少”归到 `AnswerScopeBudget.md`。

---

### 3. 高信息密度 / 结论先行 / 少废话
#### 当前分布
- `ResponseStyle-HighDensity.md`
- `ResponseStyle-AGENTS.md`
- `OutputAcceptanceChecklist.md`
- `LightweightScoringFramework.md`

#### 问题
- 多处都在讲“首句给结论”“少铺垫”“低冗余”。
- 这是合理重复，但需要分清主规则与评估规则。

#### 建议主定义
- **主定义：`ResponseStyle-HighDensity.md`**

#### 建议派生职责
- `ResponseStyle-AGENTS.md`：负责更广的中文表达、语气、句法约束，不再承担“篇幅预算主定义”。
- `OutputAcceptanceChecklist.md`：检查是否遵守结论先行与边界。
- `LightweightScoringFramework.md`：给“结论前置 / 边界控制”打分。

#### 建议动作
- “高信息密度”只在 `ResponseStyle-HighDensity.md` 定义。
- 其他文件引用该定义，不重复解释。

---

### 4. 技术完整性不能因简洁受损
#### 当前分布
- `ResponseStyle-AGENTS.md`
- `ResponseStyle-HighDensity.md`
- `OutputAcceptanceChecklist.md`
- `FailurePatterns.md`

#### 问题
- 这是体系里很核心的护栏，但目前也有平行重复。

#### 建议主定义
- **主定义：`ResponseStyle-AGENTS.md`**

#### 建议派生职责
- `ResponseStyle-HighDensity.md`：只保留“高密度不能以牺牲技术完整性为代价”的引用性表述。
- `OutputAcceptanceChecklist.md`：检查命令、路径、参数、caveat 是否缺失。
- `FailurePatterns.md`：保留“看起来简洁，实际漏关键条件”的失败模式。

#### 建议动作
- 未来涉及“技术完整性”优先改 `ResponseStyle-AGENTS.md`。

---

### 5. 规则冲突谁裁决
#### 当前分布
- `RulePriorityAndConflictResolution.md`
- `SystemArchitecture.md`
- 部分其他文件的 metadata 头

#### 问题
- 当前还不严重，但已经出现“正文写一遍，总览再写一遍，metadata 再暗示一遍”的趋势。

#### 建议主定义
- **主定义：`RulePriorityAndConflictResolution.md`**

#### 建议派生职责
- `SystemArchitecture.md`：只保留摘要级裁决关系，不重复场景细则。
- metadata：只标注 `overridden_by` / `overrides`，不承担裁决正文。

#### 建议动作
- 一切冲突顺序修改，优先只改 `RulePriorityAndConflictResolution.md`。

---

## 二、当前较健康的分工
以下分工目前较清楚，不建议再收口过度：

- `TaskRoutingMatrix.md`：任务类型 → 读取路径
- `NegativeTriggers.md`：哪些场景不要触发
- `OutputAcceptanceChecklist.md`：输出是否合格
- `FailurePatterns.md`：失效方式与反例
- `LightweightScoringFramework.md`：半量化打分
- `RegressionCases.md`：真实样本回归

这些文件之间可以互相引用，但不应强行合并成一个大文件。

## 三、建议的主定义映射表

| 约束主题 | 主定义文件 | 派生文件 |
|---|---|---|
| 高信息密度 / 结论先行 | `ResponseStyle-HighDensity.md` | `OutputAcceptanceChecklist.md`, `LightweightScoringFramework.md` |
| 技术完整性 | `ResponseStyle-AGENTS.md` | `ResponseStyle-HighDensity.md`, `OutputAcceptanceChecklist.md`, `FailurePatterns.md` |
| 篇幅 / 停止条件 / 防扩写 | `AnswerScopeBudget.md` | `ResponseStyle-HighDensity.md`, `OutputAcceptanceChecklist.md`, `FailurePatterns.md` |
| 读取抑制 / 不乱触发 | `NegativeTriggers.md` | `TaskRoutingMatrix.md`, `AnswerScopeBudget.md`, `FailurePatterns.md` |
| 任务读取路径 | `TaskRoutingMatrix.md` | `SystemArchitecture.md` |
| 冲突裁决 | `RulePriorityAndConflictResolution.md` | `SystemArchitecture.md`, metadata |
| 验收标准 | `OutputAcceptanceChecklist.md` | `LightweightScoringFramework.md` |
| 失败归类 | `FailurePatterns.md` | `RegressionCases.md` |

## 四、最小收口建议
不建议大改结构，建议只做最小范围收口：

1. 在 `ResponseStyle-HighDensity.md` 增加一句：
   - 篇幅、停止条件、分支控制以 `AnswerScopeBudget.md` 为主定义。

2. 在 `TaskRoutingMatrix.md` 增加一句：
   - 不触发条件以 `NegativeTriggers.md` 为主定义。

3. 在 `OutputAcceptanceChecklist.md` 增加一句：
   - 验收围绕风格主定义、预算主定义与技术完整性主定义展开。

4. 在 `SystemArchitecture.md` 增加一节：
   - 主定义文件优先级与派生文件职责。

## 五、原则结论
- 规则系统下一阶段不应继续平均扩写所有文件。
- 应优先把同一约束收敛到一个主定义文件。
- 其他文件只做：触发、预算、验收、反例、评分。
- 这样系统才会从“多文件协同”继续进化成“低耦合可维护”。
