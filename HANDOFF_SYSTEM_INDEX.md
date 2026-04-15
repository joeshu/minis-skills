# HANDOFF_SYSTEM_INDEX

生成时间：2026-04-16

用途：作为 Minis 项目交接 / 长任务连续性系统的总入口，帮助快速判断：
- 什么时候该压缩当前会话
- 什么时候该做跨会话 handoff
- 什么时候该把前中后连续性串起来
- 什么时候只整理摘要，什么时候才能删历史会话

---

## 一、这套系统解决什么问题

当任务变长、会话变长、需要跨会话继续、或需要把当前执行状态安全交给下次继续时，就应该优先看这套系统。

它解决的是：
- 当前会话太长，如何压缩
- 下次怎么无损接着干
- 删除历史会话前怎样避免信息丢失
- 任务开始前 / 执行中 / 结束后，如何形成连续工作流

---

## 二、核心技能地图

| 技能 / 文档 | 作用 | 适用时机 |
|---|---|---|
| `session-context-compactor/` | 压缩当前长会话，生成执行摘要、必要文件清单、shared handoff | 当前会话太长、要整理摘要、要删历史前先保留关键信息 |
| `open-minis-handoff-orchestrator/` | 把任务前 / 中 / 后串成连续闭环：先查记忆、执行中按需沉淀、结束后生成 handoff | 任务要跨阶段、跨会话、跨记忆层连续推进时 |
| `memory-topic-router/` | 在任务开始前决定先读哪类长期记忆 | 继续项目或专题任务前 |
| `open-minis-memory-store/` | 在 handoff 之外整理长期记忆 | 任务结束后发现长期记忆需要归并时 |

---

## 三、最常见使用路线

### Route A：会话太长，只想压缩
1. `session-context-compactor/`
2. 生成执行摘要
3. 列必要保留文件
4. 如需跨会话，写入 shared

### Route B：任务做完后要下次继续
1. `session-context-compactor/`
2. 生成 handoff 摘要
3. 输出下次继续入口

### Route C：完整前中后连续性
1. `open-minis-handoff-orchestrator/`
2. 开始前查记忆
3. 执行中按需判断新规则写哪层
4. 结束后调用 handoff 摘要

### Route D：删历史会话前保命
1. `session-context-compactor/`
2. 先摘要
3. 先列必要文件
4. 确认后才删除历史会话

---

## 四、怎么选

### 你在“当前会话已经很长”
用：`session-context-compactor/`

### 你在“整个任务要前中后连续”
用：`open-minis-handoff-orchestrator/`

### 你在“继续老项目，先按过去约定来”
先用：`memory-topic-router/`
再回到：`open-minis-handoff-orchestrator/`

### 你在“任务后发现长期记忆也该整理”
handoff 之后再用：`open-minis-memory-store/`

---

## 五、推荐执行顺序（极简版）

### 只压缩会话
compactor → shared/workspace handoff

### 完整连续性任务
handoff orchestrator → compactor →（必要时）memory store

### 删除历史前
compactor → 文件清单 → 确认删除

---

## 六、当前成熟度

| 对象 | 当前成熟度 |
|---|---:|
| `session-context-compactor` | 98.8 |
| `open-minis-handoff-orchestrator` | 98.6 |

当前判断：
**这套系统已接近生产级，适合继续通过真实案例与回归把边界磨到更稳。**

### 系统文档层
- `HANDOFF_SYSTEM_REPORT.md`
- `HANDOFF_SYSTEM_EXECUTION_INDEX.md`
- `HANDOFF_SYSTEM_FREEZE_NOTE.md`

---

## 七、一句话结论

- **压缩当前会话** → `session-context-compactor/`
- **串前中后闭环** → `open-minis-handoff-orchestrator/`
- **先查长期记忆** → `memory-topic-router/`
- **整理长期记忆** → `open-minis-memory-store/`
