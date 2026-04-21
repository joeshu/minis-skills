---
aliases: [少数派, sspai]
preferred_route: extractor_first
notes:
  - 文章正文质量高，通常适合直接抽取主内容
  - 列表页、专题页、作者页再用 browser_use
pitfalls:
  - 别把推荐区、相关文章、商品卡片混入正文
recommended_flow:
  - 文章页正文抽取优先
  - 需要作者/专题关系时再读取页面结构
---
少数派大多是典型文章型页面，适合正文优先；若任务涉及导航、专题、作者矩阵，再切 browser_use。
