# SKILL 结构与章节模板规范

## 目标
本文件负责统一 `nuwa-open-minis` 的产物层结构选择，避免模板性内容继续膨胀主 `SKILL.md`。

## Frontmatter 规则
如果生成目标是长期复用 Skill，优先在 `SKILL.md` 顶部加入 frontmatter。

推荐字段：
```yaml
---
name: [skill-id]
description: |
  [一句话说明这个 Skill 提炼了谁 / 什么主题的思维框架与表达方式]
  [说明核心来源类型、用途与触发场景]
---
```

原则：
1. `description` 不只是标题重复，而要同时回答：这是谁 / 这是什么主题、适合拿来做什么、什么时候应触发。
2. 人物型可补来源类型与常见触发词。
3. 主题型可补主题范围与适用问题类型。

## 最小必要章节
默认优先保证以下最小骨架：
- `Skill Identity` 或同等定位章节
- `Primary Mission`
- `Core Mental Models`
- `Decision Heuristics` 或判断规则
- `Capability Boundaries`
- `Final Rule`

## 常见增强章节
根据任务需要再补：
- `Applicable Scenarios`
- `Non-Applicable Scenarios`
- `Expression DNA`
- `Common Anti-Patterns`
- `Working Process`
- `Standard Output Modules`
- `Response Workflow`
- `Example Prompts`

## 人物型常见增强
人物型任务优先考虑补：
- `身份卡`
- `时间线`
- `价值观与反模式`
- `批评者视角`
- `内在张力`
- `调研来源 / 附录`

人物型最低要求：
1. 尽量立住身份感
2. 尽量体现至少一处关键张力
3. 尽量保留来源结构意识

## 主题 / 岗位型常见增强
主题或岗位型任务优先考虑补：
- `问题路由`
- `执行规则`
- `Reference 索引`
- `Topic-Specific Tactics`

原则：
- 不只是会总结，还要会带路
- 不同问题类型尽量走不同路径

## Response Workflow 约束
如果增加 `Response Workflow`：
1. 必须来自已提炼的心智模型和表达 DNA
2. 不能写成所有 Skill 都一样的通用 AI 模板
3. 若主题很窄、材料很少，可以省略，不硬凑

## 结构选择原则
1. 先看任务目标，再选结构
2. 只保留真正服务运行的章节
3. 不为了完整把所有章节全部硬塞进去
4. `SKILL.md` 服务于运行，不服务于看起来完整
