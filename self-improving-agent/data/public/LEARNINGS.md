# Learnings
## [LRN-20260317-EUC] category

**记录时间**: 2026-03-17T14:05:12Z
**优先级**: medium
**状态**: pending
**领域**: docs

### 摘要
初始化 self-improving-agent 时脚本无执行权限

### 详情
在 Minis 中此脚本应通过 sh 显式调用，避免 Permission denied；优先用 sh /var/minis/skills/self-improving-agent/scripts/minis_auto_log.sh init

### 建议动作
（待补充）

### 元数据
- 来源: conversation
- 关联文件: (可选)
- 标签: (可选)

---
