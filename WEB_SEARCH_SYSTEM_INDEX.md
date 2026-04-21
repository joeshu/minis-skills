# WEB_SEARCH_SYSTEM_INDEX

生成时间：2026-04-16

用途：作为 Minis 合规版网页搜索 / 内容采集系统的总入口，帮助快速判断：
- 什么时候先做联网搜索
- 什么时候该提取网页正文
- 什么时候要补第二来源
- 什么时候应把结果落盘成 Markdown / HTML / 报告

---

## 一、这套系统解决什么问题

当你需要：
- 搜索最新网页信息
- 找官网 / 原文 / 文档入口
- 提取网页正文
- 对多个来源做比对
- 把搜索结果与提取内容落盘复用

就应该优先看这套系统。

这套系统强调：
- **合规获取公开网页内容**
- **多来源交叉验证**
- **搜索与提取分工清楚**
- **结果能落盘继续使用**

---

## 二、核心组件地图

| 技能 / 文档 | 作用 | 适用时机 |
|---|---|---|
| `web-search/` | 多搜索引擎联网搜索、fallback、第二来源验证 | 先找结果、找官网、查最新信息时 |
| `web-content-extractor/` | 抽取网页正文、清洗成 Markdown | 已有明确 URL，需要正文内容时 |
| `open-minis-output-governor/` | 决定结果该聊天输出、落 Markdown、做 HTML 或写 shared/workspace | 搜索或提取完成后要整理成产物时 |

---

## 三、最常见使用路线

### Route A：先搜索，再给结论
1. `web-search/`
2. 输出短结论 + 来源

### Route B：先搜索，再提取正文
1. `web-search/`
2. 命中官网 / 原文 / 目标 URL
3. `web-content-extractor/`
4. 输出清洗后的正文或摘要

### Route C：搜索 + 多来源验证 + 落盘
1. `web-search/`
2. 补第二来源交叉验证
3. `web-content-extractor/`（如需正文）
4. `open-minis-output-governor/`
5. 结果写入 Markdown / HTML / shared

### Route D：已有 URL，只想抽正文
1. `web-content-extractor/`
2. 必要时再用 `open-minis-output-governor/` 落盘

---

## 四、怎么选

### 你在“先找网页/官网/来源”
用：`web-search/`

### 你在“已经有 URL，只想抽正文”
用：`web-content-extractor/`

### 你在“搜索结果要变成可交付产物”
加上：`open-minis-output-governor/`

---

## 五、推荐执行顺序（极简版）

### 一般网页搜索
web-search → 结论 + 来源

### 搜索后提取正文
web-search → web-content-extractor

### 搜索后做资料产物
web-search → web-content-extractor → output-governor

---

## 六、当前成熟度（基础组件） 

| 对象 | 当前成熟度 |
|---|---:|
| `web-search` | 96.4 |
| `web-content-extractor` | 待系统化评估 |

当前判断：
**这条系统线已具备基础能力，但系统文档层刚建立，后续应继续补执行样本、系统报告与边界约束。**

---

## 七、一句话结论

- **先搜来源** → `web-search/`
- **再抽正文** → `web-content-extractor/`
- **再落盘成产物** → `open-minis-output-governor/`
