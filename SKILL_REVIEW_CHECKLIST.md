# SKILL_REVIEW_CHECKLIST

用途：在正式评分、发布或封板前，对一个技能做快速人工检查，避免明显缺口带入后续流程。

---

## 一、最小骨架检查
- [ ] 有 `SKILL.md`
- [ ] 有 `README.md`
- [ ] 有 `test-prompts.json`

如果上面任何一项缺失：
- 不建议直接进入正式评分
- 应先补基础骨架

---

## 二、发布资产检查
- [ ] 有 `REPORT.md`
- [ ] 有 `execution-samples.md`
- [ ] 报告里的评分模式已标明：`full-test` / `full-test style` / `dry-run`

---

## 三、frontmatter 检查
- [ ] `name` 清楚稳定
- [ ] `description` 说清做什么
- [ ] `description` 说清何时用
- [ ] `description` 没有过虚或过长

---

## 四、正文结构检查
- [ ] 有明确工作流 / 决策树 / 路线
- [ ] 有输入 / 输出说明
- [ ] 有边界规则
- [ ] 有成功标准
- [ ] 没有明显重复段落

---

## 五、检查点与边界检查
- [ ] 关键节点前有检查点
- [ ] 说明了何时不该用
- [ ] 说明了失败/异常/保守路径
- [ ] 没有把相邻技能职责全吞进去

---

## 六、测试样例检查
- [ ] `test-prompts.json` 覆盖 happy path
- [ ] 覆盖至少 1 个边界场景
- [ ] 覆盖至少 1 个容易误用场景
- [ ] 样例不只是换句话重复同一种情况

---

## 七、资源整合检查
- [ ] `README.md` 和 `SKILL.md` 不冲突
- [ ] `REPORT.md` 分数口径一致
- [ ] `execution-samples.md` 字段能支撑后续回归
- [ ] 文件命名和路径一致

---

## 八、评分前结论
### 可以直接评分
适用：
- 最小骨架完整
- 工作流清楚
- 测试样例基本够用

### 先补再评
适用：
- 缺 `README` / `test-prompts` / `REPORT` / `execution-samples`
- 边界或检查点明显不足

### 先重构再评
适用：
- 职责模糊
- 工作流混乱
- 重复严重
- 报告和技能正文明显脱节

---

## 九、与统一评分标准的关系
- 本清单用于**评分前快检**
- 正式打分仍以 `SKILL_SCORING_STANDARD.md` 为准
- `darwin-skill` 仍是优化方法与评分框架来源
