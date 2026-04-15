## 记忆系统维护专题
- 读之前：优先用 `memory-topic-router` 决定先查哪层。
- 写之前：优先用 `memory-write-gatekeeper` 判断该不该写。
- 写入时：用 `memory-layer-governor` 决定写到哪层。
- 清理前：先用 `memory-dedup-auditor` 审计，再决定是否交给 `open-minis-memory-store` 归并。
- 全局治理问题可交给 `memory-system-maintainer` 编排。
