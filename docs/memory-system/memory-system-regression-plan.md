# 记忆系统真实案例回归测试方案

生成时间：2026-04-15

## 目标
使用真实专题样本与真实任务场景，验证记忆系统技能组在以下方面是否工作正常：
- 专题优先检索是否正确
- 新信息写入前审查是否正确
- 写入层级判断是否正确
- 旧记忆审计与归并是否合理
- 整体治理编排是否不混乱

## 推荐回归顺序
1. `memory-topic-router`
2. `memory-write-gatekeeper`
3. `memory-layer-governor`
4. `memory-dedup-auditor`
5. `open-minis-memory-store`
6. `memory-system-maintainer`

## 回归步骤
### Case A：专题检索
- 使用 `/var/minis/shared/memory_topics/` 下真实专题文件
- 验证是否优先命中对应专题，而不是直接回退

### Case B：新规则进入系统
- 用真实任务中的新规则做输入
- 验证：
  - 值不值得记
  - 写到哪层
  - 是否误升格

### Case C：旧记忆治理
- 针对同一主题构造重复/冲突/过时项
- 验证：
  - auditor 是否先出报告
  - memory-store 是否在安全条件下归并

### Case D：系统总管编排
- 输入复合型问题
- 验证是否按正确顺序调用子技能

## 建议记录字段
- 日期
- 场景
- 使用技能
- 是否命中预期
- 是否存在误判
- 改进建议
