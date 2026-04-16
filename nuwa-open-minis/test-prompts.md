# test-prompts

## T1 直接生成测试
```markdown
造一个「XX Skill」。
请直接输出最终可用版 SKILL.md 全文。
不要解释过程，不要只给框架。
先落地到文件，再继续输出正文。
如果一次输出不完，请分段继续。
```

## T2 先调研再生成测试
```markdown
蒸馏一个「XX Skill」，先给我 research-summary，再生成完整 SKILL.md。
```

## T3 更新已有 Skill 测试
```markdown
基于新材料更新这个 Skill，不要从零重写。请直接输出更新后的完整 SKILL.md，并告诉我更新了哪些模块。
```

## T4 完整技能包测试
```markdown
造一个「XX Skill」，并做成完整技能包。除 SKILL.md 外，再补 README.md、REPORT.md、test-prompts.md。
```

## T5 失败回退测试
```markdown
如果当前信息不足，请先落地一版可审稿 SKILL.md，并把缺口写进能力边界。不要只解释原因。
```

## 观察点
测试时重点看：
1. 是否真实创建目录与文件
2. 是否优先产出而不是解释
3. 是否能在长文本时分段继续
4. 更新模式是否增量而非重写
5. 配套文件是否与 `SKILL.md` 一致
