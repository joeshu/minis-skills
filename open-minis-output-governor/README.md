# open-minis-output-governor

用途：决定结果该怎么展示和保存。

## 默认顺序
1. 短结论 → 聊天
2. 可复盘结果 → Markdown
3. 可视化结果 → HTML / attachment
4. 跨会话结果 → shared
5. 临时结果 → workspace

## 常见判断
- 只看一句话：聊天
- 结构化总结：Markdown
- 页面化展示：HTML
- 图表/图片：attachment
- 以后还要继续用：shared
- 当前临时调试：workspace

## 关键原则
- 先判断“要不要落盘”
- 再判断“落在哪里”
- 再判断“用什么形式展示”
- 默认优先给一句聊天摘要，再按需附文件链接
- 若结果既要简洁结论又要后续复用，优先“聊天摘要 + 文件链接”组合
