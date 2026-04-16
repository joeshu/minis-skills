# nuwa-open-minis

## 简介
`nuwa-open-minis` 是一个 **Open Minis 专用造 Skill 系统**。

它的目标不是解释“如何造 Skill”，而是把用户提供的人物、主题、行业、岗位、内部材料，稳定地蒸馏成真实落地的技能包产物，至少包括：
- `SKILL.md`
- `README.md`
- `test-prompts.md`
- `REPORT.md`

它重点解决原版女娲在 Open Minis 中“可见但不执行”的问题，强调：
- 先落文件
- 再输出正文
- 不依赖 `.claude/skills`
- 适配 `/var/minis/workspace` 与 `/var/minis/skills`
- 允许降级执行，但不允许停留在说明层

---

## 适用场景
适用于以下任务：
- 造一个新 Skill
- 基于多份内部材料蒸馏行业 / 岗位 / 专题 Skill
- 基于现有 Skill 做增量更新
- 为 Open Minis 生成完整技能包
- 为新 Skill 自动补齐 README / REPORT / test-prompts

---

## 核心特性
### 1. Open Minis 兼容执行
- 目录兼容：`/var/minis/workspace/`、`/var/minis/skills/`
- 最小执行闭环：定名 → 建目录 → 写 `SKILL.md` → 给路径 → 再输出
- 长文支持分段输出
- 失败时最少也要落一版可审稿文件

### 2. 女娲方法论兼容
- 本地材料优先
- 材料模式判断
- 心智模型三重筛选（跨场景复现 / 生成力 / 排他性）
- 决策启发式结构化提炼
- 表达 DNA 提炼
- 诚实边界与质量自检
- Response Workflow 生成建议

### 3. 项目级产物生成
- `SKILL.md`
- `README.md`
- `test-prompts.md`
- `REPORT.md`
- `research-summary.md`（按需）

---

## 当前文件
- [SKILL.md](minis://skills/nuwa-open-minis/SKILL.md)
- [README.md](minis://skills/nuwa-open-minis/README.md)
- [REPORT.md](minis://skills/nuwa-open-minis/REPORT.md)
- [test-prompts.md](minis://skills/nuwa-open-minis/test-prompts.md)
- [execution-samples.md](minis://skills/nuwa-open-minis/execution-samples.md)

---

## 推荐触发方式
```markdown
造一个「XX Skill」。
请直接输出最终可用版 SKILL.md 全文。
不要解释过程，不要只给框架。
先落地到文件，再继续输出正文。
如果一次输出不完，请分段继续。
```

---

## 当前判断
`nuwa-open-minis` 已经不是一个简单提示词，而是一套适配 Open Minis 的造 Skill 工作系统。它更适合：
- 内部材料喂养型 Skill
- 行业 / 岗位 / 专题 Skill
- 需要真实落地文件的会话式环境
