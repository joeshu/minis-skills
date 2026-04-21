---
aliases: [微博, weibo]
preferred_route: browser_use
notes:
  - 搜索页、用户主页、单条微博详情页结构不同
  - 时间线常为动态加载，滚动后才出现更多内容
pitfalls:
  - 未登录或风控时，搜索与详情可见性会变化
  - 话题页、用户页、详情页不要混用选择器策略
recommended_flow:
  - 先识别页面类型
  - 详情读取优先正文区域
  - 时间线/搜索结果优先滚动收集
---
微博任务默认走 browser_use。若目标是某条具体微博，优先进入详情页后再抽取；若目标是时间线/搜索结果，优先 scroll_and_collect。
