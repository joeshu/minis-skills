# web-access execution samples

## Sample 1：微信公众号文章总结
用户请求：帮我总结这篇微信公众号文章的核心观点

建议执行：
1. route-task.mjs → `extractor_first`
2. 命中站点经验 `mp.weixin.qq.com`
3. 先走正文抽取
4. 若正文不完整，再升级到 `browser_use.get_readable`

## Sample 2：GitHub 仓库信息读取
用户请求：去 GitHub 上看这个仓库的 issue 和 release

建议执行：
1. route-task.mjs → `browser_interactive`
2. 命中站点经验 `github.com`
3. 先识别页面类型（repo / issue / release）
4. 精确读取目标区域，避免整页噪声

## Sample 3：小红书找博主和最新笔记
用户请求：帮我在小红书搜索某个博主并点进最新笔记

建议执行：
1. route-task.mjs → `browser_interactive`
2. 命中站点经验 `xiaohongshu.com`
3. 先进入搜索/入口页，再点击进入详情页
4. 必要时滚动触发内容加载

## Sample 4：微博话题收集
用户请求：帮我看微博某个话题下最近大家都在讨论什么

建议执行：
1. route-task.mjs → `browser_interactive`
2. 命中站点经验 `weibo.com`
3. 优先识别话题页/搜索页/详情页
4. 时间线任务优先 `scroll_and_collect`

## Sample 5：B站视频页线索总结
用户请求：去 B站 看这个视频页的标题简介和评论，帮我总结主题

建议执行：
1. route-task.mjs → `browser_interactive`
2. 命中站点经验 `bilibili.com`
3. 先读取标题、简介、标签、评论区
4. 明确说明结论来自页面线索，不等于直接理解视频音画本体

## Sample 6：生成候选站点经验
命令：
`node /var/minis/skills/web-access/scripts/suggest-site-pattern.mjs example.com "详情页正文需要先点击展开"`

结果：
- 在 `/var/minis/workspace/web-access-suggestions/` 生成候选文件
- 不直接写入正式模式库

## Sample 7：合并候选经验
命令：
`node /var/minis/skills/web-access/scripts/merge-suggested-patterns.mjs`

结果：
- 将候选经验合并到 `MERGED-SUGGESTIONS.md`
- 便于集中审阅与后续正式回填

## Sample 8：生成去重后的发布稿
命令：
`node /var/minis/skills/web-access/scripts/publish-suggested-patterns.mjs`

结果：
- 读取所有 `*.candidate.md`
- 去重后生成 `PUBLISH-READY.md`
- 便于集中审阅并正式发布

## Sample 9：正式写入新站点经验
命令：
`node /var/minis/skills/web-access/scripts/add-site-pattern.mjs example.com "详情页正文需要先点击展开"`

结果：
- 若不存在则创建 `example.com.md`
- 若已存在则向 notes 追加经验
