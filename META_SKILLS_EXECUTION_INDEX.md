# META_SKILLS_EXECUTION_INDEX

生成时间：2026-04-15

## 一、目的

汇总 Minis 元技能体系各组件的 execution samples 入口，方便后续：
- 积累真实案例
- 做跨组件回归
- 检查元治理流程是否真的在真实任务中可复用
- 在维护态下优先用样本而不是继续堆规则

---

## 二、核心样本入口

### 1. 项目骨架生成
- `open-minis-project-bootstrapper/execution-samples.md`
- 用途：记录不同项目类型、最小骨架、长期维护、跨会话 handoff、试验性项目等场景。

### 2. 技能生命周期治理
- `open-minis-skill-lifecycle-manager/execution-samples.md`
- 用途：记录技能从新建、补骨架、冲高、维护、freeze 判断到已发布再治理的阶段流转案例。

### 3. 输出治理
- `open-minis-output-governor/execution-samples.md`
- 用途：记录聊天 / Markdown / HTML / shared / workspace / attachments 的真实路由决策案例。

---

## 三、建议统一记录维度

跨元技能体系，建议 execution samples 尽量统一记录：
- 日期
- 原始用户请求
- 命中的元技能
- 所处阶段 / 场景类型
- 采取的路线或决策
- 最终产物
- 是否满足用户预期
- 是否发现新边界
- 是否需要回归修正
- 备注

---

## 四、建议评估模式标记

后续结合 `SKILL_SCORING_STANDARD.md` 与 `SKILL_REVIEW_CHECKLIST.md` 使用时，建议标记：
- `full-test`
- `full-test style`
- `dry-run`

---

## 五、推荐使用方式

### 场景 A：维护态下补真实案例
1. 在对应元技能的 `execution-samples.md` 里补样本
2. 若发现边界问题，再回对应技能做小修
3. 必要时更新 `REPORT.md`

### 场景 B：跨组件回归
1. 先看本索引定位到相关样本入口
2. 再检查对应 skill 的 `REPORT.md`
3. 必要时回到 `META_SKILLS_REPORT.md` 看整体分工

### 场景 C：封板后的持续治理
1. 先补样本
2. 再做回归
3. 最后才考虑是否需要改规则或扩组件

---

## 六、与其他元文档的关系

- `META_SKILLS_INDEX.md`：总入口，告诉你什么时候用哪个元技能
- `META_SKILLS_REPORT.md`：总报告，告诉你系统目标、分工、成熟度
- `META_SKILLS_FREEZE_NOTE.md`：封板说明，告诉你为什么进入维护态
- `META_SKILLS_EXECUTION_INDEX.md`：样本索引，告诉你真实案例该去哪里沉淀

---

## 七、结论

到这里，元技能体系已经具备：
- 总入口
- 总报告
- 封板说明
- 样本索引

这意味着该体系已从“建设期文档完备”进一步进入：

# **维护态样本驱动阶段**
