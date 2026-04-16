# 记忆系统使用手册

生成时间：2026-04-15

## 一、怎么用这套记忆技能
这套技能不是后台自动守护程序，而是：
- 你可以**直接点名技能**
- 也可以**直接说自然语言意图**
- 我负责根据意图自动匹配合适的记忆技能

简单理解：
- 你负责说需求
- 我负责选对技能并按顺序调用

---

## 二、最常见的 7 类意图

### 1. 继续旧项目 / 旧主题时，先查长期规则
通常触发：`memory-topic-router`

### 2. 想把一条新信息记住之前，先判断值不值得记
通常触发：`memory-write-gatekeeper`

### 3. 想知道这条信息该写到哪层记忆
通常触发：`memory-layer-governor`

### 4. 觉得某个主题的记忆太乱了，先做体检
通常触发：`memory-dedup-auditor`

### 5. 想把一个主题的旧记忆整理成主记忆
通常触发：`open-minis-memory-store`

### 6. 想整体维护这套记忆系统
通常触发：`memory-system-maintainer`

### 7. 想把这套系统安全推送到 git，或在重装后恢复
通常触发：`memory-system-git-sync`

---

## 三、最短实战流程

### 场景 A：继续某项目
`memory-topic-router`

### 场景 B：记一条新规则
`memory-write-gatekeeper` → `memory-layer-governor`

### 场景 C：主题记忆越来越乱
`memory-dedup-auditor` → `open-minis-memory-store`

### 场景 D：整体治理
`memory-system-maintainer`

### 场景 E：同步或恢复这套系统
`memory-system-git-sync`

---

## 五、补充入口
- 如果你想快速看清各子技能负责什么、不负责什么、哪些动作必须先确认，优先读：
  - `docs/memory-system/memory-subsystems-responsibility-matrix.md`

