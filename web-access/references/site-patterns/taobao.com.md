---
aliases: [淘宝, taobao]
preferred_route: browser_use
notes:
  - 搜索结果、商品详情、店铺页、评价区结构不同
  - 商品详情往往需要下拉触发更多模块加载
pitfalls:
  - 价格、SKU、优惠、运费、评价可能分散在不同模块
  - 未登录或风控时页面可见区域会变化
recommended_flow:
  - 先明确目标：找商品 / 比价 / 读详情 / 看评价
  - 商品页分模块读取，不要整页混读
---
淘宝任务默认走 browser_use，尤其是比价、看 SKU、看评价时；若只是确认商品标题/价格，可优先读取关键模块。
