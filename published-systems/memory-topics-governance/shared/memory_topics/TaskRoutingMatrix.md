## Metadata
- scope: routing
- triggers: 任务分类, 专题读取选择, 复合任务, 最小读取原则
- negative_triggers: 已明确直达专题, 单句追问, 当前上下文已足够
- priority: high
- overrides: generic-topic-selection
- overridden_by: system-rules, user-explicit-instruction
- conflicts_with: over-reading
- typical_tasks: 技术问答路由, 搜索任务路由, 网页提取路由, 结果交付路由
- load_mode: conditional
- token_budget: medium
- summary: 将任务类型映射到默认读取文件、可选补充文件与最小读取路径。

# 任务路由矩阵

## 目的
- 将“任务类型”映射到“默认读取文件”和“可选补充文件”，减少泛化触发与上下文拥挤。
- 让专题读取从经验判断变成可复用的执行路由。

## 路由原则
- 先判断任务类型，再决定读取哪些专题文件。
- 默认只读取最少必要文件；能不读则不读。
- 风格文件不是所有任务都要重读；当当前会话风格已稳定时，不重复触发。

## 任务类型路由

### 1. 简单事实问答
- 默认读取：无
- 可选补充：`ResponseStyle-HighDensity.md`
- 不建议读取：长篇风格主文件、检索策略文件、网页读取文件
- 目标：直接答，不起大结构

### 2. 技术解释 / 报错分析
- 默认读取：`ResponseStyle-AGENTS.md`、`ResponseStyle-HighDensity.md`
- 可选补充：相关项目或专题文件
- 不建议读取：无关检索专题
- 目标：结论先行，补必要依据与关键 caveat

### 3. 执行类任务（改文件、跑命令、修问题）
- 默认读取：`ResponseStyle-HighDensity.md`
- 可选补充：相关项目专题、结果交付专题
- 不建议读取：纯风格长文反复读取
- 目标：直接给动作、命令、路径、改法

### 4. 搜索 / 联网检索
- 默认读取：`SearchSkills.md`
- 可选补充：`ResponseStyle-HighDensity.md`
- 若涉及搜索前缀：同时参考 `ResponseModePrefixes.md`
- 目标：先定搜索路线，再决定输出压缩方式

### 5. 网页内容提取 / 页面分析
- 默认读取：`WebPageReadingStrategy.md`
- 可选补充：`SearchSkills.md`、`ResponseStyle-HighDensity.md`
- 目标：优先低成本、可验证的正文提取路径，不机械截图

### 6. 结果交付 / 产物整理
- 默认读取：`ResultPackaging.md`
- 可选补充：`ResponseStyle-HighDensity.md`
- 目标：明确最终产物、中间产物、路径与交付形式

### 7. 记忆系统维护 / 专题建设
- 默认读取：`MemorySystemMaintenance.md`
- 可选补充：`RulePriorityAndConflictResolution.md`
- 目标：先看分层、入口、冲突、升降级原则，再执行修改

### 8. Skill 设计 / 生命周期 / 本地化
- 默认读取：`SkillDesignAndLocalization.md`
- 可选补充：相关项目或系统专题
- 目标：按 skill 约束而不是一般聊天风格来回答

### 9. 命名 / 选型 / 比较
- 默认读取：`ResponseModePrefixes.md`、`ResponseStyle-HighDensity.md`
- 可选补充：相关领域专题
- 目标：优先给结论；比较时只列关键差异

### 10. 闲聊 / 非技术轻问答
- 默认读取：无
- 可选补充：无
- 不建议读取：技术风格主文件、检索专题、网页专题
- 目标：自然、直接，不把体系过度套入轻场景

## 多类型复合任务
- 若一个任务同时包含“搜索 + 网页提取 + 结果交付”，按执行链路顺序读取：
  1. `SearchSkills.md`
  2. `WebPageReadingStrategy.md`
  3. `ResultPackaging.md`
  4. 按需补 `ResponseStyle-HighDensity.md`
- 若一个任务同时包含“改文件 + 汇报结果”，先执行任务路由，再补结果交付专题。

## 最小读取原则
- 能用当前上下文解决的问题，不追加读取。
- 已明确任务类型时，不先读 `TopicIndex.md`。
- 只有主题不明确时，才通过 `TopicIndex.md` 选专题。
- 不触发条件以 `/var/minis/shared/memory_topics/NegativeTriggers.md` 为主定义；本文件只定义“该读什么”，不承担“不该读什么”的主定义职责。
