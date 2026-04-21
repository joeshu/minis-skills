---
aliases: [X, Twitter, 推特, 推文]
preferred_route: browser_use
notes:
  - 时间线、搜索结果、单条推文详情页差异大
  - 无限滚动与虚拟列表明显，适合 scroll_and_collect
pitfalls:
  - 未登录/地区限制时可见性差异很大
  - DOM 经常变化，选择器应尽量依赖重复内容项结构
recommended_flow:
  - 单条推文优先详情页
  - 时间线/搜索结果优先 scroll_and_collect
  - 需要上下文时读取回复链/引用链
---
X/Twitter 任务默认走 browser_use，并优先考虑虚拟滚动列表特征；不要把整页一次性 get_text 当主方案。
