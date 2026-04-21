---
aliases: [京东, jd]
preferred_route: browser_use
notes:
  - 商品页信息模块化明显，参数、评价、问答通常需滚动触发
  - 搜索页与详情页策略不同
pitfalls:
  - 商品标题、活动价、原价、券后价可能不是同一字段
  - 参数表与评价区常需进一步展开
recommended_flow:
  - 先确认任务目标
  - 商品详情按模块读取：标题/价格/参数/评价
---
京东任务适合 browser_use，尤其是商品参数和评价读取；不要直接整页抽取导致噪声过大。
