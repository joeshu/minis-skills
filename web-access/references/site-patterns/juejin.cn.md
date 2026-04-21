---
aliases: [掘金, juejin]
preferred_route: extractor_first
notes:
  - 文章正文通常适合先走正文抽取
  - 用户主页、专栏列表、标签页更适合 browser_use
pitfalls:
  - 只抽正文时容易漏作者信息、标签、发布时间
  - 列表页卡片信息适合结构化读取，不适合直接全文抽取
recommended_flow:
  - 文章页先抽正文
  - 列表/主页先浏览定位再进入详情
---
掘金文章通常适合 extractor_first；若任务涉及作者主页、标签页、合集入口，再升级到 browser_use。
