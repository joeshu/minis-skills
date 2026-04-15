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
2. 若只需一句结论：聊天内返回。
3. 若是结构化复盘：优先 Markdown。
4. 若是交互式展示或可视化：优先 HTML。
5. 若是媒体内容：优先 attachment。
6. 若需要跨会话长期保留：优先 shared。
7. 若只是当前会话临时结果：优先 workspace。

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

## 成功标准
- 能正确区分“聊天结论”和“落盘结果”
- 能正确区分 shared / workspace / attachments
- 能根据结果类型选对 Markdown / HTML / 媒体
- 能在需要时采用“聊天摘要 + 文件链接”组合
- 不把所有结果一律塞进聊天或一律落文件

- 不要把明明需要长期保留的结果只留在聊天里
- 不要把临时调试文件都堆进 shared
- 不要把纯文本长报告硬做成 HTML 页面
- 不要在用户只要一句结论时强制生成复杂文件
- 不要混淆“落盘位置”和“展示形式”

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

## 成功标准
- 能正确区分“聊天结论”和“落盘结果”
- 能正确区分 shared / workspace / attachments
- 能根据结果类型选对 Markdown / HTML / 媒体
- 不把所有结果一律塞进聊天或一律落文件

## 资源文件
- `README.md`
- `test-prompts.json`

## 测试要求
至少覆盖：
1. 聊天短结论
2. Markdown 报告
3. HTML 页面
4. shared 跨会话文件
5. workspace 临时文件
6. attachment 媒体结果
7. 聊天 + 文件链接组合输出
