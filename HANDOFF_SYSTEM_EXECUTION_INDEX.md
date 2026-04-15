# HANDOFF_SYSTEM_EXECUTION_INDEX

生成时间：2026-04-16

## 一、目的

汇总 Minis 项目交接 / 长任务连续性系统各组件的 execution samples 入口，方便后续：
- 积累真实 handoff 案例
- 做跨会话继续的回归验证
- 检查删除历史会话前的护栏是否可靠
- 在维护态下优先用样本修边界，而不是继续堆规则

---

## 二、核心样本入口

### 1. 当前会话压缩与交接摘要
- `session-context-compactor/execution-samples.md`
- 用途：记录仅整理摘要、删除前整理、shared handoff、必要文件识别、摘要质量自检等真实案例。

### 2. 前中后连续性编排
- `open-minis-handoff-orchestrator/execution-samples.md`
- 用途：记录开始前查记忆、执行中按需沉淀、结束后 handoff、删除前确认、失败回退等真实案例。

---

## 三、建议统一记录维度

跨这套系统，建议 execution samples 尽量统一记录：
- 日期
- 原始用户请求
- 命中的技能
- 当前场景类型（仅压缩 / 跨会话 / 删除前整理 / 完整闭环）
- 是否跨会话继续
- 是否涉及删除历史会话
- 必要保留文件
- 最终产物位置（workspace / shared）
- 是否满足用户预期
- 是否暴露新边界
- 是否需要回归修正
- 备注

---

## 四、推荐评估模式标记

后续结合统一评分标准时，建议标记：
- `full-test`
- `full-test style`
- `dry-run`

---

## 五、推荐使用方式

### 场景 A：维护态下补真实 handoff 案例
1. 先在对应技能的 `execution-samples.md` 里补样本
2. 若发现边界问题，再回对应技能做小修
3. 必要时更新 `REPORT.md`

### 场景 B：跨会话继续回归
1. 先看本索引定位到相关样本入口
2. 再检查对应 skill 的 `REPORT.md`
3. 必要时回到 `HANDOFF_SYSTEM_REPORT.md` 看整体分工

### 场景 C：删历史前护栏回归
1. 优先看 `session-context-compactor` 的真实样本
2. 检查摘要、必要文件、确认流程是否都完整
3. 有缺口时只修相关边界，不默认大改整条系统

---

## 六、与系统文档的关系

- `HANDOFF_SYSTEM_INDEX.md`：总入口，告诉你什么时候用哪个组件
- `HANDOFF_SYSTEM_REPORT.md`：总报告，告诉你系统目标、分工、成熟度
- `HANDOFF_SYSTEM_EXECUTION_INDEX.md`：样本索引，告诉你真实 handoff 案例该去哪里沉淀
- `HANDOFF_SYSTEM_FREEZE_NOTE.md`：封板说明，告诉你为什么进入维护态以及后续维护策略

---

## 七、结论

到这里，这套项目交接 / 长任务连续性系统已经具备：
- 总入口
- 总报告
- 样本索引
- 封板说明（配套）

这意味着该体系可以从“方法成型”进入：

# **样本驱动的维护态优化阶段**
