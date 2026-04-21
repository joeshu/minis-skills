# web-access INDEX

## 定位
`web-access` 是 Minis 里的统一网页任务入口之一，用于处理：
- 读网页 / 读文章 / 提取正文
- 去某网站找内容 / 找入口
- 动态网页点击、展开、滚动、收集
- 复用站点经验并持续沉淀

## 最小执行链
1. `route-task.mjs`：判断任务路线
2. `match-site.mjs`：命中站点经验
3. 选择执行层：`extractor_first` / `browser_interactive` / `search_then_browser`
4. 执行后沉淀经验：候选生成 → 候选合并 → 候选发布 → 正式回填

## 核心文件
- `SKILL.md`：技能主入口
- `README.md`：设计说明
- `INDEX.md`：总导航
- `INSTALL.md`：安装与验证
- `REPORT.md`：最终评估
- `WEB-ACCESS-ENTRY.md`：统一入口协议
- `WEB-ACCESS-ALIASES.md`：自然语言别名协议

## 核心脚本
- `scripts/route-task.mjs`
- `scripts/match-site.mjs`
- `scripts/find-url.mjs`
- `scripts/verify-install.mjs`
- `scripts/suggest-site-pattern.mjs`
- `scripts/merge-suggested-patterns.mjs`
- `scripts/publish-suggested-patterns.mjs`
- `scripts/add-site-pattern.mjs`

## 模式库位置
- `references/site-patterns/*.md`

当前已覆盖：
- zhihu.com
- xiaohongshu.com
- mp.weixin.qq.com
- github.com
- weibo.com
- bilibili.com
- juejin.cn
- sspai.com
- x.com
- taobao.com
- jd.com

## 候选沉淀链
1. `suggest-site-pattern.mjs` 生成 `*.candidate.md`
2. `merge-suggested-patterns.mjs` 生成 `MERGED-SUGGESTIONS.md`
3. `publish-suggested-patterns.mjs` 生成 `PUBLISH-READY.md`
4. `add-site-pattern.mjs` 正式写入模式库

候选目录：
- `/var/minis/workspace/web-access-suggestions/`

## 常用命令

### 路由判断
```bash
node /var/minis/skills/web-access/scripts/route-task.mjs "帮我总结这篇微信公众号文章"
```

### 匹配站点经验
```bash
node /var/minis/skills/web-access/scripts/match-site.mjs "帮我看微博某个话题下最近大家都在讨论什么"
```

### 生成候选经验
```bash
node /var/minis/skills/web-access/scripts/suggest-site-pattern.mjs example.com "详情页正文需要先点击展开"
```

### 合并候选经验
```bash
node /var/minis/skills/web-access/scripts/merge-suggested-patterns.mjs
```

### 生成发布稿
```bash
node /var/minis/skills/web-access/scripts/publish-suggested-patterns.mjs
```

### 正式回填经验
```bash
node /var/minis/skills/web-access/scripts/add-site-pattern.mjs example.com "详情页正文需要先点击展开"
```

## 路由选择速查
- 文章/正文提取优先：`extractor_first`
- 点击/展开/滚动/搜索优先：`browser_interactive`
- 找官网/找入口/找链接优先：`search_then_browser`
- 命中站点经验时：站点经验优先于泛化规则

## 当前状态
已形成：
- 统一入口
- 站点模式库
- 可维护沉淀链
- 测试样例与执行样例
- 最终报告
