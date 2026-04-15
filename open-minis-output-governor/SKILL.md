---
name: open-minis-output-governor
description: Decide how task results should be presented and stored in Minis: chat summary, markdown file, HTML page, shared artifact, attachment, or report. Use when the user needs outputs that are durable, readable, shareable, or suitable for continued work, and you need to avoid dumping everything directly into chat.
compatibility: file_write, file_read, shell_execute, browser_use
---

# open-minis-output-governor

一个用于**决定结果该怎么落盘和展示**的执行型技能。
目标：避免把所有结果都直接堆进聊天，把结果按用途路由到最合适的输出形式。

## 触发词
- 帮我整理成文件
- 给我一个报告 / 页面 / 摘要
- 这个结果要方便下次继续用
- 不要只发聊天里
- output routing / save as report / generate artifact

## 输入
- 当前任务结果
- 用户期望：只看结论 / 需要复盘 / 需要可视化 / 需要跨会话继续 / 需要分享
- 可选媒介：文本 / 表格 / 页面 / 图片 / 图表

## 输出
默认返回：
1. 推荐输出类型
2. 推荐落盘位置
3. 是否需要同时给聊天摘要
4. 若需落盘，给出建议文件类型

## 输出目标类型
### A. 聊天内简述
适用：
- 只要一句结论
- 一次性短答复
- 不需要后续继续处理

### B. Markdown 报告
适用：
- 结构化复盘
- 需要长期阅读
- 需要后续继续参考
- 适合文本、表格、记录、总结

### C. HTML 页面
适用：
- 需要交互式浏览
- 需要更强可视化
- 需要像 artifact 一样展示结果

### D. shared 长期文件
适用：
- 跨会话继续使用
- 需要长期沉淀
- 需要分享或后续引用

### E. workspace 临时文件
适用：
- 当前会话调试
- 临时中间结果
- 不一定长期保留

### F. attachment 媒体文件
适用：
- 图片
- 图表
- 音视频
- 明确要预览的媒体内容

## 输出路由矩阵
| 任务特征 | 展示形式优先 | 存储位置优先 | 聊天中是否保留摘要 |
|---|---|---|---|
| 只要一句结论 | 聊天 | 不落盘 | 是，直接给结论 |
| 结构化复盘/报告 | Markdown | shared / workspace（按生命周期） | 是，给 1~3 句摘要 |
| 页面化浏览/演示 | HTML | shared / workspace（按生命周期） | 是，附页面链接 |
| 图片/图表/音视频预览 | attachment | attachments | 可选，通常给一句说明 |
| 跨会话继续使用 | Markdown / HTML / 代码文件 | shared | 是，附稳定链接 |
| 当前调试中间产物 | 文本 / 代码 / JSON / Markdown | workspace | 只给最小摘要 |
| 用户明确“只要文件” | 与内容匹配即可 | 按生命周期 | 否，或只给最小一句 |

## 路由冲突时的优先级
当一个任务同时命中多个输出信号时，按以下顺序裁决：
1. **用户明确要求** 优先于默认路由
2. **生命周期（shared vs workspace）** 优先于展示形式
3. **展示形式匹配度（Markdown / HTML / attachment）** 优先于个人偏好式美化
4. **聊天负担最小化**：若文件已足够，不在聊天重复长内容
5. **组合输出优先于单一路径误伤**：同时需要结论与产物时，用“聊天摘要 + 文件链接”


## 决策原则
- **短结论优先聊天**
- **需要复用/分享/继续处理的结果优先落盘**
- **跨会话优先 shared**
- **临时调试优先 workspace**
- **可视化优先 HTML 或 attachment**
- **如果结果既要聊天结论又要落盘，优先“聊天摘要 + 文件链接”组合**

## 工作流

### 决策树
1. 先判断结果是一次性查看，还是后续还要继续用。
2. 先判断用户要的是“只看结论”还是“要可继续使用的产物”。
3. 若只需一句结论：聊天内返回。
4. 若是结构化复盘：优先 Markdown。
5. 若是交互式展示或可视化：优先 HTML。
6. 若是媒体内容：优先 attachment。
7. 若需要跨会话长期保留：优先 shared。
8. 若只是当前会话临时结果：优先 workspace。
9. 若同时存在“聊天结论 + 可继续产物”需求：采用“聊天摘要 + 文件链接”组合。

### 检查点
#### Checkpoint A：是否必须落盘
- 用户是否明确要求文件 / 页面 / 附件
- 结果是否需要跨会话继续使用
- 结果是否明显长于适合聊天直接阅读的范围

