# TopicIndex

## 说明
- 本文件是 `/var/minis/shared/memory_topics/` 下**体系级规则与治理文件**的导航入口。
- 它不是目录全量文件清单；目录说明与样本专题入口见 `README.md`。

## 总览入口
- `SystemArchitecture.md`：体系分层、职责边界、调用顺序、最小执行链与裁决关系总览。

## 回答风格与检索
- `global_memory_style_and_retrieval_rules.md`：中文回答风格、前缀协议、专题记忆触发读取、检索与网页读取总纲。
- `ResponseStyle-AGENTS.md`：中文回答主风格规范，覆盖语气、句法、词汇、结构、自检清单。
- `ResponseStyle-HighDensity.md`：高信息密度输出硬约束。
- `ResponseModePrefixes.md`：回答模式前缀协议与组合示例。

## 体系治理与执行
- `RulePriorityAndConflictResolution.md`：规则优先级、冲突裁决顺序、常见冲突场景处理。
- `TaskRoutingMatrix.md`：任务类型到专题读取路径的路由矩阵。
- `NegativeTriggers.md`：不应触发专题读取的场景与降噪规则。
- `OutputAcceptanceChecklist.md`：输出是否合格的验收清单。
- `FailurePatterns.md`：常见失败模式、反例与纠偏口径。
- `AnswerScopeBudget.md`：回答、读取、搜索、分析分支的预算与停止条件。
- `TopicMetadataSchema.md`：专题文件统一元数据头规范与字段解释。
- `RegressionCases.md`：真实样本回归与 baseline / governed 对照入口。
- `RuleChangeAdmission.md`：规则新增、升格与拒绝进入系统的准入口径。
- `DeprecationAndMergePolicy.md`：文件废弃、合并、下沉与删除策略。
- `LightweightScoringFramework.md`：半量化轻量评分框架，用于版本对比与回归评估。
- `PrimaryVsDerivedDefinitions.md`：主定义与派生定义关系梳理，用于降低重复维护与规则漂移。
