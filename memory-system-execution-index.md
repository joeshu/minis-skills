# 记忆系统执行样本索引

生成时间：2026-04-16

## 目的
汇总记忆系统各技能与配套编排技能的真实执行样本模板，便于后续积累真实案例并进行回归验证。

## 配套评分标准
- `SKILL_SCORING_STANDARD.md`
- 用途：后续对各技能 execution samples 与 REPORT 进行统一评分时，默认按这份标准解释维度、权重与评估模式。

## 技能样本入口
### 核心记忆治理技能
- `memory-topic-router/execution-samples.md`
- `memory-layer-governor/execution-samples.md`
- `memory-write-gatekeeper/execution-samples.md`
- `memory-dedup-auditor/execution-samples.md`
- `open-minis-memory-store/execution-samples.md`
- `memory-system-maintainer/execution-samples.md`
- `memory-system-git-sync/execution-samples.md`

### 连续性 / 交接相关技能
- `open-minis-handoff-orchestrator/execution-samples.md`
- `session-context-compactor/execution-samples.md`

## 建议统一记录维度
- 日期
- 用户原始请求
- 命中的技能或组合流程
- 判断结果
- 是否成功减少噪音/冲突
- 是否涉及层级迁移
- 是否涉及 shared / docs / restore 同步
- 是否发现新边界
- 备注

## 建议评估模式标记
- `full-test`
- `full-test style`
- `dry-run`
