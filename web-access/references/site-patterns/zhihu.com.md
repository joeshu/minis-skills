---
aliases: [知乎, zhihu]
preferred_route: browser_use
notes:
  - 优先通过站内搜索、问题页、专栏页真实入口进入，不手拼复杂 URL
  - 某些内容折叠、登录提示、推荐流需要滚动或点击后才出现
pitfalls:
  - 直接抓初始 HTML 往往不完整
  - 页面提示受限时，不代表内容真不存在，可能只是入口或交互状态不对
recommended_flow:
  - navigate -> wait_for_dom_stable -> get_readable/get_text -> 必要时 click/scroll
---
知乎类页面常为动态渲染。
优先用 browser_use 读取页面真实可见内容；如果是文章/回答正文，优先抽取主内容，避免只读导航/推荐区。
