# 专题文件元数据规范

## 目的
- 为 `/var/minis/shared/memory_topics/` 下的专题文件提供统一头部规范。
- 让专题文件不仅可读，还可被稳定调度、比较、裁决与维护。

## 适用范围
- 适用于记忆专题文件、规则文件、治理文件、路由文件、验收文件。
- 新建专题文件时优先采用；旧文件可渐进补齐，不要求一次性重写全部正文。

## 推荐头部格式
```md
## Metadata
- scope: response-style | retrieval | execution | memory | governance | routing | acceptance | failure-patterns
- triggers: 回答风格, 中文表达, 高信息密度
- negative_triggers: 闲聊, 单句确认, 已锁定风格
- priority: high | medium | low
- overrides: default-style
- overridden_by: user-explicit-instruction, prefixes, system-rules
- conflicts_with: verbose-writing
- typical_tasks: 技术解释, 报错分析, 中文文档输出
- load_mode: default | conditional | rare
- token_budget: low | medium | high
- summary: 一句话说明该文件在体系中的作用
```

## 字段说明

### 1. `scope`
- 定义文件所属域。
- 推荐值：
  - `response-style`：回答风格
  - `retrieval`：检索与搜索
  - `execution`：执行动作与工具路径
  - `memory`：记忆系统维护
  - `governance`：规则治理与冲突裁决
  - `routing`：任务路由
  - `acceptance`：输出验收
  - `failure-patterns`：失败模式与反例

### 2. `triggers`
- 写明哪些任务、主题、语义会触发该文件。
- 用逗号分隔关键词，优先写能真正改变执行结果的触发条件。

### 3. `negative_triggers`
- 写明哪些场景不该触发该文件。
- 例如：闲聊、单句确认、当前会话已锁定风格、已有直达专题。

### 4. `priority`
- 文件在同域中的优先级。
- `high`：高优先级，通常对执行结果影响显著。
- `medium`：中优先级，命中时建议读取。
- `low`：低优先级，仅在需要补充时读取。

### 5. `overrides`
- 该文件通常覆盖哪些默认规则。
- 例如任务专题可覆盖一般风格默认，具体专题可覆盖抽象专题。

### 6. `overridden_by`
- 哪些来源可以覆盖该文件。
- 通常至少包括：`system-rules`、`user-explicit-instruction`、`prefixes`。

### 7. `conflicts_with`
- 该文件最常与哪些文件或风格发生冲突。
- 用于快速判断是否需要走冲突裁决文件。

### 8. `typical_tasks`
- 列出典型任务，帮助快速路由。

### 9. `load_mode`
- `default`：该类任务默认读
- `conditional`：命中条件才读
- `rare`：少数情况下才读

### 10. `token_budget`
- 估计该文件的上下文预算占用。
- `low`：短文件，可频繁读取
- `medium`：中等长度，按需读取
- `high`：长文件，只在必要时读取

### 11. `summary`
- 一句话说明用途，便于索引摘要与快速判定。

## 最小落地要求
- 若不想一次性给所有旧文件补齐完整 metadata，至少先补：
  - `scope`
  - `triggers`
  - `negative_triggers`
  - `priority`
  - `summary`

## 使用原则
- metadata 是调度辅助层，不替代正文规则。
- 若 metadata 与正文冲突，以正文中的明确规则为准；后续应尽快修正 metadata 漂移。
- metadata 应尽量短、稳、可复用，不写临时项目状态。
