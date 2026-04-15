# META_SKILLS_INDEX

生成时间：2026-04-15

用途：作为 Minis 元技能体系的总入口，帮助快速判断：
- 什么时候该先搭骨架
- 什么时候该做生命周期治理
- 什么时候该治理输出形式
- 什么时候该评分
- 什么时候该先快检再正式评分

---

## 一、这套元技能解决什么问题

当你不是在做某个具体业务任务，而是在：
- 创建一个新技能/新项目
- 优化一个已有技能
- 判断要不要发布/封板
- 决定结果该怎么展示和落盘
- 给技能做统一评分与评审

就应该优先看这组元技能。

---

## 二、核心元技能地图

| 技能 / 文档 | 作用 | 适用时机 |
|---|---|---|
| `open-minis-project-bootstrapper/` | 为新项目/新技能/新系统搭标准骨架 | 刚开始、结构还没搭好 |
| `open-minis-skill-lifecycle-manager/` | 编排技能从新建到优化、评分、发布、维护、freeze 的全流程 | 技能已经开始推进，需要判断下一步 |
| `open-minis-output-governor/` | 决定结果该聊天输出、落 Markdown、做 HTML、存 shared/workspace/attachments | 任务结果需要治理输出形式时 |
| `SKILL_SCORING_STANDARD.md` | 统一 8 维评分标准 | 正式评分、横向比较、复评时 |
| `SKILL_REVIEW_CHECKLIST.md` | 评分/发布/封板前的快速人工检查表 | 正式评分前先排明显缺口 |
| `darwin-skill/` | 优化方法来源、评分框架来源 | 需要参考优化方法与打分框架时 |

---

## 三、最常见使用路线

### Route A：从零开始做一个新技能/新系统
1. `open-minis-project-bootstrapper/`
2. 产出最小骨架
3. `open-minis-skill-lifecycle-manager/`
4. 进入优化 → 评分 → 发布

### Route B：已有技能，但结构还不稳
1. `SKILL_REVIEW_CHECKLIST.md`
2. 看缺什么
3. `open-minis-skill-lifecycle-manager/`
4. 补骨架 / 补边界 / 补测试
5. `SKILL_SCORING_STANDARD.md` 正式评分

### Route C：结果很多，不知道怎么展示
1. `open-minis-output-governor/`
2. 决定聊天 / Markdown / HTML / shared / workspace / attachments
3. 如后续要长期维护，再回到 lifecycle manager

### Route D：技能已接近成熟，准备发布/封板
1. `SKILL_REVIEW_CHECKLIST.md`
2. `SKILL_SCORING_STANDARD.md`
3. `open-minis-skill-lifecycle-manager/` 判断发布 / maintenance / freeze

### Route E：想参考高分优化方法
1. `darwin-skill/`
2. 提炼优化思路
3. 用 `SKILL_SCORING_STANDARD.md` 统一评分口径

---

## 四、怎么选

### 你在“开始搭结构”
用：`open-minis-project-bootstrapper/`

### 你在“判断这个技能下一步该干嘛”
用：`open-minis-skill-lifecycle-manager/`

### 你在“决定结果怎么呈现”
用：`open-minis-output-governor/`

### 你在“正式打分”
用：`SKILL_SCORING_STANDARD.md`

### 你在“打分前先排雷”
用：`SKILL_REVIEW_CHECKLIST.md`

### 你在“想参考优化方法论”
用：`darwin-skill/`

---

## 五、推荐执行顺序（极简版）

### 新技能
bootstrapper → lifecycle manager → review checklist → scoring standard

### 老技能优化
review checklist → lifecycle manager → scoring standard

### 结果输出治理
output governor →（必要时）lifecycle manager

### 高分封板
review checklist → scoring standard → lifecycle manager（maintenance/freeze 判断）

---

## 六、当前高成熟度元技能

| 对象 | 当前成熟度 |
|---|---:|
| `open-minis-project-bootstrapper` | 99.4 |
| `open-minis-skill-lifecycle-manager` | 99.4 |
| `open-minis-output-governor` | 99.3 |
| 记忆系统整体 | 99.2 |
| `memory-system-git-sync` | 99.4 |

说明：这些分数用于表示当前仓库中的元治理能力成熟度，不代表后续不再优化，而是说明已进入“生产级/维护态优先”的阶段。

---

## 七、结论

如果只记一句：

- **先搭结构** → `open-minis-project-bootstrapper/`
- **再管生命周期** → `open-minis-skill-lifecycle-manager/`
- **再管输出形式** → `open-minis-output-governor/`
- **正式评分** → `SKILL_SCORING_STANDARD.md`
- **评分前快检** → `SKILL_REVIEW_CHECKLIST.md`
- **优化方法参考** → `darwin-skill/`
