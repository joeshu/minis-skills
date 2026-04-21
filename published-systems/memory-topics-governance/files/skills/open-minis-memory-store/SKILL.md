---
name: open-minis-memory-store
description: Minimal memory entry for Open Minis. Use it to decide whether to read memory, whether new information should be remembered, and which layer it belongs to: topic memory, GLOBAL.md, daily memory, or nowhere.
---

# open-minis-memory-store

一个用于**最小化处理记忆读写**的统一入口技能。
目标：把原先分散的“先查哪层、写到哪层、要不要记”压成一个最小闭环，减少 router / governor / 审计链路的日常参与。

## 适用场景
- 用户说“记住这个”“帮我保存偏好”
- 用户说“先按之前规则来”“查一下记忆”
- 需要判断新信息该写到 `GLOBAL.md` / daily / topic / nowhere
- 需要在开始任务前决定是否要读取记忆

## 不适用场景
- 全局记忆清理、冲突审计、系统级维护
- 大规模归并旧记忆
- 专门的长期维护/发布动作

## 统一原则
- **先判断这次是否真的需要记忆参与**
- **读取优先最小化：topic 命中才读 topic，否则必要时才 `memory_get`**
- **写入优先最小化：不值得记就不写；不确定先 daily，不急着升格**
- **当前用户要求优先于历史记忆**

## 读取规则
### 默认顺序
1. 若任务明确命中某个专题/项目/工作流/平台 → 优先读对应 topic file
2. 若没有明确 topic，但任务明显依赖跨会话约定 → `memory_get`
3. 若当前问题可直接回答或直接执行 → 不额外读记忆

### 何时不读记忆
- 简单确认句
- 单条命令/单点操作
- 当前会话已有足够上下文
- 读取不会改变动作或结论

## 写入规则
### Step 1：值不值得记
建议记录：
- 用户明确要求记住
- 会影响后续执行
- 明显可复用
- 属于稳定偏好 / 稳定规则 / 长期约定

不建议记录：
- 普通闲聊
- 一次性细节
- 明显临时变化且无复用价值
- 用户明确说不要记

### Step 2：写到哪层
- **daily memory**：近期变化、临时例外、尚未验证稳定
- **topic memory**：单一主题内长期有效、可复用规则
- **GLOBAL.md**：跨主题长期原则；仅在用户明确要求全局保存时写入
- **nowhere**：噪音、临时信息、无复用价值

### 默认防抖
- 不确定时先写 daily
- 不因一次出现就升格到 topic / GLOBAL
- 只在用户明确要求或规则已稳定时才升层

## 输出格式
默认只给最短结论：
- 要不要读记忆
- 若要读，先读哪里
- 要不要写记忆
- 若要写，写到哪层

## 与其他技能的关系
- 本技能是**日常最小入口**
- `memory-system-maintainer`：仅用于低频系统维护
- `memory-dedup-auditor`：仅用于低频审计
- `open-minis-six-skeletons-router`：仅用于复杂跨系统任务兜底

## 成功标准
- 简单任务不被迫进入复杂记忆链路
- 读取路径更短
- 写入分层更少跳转
- 仍保留 topic / daily / GLOBAL 的基本边界
