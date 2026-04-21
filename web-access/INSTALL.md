# web-access 安装说明（Minis）

## 已完成的适配

- 已将上游仓库安装到本地 skill 目录：`/var/minis/skills/web-access`
- 已重写 `SKILL.md`，使其符合 Minis 的工具栈
- 已保留上游快照到 `upstream/`，便于后续同步更新
- 已把 `match-site.mjs` / `find-url.mjs` 作为辅助脚本保留
- 已建立 `references/site-patterns/` 站点经验目录
- 已新增 `route-task.mjs` 作为网页任务分流入口
- 已新增 `add-site-pattern.mjs` 作为站点经验回填工具
- 已新增 `suggest-site-pattern.mjs` 作为经验候选生成工具
- 已新增 `WEB-ACCESS-ENTRY.md` 作为统一入口说明
- 已补 `test-prompts.json` / `execution-samples.md` / `REPORT.md`

## 与上游的关键差异

上游默认假设：
- Agent 能通过 `SKILL.md` 自动注入 Claude Code / Cursor / Codex 类环境
- 可使用桌面 Chrome 的远程调试能力（CDP）

Minis 适配后默认假设：
- 主执行器是内置 `browser_use`
- 网页正文抽取优先走轻量路径
- 仅将上游脚本作为兼容资产，不把 CDP 设为主能力

## 验证

运行：

```bash
node /var/minis/skills/web-access/scripts/verify-install.mjs
```

运行任务路由示例：

```bash
node /var/minis/skills/web-access/scripts/route-task.mjs "帮我总结这篇微信公众号文章"
```

运行站点经验匹配示例：

```bash
node /var/minis/skills/web-access/scripts/match-site.mjs "帮我看看知乎上的某个回答"
```

运行经验候选生成示例：

```bash
node /var/minis/skills/web-access/scripts/suggest-site-pattern.mjs example.com "详情页正文需要先点击展开"
```

运行经验回填示例：

```bash
node /var/minis/skills/web-access/scripts/add-site-pattern.mjs example.com "详情页正文需要先点击展开"
```

## 当前目录闭环

- `SKILL.md`：技能主入口
- `README.md`：设计说明
- `INDEX.md`：总导航
- `INSTALL.md`：安装与验证说明
- `REPORT.md`：最终评估报告
- `WEB-ACCESS-ENTRY.md`：统一入口说明
- `WEB-ACCESS-ALIASES.md`：统一调用别名协议
- `test-prompts.json`：测试样例
- `execution-samples.md`：执行样例
- `references/site-patterns/`：站点经验库
- `scripts/*.mjs`：路由 / 匹配 / 候选生成 / 候选合并 / 候选发布 / 回填 / 验证脚本

## 后续建议

如果继续增强，可优先做：

1. 补更多 `site-patterns/*.md`
2. 为常见站点增加专用执行模板
3. 让执行后的新经验自动生成候选 patch，半自动回填模式库
