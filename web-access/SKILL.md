# web-access（Minis 适配版）

> 总导航：见 `INDEX.md`

当用户要你访问网页、提取正文、浏览动态站点、查找页面入口、处理站点特定坑点时，使用这个 skill。

## 目标

把原版 `web-access` 的**联网策略 + 浏览哲学 + 站点经验机制**接入 Minis，避免把它误用成“固定脚本集合”或“必须依赖桌面 Chrome CDP 的插件”。

## 先理解，再执行

原版 skill 的核心原理：

1. **任务先分类**：搜索、读取、交互、站点特化
2. **工具按成本与可靠性选择**：低成本路径优先，高能力路径兜底
3. **浏览器自动化只在必要时启用**，不是所有网页都上重型自动化
4. **站点经验是长期复用资产**，比一次性 prompt 更重要
5. **像人一样浏览**：通过页面入口、上下文链接、已知规律来判断，而不是盲猜 URL 或机械点击

在 Minis 中，上述思想应映射为：

- **正文类网页** → 优先 `web-content-extractor`
- **一般网页读取** → `browser_use.get_readable` / `get_text`
- **动态交互/站内搜索/展开/分页/滚动** → `browser_use.navigate/click/type/scroll/...`
- **轻量验证/下载/接口探测** → `shell_execute` + curl/wget/python
- **站点特定坑点** → 先查 `references/site-patterns/*.md`
- **桌面 Chrome CDP** → 仅作为上游兼容思路，不是 Minis 默认主路径

## 快速路由

先运行：

```bash
node /var/minis/skills/web-access/scripts/route-task.mjs "<用户请求>"
```

再根据结果选择路径：

- `extractor_first`：正文/文章/摘要/网页主内容
- `browser_interactive`：点击、输入、展开、滚动、搜索、动态页面
- `search_then_browser`：先找入口/URL，再进入页面
- 同时命中站点时，再运行 `match-site.mjs` 读取站点经验

## 执行路由

### A. 用户要“读网页 / 提取正文 / 总结文章”
优先：
1. 使用 `web-content-extractor`（若场景合适）
2. 否则 `browser_use.navigate` + `get_readable`
3. 若页面结构特殊，再 `get_text` / `execute_js` / `screenshot`

不要一上来就走重交互自动化。

### B. 用户要“去网站里找内容 / 点击展开 / 搜索 / 登录后查看 / 动态页面操作”
优先：
1. `browser_use.navigate`
2. `wait_for_dom_stable`
3. `find_elements` / `get_backbone`
4. 再决定 `click`、`type`、`scroll`、`scroll_and_collect`
5. 必要时 `screenshot`

### C. 用户要“找某个以前访问过的网址 / 内部站点 / 公网难搜页面”
优先：
1. 先走普通搜索/直接访问
2. 若用户明确暗示“以前打开过但忘了”“内部系统”“浏览器里能找到”，再考虑 URL 检索思路
3. 若当前环境没有合适的本地浏览器历史可读来源，就说明限制，不强行执行

### D. 命中特定站点
先运行：

```bash
node /var/minis/skills/web-access/scripts/match-site.mjs "<用户请求>"
```

若匹配到站点经验：
- 先读经验，再执行
- 执行完成后，如发现新规律，可补充到对应域名 md 文件

## 已内置的站点经验

当前已提供示例/首批经验：
- `zhihu.com`
- `xiaohongshu.com`
- `mp.weixin.qq.com`
- `github.com`
- `weibo.com`
- `bilibili.com`
- `juejin.cn`
- `sspai.com`
- `x.com`
- `taobao.com`
- `jd.com`

后续可持续按域名补充。

## 统一入口约定

当用户表达以下网页意图时，默认优先考虑本 skill 的方法：
- 读文章/网页主内容
- 去某网站找内容或入口
- 做站内搜索、展开、滚动、收集
- 命中已知站点并复用经验

默认最小链路：
1. `route-task.mjs`
2. `match-site.mjs`（如命中站点）
3. 选择 `web-content-extractor` / `browser_use` / shell 辅助路径

## 重要技术事实

- 页面内导航生成的链接通常比手工拼 URL 更可靠
- 平台报错文案可能误导，问题常常是入口、上下文、鉴权链路或交互方式不对
- 动态页面的正文和可见文本不一定等于初始 HTML
- 成本优先：能抽正文就别全量浏览器自动化；能收集结构化 DOM 就别只靠截图 OCR

## 在 Minis 中的默认偏好

- **优先内置 `browser_use`，而不是外接 CDP Proxy**
- **优先可验证、低 token 成本的读取路径**
- **复杂页面才升级到更重的交互链路**
- **站点经验按域名沉淀，持续复用**

## 目录说明

- `references/site-patterns/`：站点经验
- `scripts/route-task.mjs`：网页任务路由器
- `scripts/match-site.mjs`：按用户请求匹配站点经验
- `scripts/find-url.mjs`：保留的 URL 检索兼容脚本
- `upstream/`：上游仓库快照，便于后续 diff

## 维护原则

- 保留上游设计哲学
- 执行层优先用 Minis 原生工具重写
- 不把桌面 Chrome 假设强塞到 iOS/Minis 环境
- 新增经验优先沉淀为站点模式，而不是只写在对话里