#### Checkpoint B：展示形式是否匹配结果类型
- 文本复盘是否更适合 Markdown
- 可视化浏览是否更适合 HTML
- 媒体预览是否更适合 attachment

#### Checkpoint C：落盘位置是否匹配生命周期
- 长期沉淀 / 分享 / 引用：shared
- 当前调试 / 中间产物：workspace
- 媒体直接预览：attachments

#### Checkpoint D：是否需要组合输出
- 用户是否同时要“先看结论”与“保留完整结果”
- 文件是否已经足以承载完整内容，聊天只需最小摘要
- 若聊天长篇复述会造成重复，应切换为“摘要 + 链接”

#### Checkpoint E：命名与目录是否稳定
- shared 中是否使用稳定、可复用的命名
- workspace 中是否避免把临时文件伪装成长期产物
- attachment 是否确实用于可直接预览的媒体类型

### 输出决策评分
给结果按目标打分：
- 只要一句结论：聊天 +3
- 需要结构化复盘：Markdown +3
- 需要交互或视觉呈现：HTML +3
- 需要直接预览媒体：attachment +3
- 跨会话继续使用：shared +3
- 当前会话临时调试：workspace +3

若多个分值同时较高：
- 优先采用“聊天摘要 + 文件链接”组合
- 再按长期性决定 shared / workspace

### Phase 1: 判断使用场景
- 临时查看
- 结构化复盘
- 交互式展示
- 跨会话继续
- 分享 / 对外引用

### Phase 2: 选择输出类型
- 临时短结果 → 聊天
- 文本总结 / 表格 / 报告 → Markdown
- 页面化展示 / 可视化结果 → HTML
- 图片 / 图表 / 媒体 → attachment

### Phase 3: 选择落盘位置
- 跨会话 / 长期沉淀 → `/var/minis/shared/`
- 当前会话临时结果 → `/var/minis/workspace/`
- 媒体预览 → `/var/minis/attachments/`

### Phase 4: 组织输出
- 默认先给一句聊天摘要
- 如落盘，再附文件链接
- 若用户只要文件，不必重复长聊天输出
- 若结果将进入 shared，优先使用稳定命名，避免临时文件名污染长期目录
- 若结果只是中间产物，避免误写 shared

### Phase 5: 落盘后自检
- 是否出现“形式正确但位置错误”（如本该 shared 却写到 workspace）
- 是否出现“位置正确但形式错误”（如纯文本长报告误做成 HTML）
- 是否已经给出足够但不过量的聊天摘要
- 是否给了可直接继续使用的文件链接或附件预览
- 是否避免把同一内容在聊天与文件中重复铺开

## 边界规则
- 不要把明明需要长期保留的结果只留在聊天里
- 不要把临时调试文件都堆进 shared
- 不要把纯文本长报告硬做成 HTML 页面
- 不要在用户只要一句结论时强制生成复杂文件
- 不要混淆“落盘位置”和“展示形式”
- 不要因为能落盘就默认落盘；若聊天已足够，应优先简答
- 不要把“共享位置”误当成“展示形式”
- 不要把“HTML 看起来更高级”当成默认理由；若 Markdown 已足够，应保持轻量
- 不要为了显得完整而同时生成过多产物；默认只生成满足需求的最小输出集

## 失败与回退规则
- 如果用户需求不明确到足以决定展示形式，先按最轻量方案处理：聊天摘要或 Markdown
- 如果不确定结果是否需要跨会话保留，默认不要写入 shared
- 如果可视化内容尚未成型，先落 Markdown / workspace，中间态不要硬产出半成品 HTML
- 如果附件型结果无法直接生成，先给可继续处理的文件，再说明可补附件预览
- 如果文件已生成但链接/预览不可用，至少在聊天中明确文件路径与用途

## 响应模板
### 聊天模板
- `我先给你一句结论。`

### Markdown 模板
- `这类结果更适合整理成 Markdown 报告，方便后续继续看。`

### HTML 模板
- `这类结果更适合做成 HTML 页面，便于浏览和展示。`

### shared 模板
- `这份结果后续还会继续用，建议写入 shared。`

### workspace 模板
- `这只是当前会话临时结果，放 workspace 更合适。`

### attachment 模板
- `这类结果适合保存成附件，方便直接预览。`

## 资源文件
- `README.md`
- `test-prompts.json`
- `REPORT.md`
- `execution-samples.md`

## 测试要求
至少覆盖：
1. 聊天短结论
2. Markdown 报告
3. HTML 页面
4. shared 跨会话文件
5. workspace 临时文件
6. attachment 媒体结果
7. 聊天 + 文件链接组合输出
8. 用户只要文件不要长聊天解释
9. 用户只要临时中间产物、不要长期沉淀
