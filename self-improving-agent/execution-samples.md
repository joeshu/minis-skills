# self-improving-agent 执行样本记录模板

用途：记录一次真实 learning / error / feature 决策过程，作为回归验证样本。

## 建议记录字段
- 日期
- 用户原始场景
- 判定类别（learning / error / feature / ignore）
- 是否值得记录
- 记录层级（技能区 / 项目级 / 公共区 / Minis 记忆）
- 是否为复发问题
- 是否发生提升
- 最终结果质量评估
- 备注

## 样本模板
```md
### Sample N
- 日期：YYYY-MM-DD
- 用户原始场景：
- 判定类别：learning / error / feature / ignore
- 是否值得记录：是 / 否
- 记录层级：技能区 / 项目级 / 公共区 / Minis 记忆
- 是否为复发问题：是 / 否
- 是否发生提升：是 / 否
- 最终结果质量评估：好 / 一般 / 差
- 备注：
```
