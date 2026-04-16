---
name: memory-system-maintainer
description: Maintain the overall health of the Minis memory system by orchestrating memory write review, layer decisions, topic-first retrieval, memory consolidation, and audit workflows. Use when the user wants to improve, clean, govern, or continuously maintain the whole memory system rather than handle just one memory action.
compatibility: memory-write-gatekeeper, memory-layer-governor, memory-topic-router, open-minis-memory-store, memory-dedup-auditor, memory_get, memory_write, file_read
---

# memory-system-maintainer

一个用于**维护整套记忆系统健康状态**的总管型技能。
目标：把 Minis 里的记忆相关能力串成统一治理闭环，覆盖：
- 写入前审查
- 写入层级判断
- 读取顺序路由
- 旧记忆归并整理
- 记忆质量审计

## 触发词
- 维护整个记忆系统
- 整理一下 Minis 记忆体系
- 记忆系统现在有点乱
- 帮我做记忆治理
- memory system maintain / memory governance / memory maintenance

## 输入
- 当前问题范围：单条记忆 / 某主题 / 整个记忆系统
- 用户目标：写新记忆 / 查旧记忆 / 清理噪音 / 归并主题 / 审计全局
- 可选主题、项目、平台、工作流、方法论关键词

## 输出
默认返回：
1. 当前应触发的记忆治理步骤
2. 优先使用的记忆子技能
3. 当前问题属于：写入、检索、归并、审计、还是系统维护
4. 下一步建议动作

## 核心原则
- **先判断问题类型，再调用对应子技能**
- **本技能负责编排，不替代各子技能本身的判断职责**
- **不要把所有记忆问题都用一个技能解决**
- **先审查，再写入；先审计，再清理**
- **专题优先于通用记忆；长期规则优先于临时变更的升格**

## 子技能分工
### 1. `memory-write-gatekeeper`
负责：
- 写入前审查
- 判断该不该写
- 拦截噪音、敏感信息、冲突覆盖风险

### 2. `memory-layer-governor`
负责：
- 决定该写 daily / topic / GLOBAL / nowhere

### 3. `memory-topic-router`
负责：
- 任务开始前决定先读哪层记忆
- 专题优先检索

### 4. `open-minis-memory-store`
负责：
- 合并、归并、更新、清理旧记忆
- 保留主记忆、删除重复旧项

### 5. `memory-dedup-auditor`
负责：
- 审计重复、冲突、过时、层级错误
- 出体检报告，不直接删

## 工作流

### 决策树
1. 如果用户要“记住这个”或“以后按这个做” → 先走 `memory-write-gatekeeper`
2. 若通过审查，再走 `memory-layer-governor`
3. 如果用户要“继续某项目/专题，先按过去规则来” → 先走 `memory-topic-router`
4. 如果用户说“这些记忆很乱，帮我整理” → 先走 `memory-dedup-auditor`
5. 如果用户确认要归并 / 删除旧记忆 → 再走 `open-minis-memory-store`
6. 如果用户要维护整个系统 → 按“审查 → 分层 → 路由 → 审计 → 归并”顺序编排

### 子技能选择规则
- **写入前问题**：优先 `memory-write-gatekeeper`
- **写到哪层问题**：优先 `memory-layer-governor`
- **先读哪层问题**：优先 `memory-topic-router`
- **系统里是否重复/冲突/过时**：优先 `memory-dedup-auditor`
- **确认要整理旧记忆**：优先 `open-minis-memory-store`

### 子技能优先级评分
当问题同时像多个子技能时，可按以下强信号打分：
- 明确说“记住 / 保存 / 写入” → gatekeeper +3
- 明确说“写到哪 / 该放哪层” → layer-governor +3
- 明确说“先查 / 先按过去约定” → topic-router +3
- 明确说“太乱 / 重复 / 冲突 / 审计” → dedup-auditor +3
- 明确说“整理 / 合并 / 删除旧记忆” → memory-store +3

优先选得分最高的子技能；如分数接近，则按治理顺序串联。

### Phase 1: 问题分型
将请求归类为：
- 写入问题
- 读取问题
- 归并问题
- 审计问题
- 全局维护问题

### Phase 2: 路由到子技能
- 写入问题 → `memory-write-gatekeeper` + `memory-layer-governor`
- 读取问题 → `memory-topic-router`
- 归并问题 → `open-minis-memory-store`
- 审计问题 → `memory-dedup-auditor`
- 全局维护问题 → 组合多个子技能

### Phase 3: 组合治理顺序
典型组合：
- **写入闭环**：gatekeeper -> layer-governor -> 实际写入
- **读取闭环**：topic-router -> 需要时补查 GLOBAL / daily
- **清理闭环**：dedup-auditor -> 用户确认 -> memory-store
- **系统维护闭环**：先定位问题类型，再分发给对应子技能；只有用户明确要求全局维护时才串多技能

### 组合治理模板
#### 新规则进入系统
1. 先审查值不值得写
2. 再判断写入层级
3. 最后再执行写入

#### 主题记忆变乱
1. 先审计重复 / 冲突 / 过时 / 层级错误
2. 再确认主记忆
3. 最后再归并与清理

#### 继续某项目执行
1. 先查专题记忆
2. 再补查 GLOBAL / daily（如有必要）
3. 过程中若出现新规则，再回到写入治理链路

#### 全局记忆系统维护
1. 先审计
2. 再定位问题类型
3. 再分发给 gatekeeper / layer-governor / memory-store

## 风险与边界
- 不要把“记忆写入”与“记忆归并”混成一步
- 不要先删旧记忆再审计
- 不要越过 gatekeeper 直接把任何信息写进长期层级
- 不要在已有专题路由时一上来就全盘搜 daily memory

## 输出风格
- 默认先一句判断：当前问题属于哪类记忆治理问题
- 再说建议先用哪个子技能
- 如涉及组合流程，再给最短编排顺序
- 不默认展开整套理论

## 响应模板
### 写入类模板
- `这属于记忆写入问题，建议先做写入审查，再决定层级。`

### 读取类模板
- `这属于记忆检索问题，建议先走专题优先路由。`

### 审计类模板
- `这属于记忆系统审计问题，建议先做体检，再决定是否清理。`

### 归并类模板
- `这属于记忆归并问题，建议先确认主记忆，再清理旧项。`

### 全局维护模板
- `这属于整套记忆系统维护问题，我会按 审查 → 分层 → 审计 → 归并 的顺序处理。`

## 成功标准
- 能正确识别问题类型
- 能正确调用对应子技能
- 不混淆审查 / 分层 / 检索 / 审计 / 归并职责
- 记忆系统不会越维护越乱
- 面对复合型问题时能给出合理组合顺序

## 资源文件
- `README.md`
- `test-prompts.json`
- `execution-samples.md`

## 测试要求
至少覆盖：
1. 单条写入治理
2. 读取路由治理
3. 审计后再归并
4. 全局维护闭环
5. 不混淆多个子技能职责
6. 复合型问题的路由优先级判断
