---
aliases: [GitHub, github]
preferred_route: browser_use
notes:
  - 仓库页、issue、PR、actions、release、blob 页面结构不同
  - 代码阅读可直接抓文本，交互性操作再用浏览器
pitfalls:
  - 页面信息量大，先缩小目标区域，避免全文噪声
  - 动态区域如展开 diff、加载更多评论、actions 日志可能要点击或滚动
recommended_flow:
  - 先识别页面类型
  - 文本读取优先精确定位区域
  - 需要交互时再 click/scroll
---
GitHub 页面适合先做页面类型识别：仓库首页、README、Issue、PR、Commit、Release、Actions 的读取策略都不同。避免直接整页抓取导致噪声过高。
