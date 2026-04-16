# 记忆子系统职责矩阵

生成时间：2026-04-16

## 一、目的
把记忆系统内部各子技能的职责、前置条件、禁止越权范围、以及高风险动作护栏写清楚，避免多个高分技能在真实使用中互相吞职责。

---

## 二、职责矩阵

| 子技能 | 负责什么 | 不负责什么 | 前置条件 | 高风险动作护栏 |
|---|---|---|---|---|
| `memory-topic-router` | 先读哪层记忆；专题优先检索；不足时回退 | 不决定新信息写到哪层；不做归并整理 | 任务已进入“先查历史规则”阶段 | 不把读取路由误写成写入治理 |
| `memory-write-gatekeeper` | 审查该不该写；拦截噪音/敏感/冲突覆盖风险 | 不直接决定具体层级 | 用户准备写入记忆 | 遇敏感/高影响/冲突时先确认 |
| `memory-layer-governor` | 在已建议写入前提下决定 daily / topic / GLOBAL / nowhere | 不替代写入审查；不审计旧记忆 | 已基本确定“这条值得写” | 不确定时宁可低层，不误升格 |
| `memory-dedup-auditor` | 输出重复/冲突/过时/层级错误候选问题清单 | 不直接删除；不直接归并 | 用户要体检、审计、查乱象 | 先审计后处理；输出候选问题而非最终真相 |
| `open-minis-memory-store` | 归并主记忆；更新旧主记忆；在安全前提下清理旧项 | 不替代审计；不默认拥有删除权 | 已完成审计，且用户明确允许整理/清理 | 用户未明确允许或无法安全定位时不清理 |
| `memory-system-maintainer` | 编排器；识别问题类型；路由到对应子技能 | 不替代各子技能的实质判断 | 用户要求维护整套系统 | 只编排，不越权代替子技能结论 |
| `memory-system-git-sync` | 发布/同步/恢复层；镜像刷新；安全 push/restore | 不判断记忆内容本身是否合理 | 进入发布、恢复、同步阶段 | 有风险项时停在 check/sync，不强行 push |
| `open-minis-handoff-orchestrator` | 任务前/中/后连续性编排；交接入口记录链路 | 不替代长期记忆整理器 | 用户明确需要跨会话连续性 | 只有在执行中真的出现稳定规则时才触发沉淀判断 |
| `session-context-compactor` | 当前会话摘要压缩；必要文件识别；删除前护栏 | 不决定长期记忆写入层级 | 当前会话过长或需 handoff | 摘要质量不达标/必要文件未确认时不删历史 |

---

## 三、推荐顺序

### 场景 A：继续旧任务前先查规则
`memory-topic-router`

### 场景 B：准备写入一条新规则
`memory-write-gatekeeper` → `memory-layer-governor`

### 场景 C：某主题记忆太乱
`memory-dedup-auditor` → 用户确认 → `open-minis-memory-store`

### 场景 D：当前会话太长，要生成 handoff
`session-context-compactor`

### 场景 E：想把任务前中后都串起来
`open-minis-handoff-orchestrator`

### 场景 F：想整体治理整套系统
`memory-system-maintainer`

### 场景 G：要推送或恢复这套系统
`memory-system-git-sync`

---

## 四、常见越权反例
- `memory-topic-router` 不应替代 `memory-layer-governor`
- `memory-layer-governor` 不应替代 `memory-write-gatekeeper`
- `memory-dedup-auditor` 不应直接删除
- `open-minis-memory-store` 不应在未确认前清理旧项
- `memory-system-maintainer` 不应替代其他子技能做具体判断
- `session-context-compactor` 不应顺手决定长期记忆写入层级
- `memory-system-git-sync` 不应把“可同步”误写成“内容一定合理”

---

## 五、一句话总结
记忆系统内部的科学性，关键不是每个子技能都很强，而是：

**每个子技能都只做自己该做的判断，并把高风险动作建立在明确前置条件上。**
