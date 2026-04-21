---
aliases: [微信公众号, 微信文章, wechat, mp.weixin]
preferred_route: extractor_first
notes:
  - 公众号文章通常适合正文抽取优先
  - 若页面带外链卡片、延伸内容或需展开全文，再切浏览器路径
pitfalls:
  - 只读原始 HTML 容易混入导航、脚本、推荐内容
  - 某些文章会有区域限制、失效跳转或二次落地页
recommended_flow:
  - 先正文抽取
  - 不完整时用 browser_use.get_readable/get_text
---
微信公众号文章一般先走正文抽取；只有在主内容缺失、存在交互展开、或需要提取页面附加信息时才升级到 browser_use 深入读取。
