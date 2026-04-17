# execution-samples

## 样例 1：直接生成完整 Skill
### 输入
```markdown
造一个「地市联通公众线材料助手 Skill」。
请直接输出最终可用版 SKILL.md 全文。
不要解释过程，不要只给框架。
先落地到文件，再继续输出正文。
如果一次输出不完，请分段继续。
```

### 期望执行闭环
1. 创建目录
2. 写入 `SKILL.md`
3. 返回文件路径
4. 输出正文或分段正文

---

## 样例 2：完整技能包生成
### 输入
```markdown
造一个「地市联通存量运营助手 Skill」，并做成完整技能包。
请生成 SKILL.md、README.md、REPORT.md、test-prompts.md。
```

### 期望输出
- `SKILL.md`
- `README.md`
- `REPORT.md`
- `test-prompts.md`

---

## 样例 3：更新已有 Skill
### 输入
```markdown
基于这批新材料，更新现有 Skill 的存量运营和对上汇报模块。
不要从零重写，直接增量更新。
```

### 期望输出
- 读取已有 `SKILL.md`
- 识别受影响模块
- 回写文件
- 告知更新点

---

## 样例 4：信息不足的回退
### 输入
```markdown
蒸馏一个 XX Skill，但我手头材料很少。
```

### 期望输出
- 先生成可审稿 `SKILL.md`
- 明确写出边界和缺口
- 不因信息不足而拒绝生成
