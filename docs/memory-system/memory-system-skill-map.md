# 记忆系统技能地图

生成时间：2026-04-15

## 一、总览
这套记忆系统技能分成 5 类职责：

1. **读取路由**：先从哪层记忆读
2. **写入审查**：新信息该不该写
3. **写入分层**：该写到哪一层
4. **整理审计**：旧记忆哪里乱了
5. **总管编排**：多技能怎么串起来

---

## 二、技能分工表

| 技能 | 核心职责 | 典型问题 |
|---|---|---|
| `memory-topic-router` | 决定**先读哪类记忆** | “继续某项目，先按过去约定来” |
| `memory-write-gatekeeper` | 决定**该不该写** | “记住这个”之前先审查值不值得记 |
| `memory-layer-governor` | 决定**写到哪层** | “这条该写专题还是全局？” |
| `memory-dedup-auditor` | 审计**重复/冲突/过时/层级错误** | “记忆系统是不是乱了？” |
| `open-minis-memory-store` | 归并、更新、清理旧记忆 | “把这个主题旧记忆收拢成一条” |
| `memory-system-maintainer` | 作为**总管**编排整套流程 | “帮我维护整个记忆系统” |

---

## 三、记忆层级地图

| 层级 | 位置 | 适用内容 |
|---|---|---|
| L0 不记录 | 无 | 闲聊、噪音、一次性无复用细节 |
| L1 daily memory | `/var/minis/memory/YYYY-MM-DD.md` | 近期变化、临时例外、路径调整、时间线增量 |
| L2 专题记忆 | `/var/minis/shared/memory_topics/` | 项目、站点、平台、工作流、方法论内长期稳定规则 |
| L3 GLOBAL | `/var/minis/memory/GLOBAL.md` | 跨主题长期原则、全局偏好、通用边界 |

---

## 四、推荐调用顺序

### 场景 A：任务开始前先查规则
1. `memory-topic-router`
2. 如专题不足，再补 `GLOBAL.md` / daily memory

### 场景 B：用户说“记住这个”
1. `memory-write-gatekeeper`
2. `memory-layer-governor`
3. 再实际写入对应层级

### 场景 C：某主题记忆越来越乱
1. `memory-dedup-auditor`
2. `open-minis-memory-store`

### 场景 D：维护整套记忆系统
1. `memory-system-maintainer`
2. 由它分发到具体子技能

---

## 五、常见问题对应技能

### 1. 继续某项目时先看旧规则
- 优先：`memory-topic-router`

### 2. 一条新规则该不该记
- 优先：`memory-write-gatekeeper`

### 3. 这条该记到专题还是全局
- 优先：`memory-layer-governor`

### 4. 记忆是不是重复/冲突/过时
- 优先：`memory-dedup-auditor`

### 5. 帮我把某主题记忆整理成主记忆
- 优先：`open-minis-memory-store`

### 6. 帮我整体治理这套记忆系统
- 优先：`memory-system-maintainer`

---

## 六、技能关系图（文字版）

```text
用户新信息
  -> memory-write-gatekeeper
  -> memory-layer-governor
  -> 写入 daily / topic / GLOBAL

用户继续旧任务
  -> memory-topic-router
  -> 先读 topic / GLOBAL / daily

用户说记忆乱了
  -> memory-dedup-auditor
  -> open-minis-memory-store

用户要整体治理
  -> memory-system-maintainer
  -> 编排以上全部技能
```

---

## 七、边界提醒
- `memory-topic-router` 是**读之前的路由器**，不是整理器。
- `memory-write-gatekeeper` 是**写之前的门卫**，不是分层器。
- `memory-layer-governor` 是**分层决策器**，不是审计器。
- `memory-dedup-auditor` 是**体检器**，默认不直接删除。
- `open-minis-memory-store` 是**整理器**，不是先验审计器。
- `memory-system-maintainer` 是**总管**，不是替代所有子技能的单体技能。
