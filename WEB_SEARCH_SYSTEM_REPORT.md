# WEB_SEARCH_SYSTEM_REPORT

生成时间：2026-04-16

## 一、报告目标

本报告用于总结当前 Minis 合规版网页搜索 / 内容采集系统的建设起点，明确：
- 这套系统解决什么问题
- 由哪些核心技能组成
- 各组件之间如何分工
- 典型使用路线是什么
- 当前成熟度到什么程度
- 后续应如何继续补强

---

## 二、系统目标

这套系统面向的不是单个搜索动作，而是：
- 搜索公开网页信息
- 找官网 / 原始页面 / 文档入口
- 抽取网页正文
- 做多来源交叉验证
- 把搜索与提取结果变成可继续使用的产物

一句话概括：

> **把“先找到、再读懂、再验证、再落盘”收口成一条稳定的网页内容获取链路。**

---

## 三、核心组成

### 1. `web-search`
作用：
- 多引擎搜索
- fallback
- 第二来源交叉验证
- 官网 / 中文 / 实时 / 开发文档等意图路由

当前成熟度：**96.4 / 100**

### 2. `web-content-extractor`
作用：
- 把目标网页正文清洗成 Markdown
- 适合抽取文章 / 文档 / 页面主内容

当前状态：**基础可用，但尚未系统化评估**

### 3. `open-minis-output-governor`
作用：
- 决定搜索 / 提取结果如何输出与落盘
- 可输出为聊天结论、Markdown、HTML、shared 文件等

当前成熟度：**99.3 / 100**

---

## 四、系统分工

- `web-search`：负责**找来源、找入口、做多来源验证**
- `web-content-extractor`：负责**拿到目标 URL 后抽正文**
- `open-minis-output-governor`：负责**把结果整理成用户真正可继续使用的产物**

这意味着：
- `web-search` 偏向“找与判定”
- `web-content-extractor` 偏向“读与提取”
- `output-governor` 偏向“交付与落盘”

---

## 五、典型使用路线

### Route A：找结论
1. `web-search`
2. 返回结论 + 来源

### Route B：找原文并提取正文
1. `web-search`
2. 命中原始页面
3. `web-content-extractor`

### Route C：做资料产物
1. `web-search`
2. 第二来源验证
3. `web-content-extractor`
4. `open-minis-output-governor`

### Route D：已有 URL 直接抽正文
1. `web-content-extractor`
2. 必要时再落盘成 Markdown / HTML

---

## 六、当前成熟度判断

### 结论
当前这套网页搜索 / 内容采集系统处于：

# **起步成型阶段**

定位：
**已有成熟搜索组件与可用正文提取组件，但系统文档层与执行样本层刚开始建立。**

### 依据
- `web-search` 已有高质量搜索策略与评分报告
- `web-content-extractor` 已具基础提取能力
- 与 `open-minis-output-governor` 的组合已经清楚
- 但目前还缺少：
  - 系统级 execution index
  - 系统级 freeze note
  - 提取组件正式评分
  - 搜索 + 提取联动的真实样本

---

## 七、下一步最值得做什么

1. 给 `web-content-extractor` 做系统化评估与收口
2. 补 `WEB_SEARCH_SYSTEM_EXECUTION_INDEX.md`
3. 补真实“搜索 → 提取 → 落盘”样本
4. 视情况再补系统封板说明

---

## 八、结论

到目前为止，Minis 已经具备网页搜索 / 内容采集系统的基础主链：
- `web-search`
- `web-content-extractor`
- `open-minis-output-governor`

它的意义在于：

> **以后不仅能搜到东西，还能把网页内容提取、验证、整理成可继续使用的产物。**
