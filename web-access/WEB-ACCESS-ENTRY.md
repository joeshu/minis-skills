# WEB-ACCESS-ENTRY

## 统一入口约定

从现在起，`web-access` 作为 Minis 默认网页任务入口之一。
配套的用户侧自然语言别名协议见：`WEB-ACCESS-ALIASES.md`。

当用户表达以下意图时，默认先考虑这套链路：
- 读网页 / 读文章 / 提取正文 / 总结网页
- 去某网站找内容 / 找页面 / 找入口
- 在动态页面执行点击、搜索、展开、滚动、收集
- 针对已知网站复用已有经验

## 最小执行链

1. 运行 `route-task.mjs` 判断路线
2. 若命中站点，再运行 `match-site.mjs`
3. 选择执行层：
   - `extractor_first`
   - `browser_interactive`
   - `search_then_browser`
4. 执行完成后，如发现新规律：
   - 先用 `suggest-site-pattern.mjs` 生成候选内容
   - 再决定是否用 `add-site-pattern.mjs` 正式写入

## 设计原则

- 先分流，再执行
- 站点经验优先于泛化规则
- 低成本路径优先
- 动态页面优先真实浏览路径
- 经验沉淀为长期资产
