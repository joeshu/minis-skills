# web-access（Minis 适配版）

> 总导航：见 `INDEX.md`

一个把原版 `eze-is/web-access` 的核心思想接入 Minis 的本地 skill。

## 这不是生硬移植

原版 web-access 的核心并不是某几个脚本，而是三层结构：

1. **联网策略选择**：按任务在搜索、抽取、浏览器自动化之间切换
2. **真实浏览器接管**：必要时接管用户已登录浏览器处理动态页面与交互
3. **站点经验沉淀**：把特定网站的 URL 规律、坑点、交互路径沉淀下来复用

在 Minis 里，默认执行层应改为：

- **优先：`browser_use`** 处理页面打开、点击、输入、滚动、正文抽取、截图
- **优先：`web-content-extractor`** 处理文章正文型网页
- **可选：shell/curl** 处理轻量抓取、接口验证、结构化输出
- **降级兼容：原版 Node 脚本** 仅保留“站点经验匹配”“本地浏览器历史/书签检索”等可复用部分
- **不默认依赖：Chrome CDP Proxy**，因为 Minis 已有原生内置浏览器控制能力，且当前环境通常不是桌面 Chrome 工作流

所以本 skill 采用 **“保留原哲学，重写执行层”** 的适配方式。

## 核心工作逻辑

### 1. 先判断任务类型，再选通道

推荐先跑本地路由器：

```bash
node /var/minis/skills/web-access/scripts/route-task.mjs "<用户请求>"
```

- **找网址 / 找官网 / 找最新信息**
  - 先搜索或直接访问
  - 若目标可能是用户曾访问过但公网不好搜到的地址，再考虑历史/书签检索思路

- **读文章 / 提取正文 / 抓主要内容**
  - 优先正文抽取路径
  - 不先走重浏览器自动化

- **动态页面 / 登录态 / 需要点击展开 / 无限滚动 / 站内搜索 / 交互表单**
  - 优先 `browser_use`
  - 需要时组合截图、DOM 文本、JS 执行、滚动收集

- **复杂站点 / 反爬 / 有已知坑点**
  - 先查 `references/site-patterns/*.md`
  - 按经验执行，执行后可继续沉淀经验

### 2. 像人一样浏览，而不是机械套模板

关键原则：

- 页面自己生成的链接通常比手工猜 URL 更可靠
- 平台提示“内容不存在/无权限”不一定是真的，也可能是入口错了、上下文缺了、脚本未触发
- 对动态站点，先观察页面结构，再决定点击/滚动/抽取方式
- 成本更低的路径优先：能正文抽取就不整页自动化，能读可读文本就不必反复截图

### 3. 站点经验是长期资产

按域名保存经验，记录：

- aliases
- 页面入口规律
- 登录/跳转特征
- DOM 结构提示
- 常见失败模式
- 推荐工具路径（extractor / browser / shell）

## Minis 环境中的推荐路由

### 路由 A：正文/资讯型网页
1. 直接使用 `web-content-extractor`
2. 若失败，再用 `browser_use.get_readable` / `get_text`
3. 必要时 shell/curl 辅助

### 路由 B：动态交互网页
1. `browser_use.navigate`
2. `wait_for_dom_stable`
3. `find_elements` / `get_backbone` / `get_text`
4. `click` / `type` / `scroll` / `scroll_and_collect`
5. 必要时 `screenshot`

### 路由 C：目标网址难找
1. 常规搜索/导航
2. 若明显是“用户自己访问过的站点”或“公网难搜系统”，再考虑本地历史/书签检索思路
3. 在 Minis/iOS 中，这一步通常是可选增强，不是默认主路

## 已内置的本地资产

- `SKILL.md`：适配后的方法论与执行规则
- `references/site-patterns/`：站点经验目录
- `scripts/route-task.mjs`：任务路由脚本
- `scripts/match-site.mjs`：根据用户提问匹配站点经验
- `scripts/find-url.mjs`：从桌面 Chrome 历史/书签找 URL（保留为兼容脚本；在 iOS Minis 中通常不作为默认手段）
- `upstream/`：保留原仓库快照，便于后续对照更新

## 当前内置站点经验

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

## 统一入口约定

从现在起，这个 skill 可视为 Minis 里的默认网页任务入口之一。凡是以下意图，优先按 `web-access` 的路由思想处理：

- 读网页 / 总结文章 / 提取正文
- 去某站点找内容 / 找入口 / 搜索页面
- 在动态页面中点击、展开、滚动、收集
- 命中特定站点时复用既有经验

执行时默认顺序：
1. `route-task.mjs` 判断路线
2. `match-site.mjs` 判断是否命中站点经验
3. 再决定走 extractor / browser_use / shell 辅助

## 适用场景

- “帮我读这个网页/提取正文/总结”
- “帮我去这个网站找某个页面/入口”
- “帮我在动态站点里点击、展开、搜索、收集内容”
- “这个站点之前踩过坑，按经验来”

## 不适用场景

- 需要桌面 Chrome 登录态、且只能通过 CDP 访问的场景
- 必须操作系统级文件选择框或真实桌面浏览器窗口的场景

这类场景在 Minis 中应改走：

- 原生 `browser_use`
- 或让用户明确打开外部系统/终端进行交互

## 安装结果

本 skill 安装路径：`/var/minis/skills/web-access`

原仓库快照：`/var/minis/skills/web-access/upstream`
