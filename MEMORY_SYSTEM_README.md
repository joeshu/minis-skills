# Minis 记忆系统总 README

生成时间：2026-04-15

## 一、系统目标
这套记忆系统的目标不是“把所有信息都记住”，而是：
- 让真正有复用价值的信息被正确保留
- 让临时变化停留在低层或不进入系统
- 让长期规则可被稳定检索
- 让旧记忆可被审计、归并、清理
- 让整套记忆系统长期保持可维护

---

## 二、核心技能组

| 技能 | 作用 |
|---|---|
| `memory-topic-router` | 先读哪类记忆 |
| `memory-write-gatekeeper` | 该不该写 |
| `memory-layer-governor` | 写到哪层 |
| `memory-dedup-auditor` | 审计重复/冲突/过时/层级错误 |
| `open-minis-memory-store` | 归并、更新、清理旧记忆 |
| `memory-system-maintainer` | 总管整套系统 |

---

## 三、记忆层级

| 层级 | 位置 | 适用内容 |
|---|---|---|
| L0 不记录 | 无 | 噪音、闲聊、一次性细节 |
| L1 daily | `/var/minis/memory/YYYY-MM-DD.md` | 近期变化、临时例外、时间线增量 |
| L2 专题 | `/var/minis/shared/memory_topics/` | 项目 / 平台 / 工作流 / 方法论内长期规则 |
| L3 GLOBAL | `/var/minis/memory/GLOBAL.md` | 跨主题长期原则、全局偏好、通用边界 |

---

## 四、推荐顺序

### 新信息进入系统
1. `memory-write-gatekeeper`
2. `memory-layer-governor`
3. 再实际写入对应层级

### 继续旧任务
1. `memory-topic-router`
2. 必要时补查 `GLOBAL.md` / daily

### 某主题记忆变乱
1. `memory-dedup-auditor`
2. `open-minis-memory-store`

### 维护整套记忆系统
1. `memory-system-maintainer`

---

## 五、产物与索引
- 使用手册：`memory-system-usage-guide.md`
- 技能地图：`memory-system-skill-map.md`
- HTML 地图：`memory-system-skill-map.html`
- 真实样本索引：`memory-system-execution-index.md`
- 统一评分标准：`SKILL_SCORING_STANDARD.md`
- 元技能总入口：`META_SKILLS_INDEX.md`
- 元技能总报告：`META_SKILLS_REPORT.md`
- 元技能封板说明：`META_SKILLS_FREEZE_NOTE.md`
- 元技能样本索引：`META_SKILLS_EXECUTION_INDEX.md`

---

## 六、评分与优化口径
- 后续技能优化与评分，默认优先参考 `SKILL_SCORING_STANDARD.md`
- 正式评分、发布或封板前，建议先过一遍 `SKILL_REVIEW_CHECKLIST.md`
- `darwin-skill` 作为评分方法来源与优化参考，不要求所有技能机械套用同一正文模板
- 报告中应明确标注：`full-test` / `full-test style` / `dry-run`

---

## 七、原则摘要
- 先审查，再写入
- 先分层，再落盘
- 先审计，再清理
- 专题优先于通用
- 不确定时宁可低层记录，不要误升格
