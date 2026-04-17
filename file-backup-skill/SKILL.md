---
name: file-backup-skill
description: Create file or directory backups when the user explicitly asks for a rollback point, or when a high-risk operation such as delete, batch replace, refactor, migration, or key config change is about to happen. Use this skill for smart backup, latest-backup lookup, restore, restore-latest, and cleanup.
---

# file-backup-skill

一个用于**按需备份**的执行型技能。
- 普通低风险修改：默认不强制备份
- 用户明确要求或遇到关键节点：建议或执行备份

## 触发词
- 先备份一下
- 留个回滚点
- 删除前备份
- 批量改之前先备份
- 恢复最近一次备份
- 清理旧备份
- smart backup / restore latest / clean backups

## 输入
- 目标文件或目录路径
- 操作类型：普通修改 / 删除 / 批量替换 / 重构 / 迁移 / 恢复 / 清理
- 可选参数：窗口秒数、保留份数、恢复目标路径

## 输出
执行后至少返回：
1. 是否创建新备份，还是被跳过
2. 备份路径或恢复目标路径
3. 失败原因（如有）
4. 清理结果（如有）

### 执行输出规范
- 成功创建备份：明确返回备份路径
- 因限频或同内容跳过：明确说明跳过原因与可用备份路径
- 恢复成功：明确返回恢复目标路径
- 清理完成：明确返回保留份数与删除数量
- 失败：明确返回失败原因与下一步建议（如 `list` / `restore` / 显式目标路径）

## 风险分级
### L1：低风险
- 普通小改
- 文案微调
- 局部格式修正

默认：可直接修改，不强制备份。

### L2：中风险
- 单文件关键配置修改
- 单文件结构调整
- 用户明确要求保留回滚点

默认：建议使用 `smart <文件>`。

### L3：高风险
- 删除目录
- 批量替换多个关键文件
- 重构 / 迁移 / 重命名
- 清理旧备份
- 恢复将覆盖当前内容

默认：先确认，再执行 `dir` / 多次 `smart` / `clean` / `restore`。

## 风险评分模型
在判断是否备份前，先按证据计算 `risk_score`。

### 使用原则
- 风险评分是**内部决策机制**，不是给用户额外增加负担的界面。
- 默认情况下，**不向用户展开显示** `risk_score / risk_level / decision_reason`。
- 默认只输出对用户最有用的**短结论**：直接修改 / 建议备份 / 需要确认。
- 只有在以下情况才展开解释：
  1. 用户追问“为什么”
  2. 当前操作为高风险
  3. 需要用户确认
  4. 结论可能不符合用户直觉

### 加分项
- 删除单个文件：+2
- 删除目录：+4
- 批量替换多个文件：+3
- 重构 / 迁移 / 重命名：+3
- 修改关键配置：+3
- 用户明确要求保留回滚点：+2
- 当前路径下未发现可用最近备份：+2
- 恢复会覆盖现有内容：+2
- 清理旧备份：+2

### 减分项
- 已有最近可用备份：-2
- 当前改动可轻易重建：-1
- 只做普通文案/格式微调：-2
- 有额外 git 回滚点可辅助恢复：-1

### 分级阈值
- `0~2`：低风险
- `3~5`：中风险
- `6+`：高风险

### 内部决策字段
分析阶段优先形成这 4 个内部结论：
- `risk_score`
- `risk_level`
- `decision_reason`
- `recommended_action`

### 默认外部输出
- 低风险：`这是普通小改，可直接修改。`
- 中风险：`建议先做一次智能备份，再继续修改。`
- 高风险：`这是高风险操作，建议先备份。是否继续？`

### 外部响应模板
#### 低风险模板
- 结论：`这是普通小改，可直接修改。`
- 默认行为：直接进入修改，不追加长解释。

#### 中风险模板
- 结论：`建议先做一次智能备份，再继续修改。`
- 推荐动作：`建议使用 smart <文件>。`
- 默认行为：给建议，不强制确认。

#### 高风险模板
- 结论：`这是高风险操作，建议先备份。`
- 推荐动作：按场景选择 `dir` / `smart` / `clean` / `restore`。
- 确认问题：`是否继续？`
- 默认行为：先确认，再执行。

#### 失败模板
- 结论：`这一步执行失败。`
- 原因：只说最关键的一条失败原因。
- 下一步：给一个最直接的动作建议，例如：
  - `先用 list 检查可用备份。`
  - `请显式提供恢复目标路径。`
  - `如仍需强制新建备份，可改用 file。`

### 输出风格一致性规范
- 先给**一句短结论**，不要先展开长解释。
- 低风险默认只给结论，不追加评分细节。
- 中风险默认给“建议 + 下一步动作”，不强行确认。
- 高风险默认给“风险结论 + 建议动作 + 确认问题”。
- 只有在用户追问、需要确认、或结论不直观时，才展开 `decision_reason`。
- 若执行失败，先给失败结论，再给一个最直接的下一步建议。

### 按需解释输出
只有在需要展开时，再补充：
- 为什么判为高/中风险
- 为什么推荐当前命令
- 是否存在替代方案

## 关键节点
以下场景应主动建议备份：
1. 删除文件前
2. 删除目录前
3. 批量替换前
4. 重构前
5. 迁移/重命名前
6. 修改关键配置前
7. 发布/提交前

## 工作流

### 决策树
1. 先根据风险评分模型计算 `risk_score`。
2. 结合用户是否明确要求备份，得到 `risk_level`。
3. 输出 `decision_reason` 与 `recommended_action`。
4. 再进入 Phase 1 执行具体判断。

### Phase 1: 判断是否需要备份
1. 判断用户是否明确要求备份。
2. 若未明确要求，再判断当前操作风险等级。
3. 低风险：直接修改。
4. 中风险：默认建议 `smart <文件>`，必要时解释原因。
5. 高风险：先确认，再进入 Phase 2。

### Phase 2: 选择命令
| 场景 | 推荐命令 |
|---|---|
| 普通低风险修改 | 无需备份，直接修改 |
| 单文件关键节点 | `smart <文件>` |
| 明确要求立即生成一份备份 | `file <文件>` |
| 多个关键文件 | 对每个文件执行 `smart` |
| 整个目录重构/删除前 | `dir <目录>` |
| 查最近备份 | `latest <原路径>` |
| 恢复最近备份 | `restore-latest <原路径>` |
| 清理旧备份 | `clean <原路径> [保留份数]` |

### Phase 3: 执行与回退
1. 记录备份结果。
2. 再执行 `file_edit`、删除或其他修改。
3. 若出错：优先用 `restore` 或 `restore-latest` 回退。
4. 若批量任务部分失败：先汇报失败项，再决定是否继续。

## 成功标准
- 普通小改不会被错误要求先备份
- 关键节点会收到正确的备份建议或执行正确命令
- 高风险操作会触发确认
- 恢复/清理场景能给出明确下一步
- 内部能够形成 `risk_score / risk_level / decision_reason / recommended_action`
- 外部默认只给短结论，不把评分过程变成用户负担

## Fallback
- `smart` 因限频被跳过，但用户明确要求必须新建一份备份：改用 `file`
- `restore-latest` 找不到备份：先用 `list` 检查路径是否匹配
- 无法自动推断恢复目标：要求用户提供 `restore <备份路径> <目标路径>`
- 批量任务部分失败：先汇报失败清单，再决定是否继续
- 目录删除前若用户不想做快照：明确提示“无回滚点风险”后再继续

## 检查点
以下情况应先确认：
- 删除目录前
- 批量替换多个关键文件前
- 执行 `clean` 前
- `restore` 会覆盖现有文件时

### 确认模板
- 删除目录前：`这是目录删除操作，建议先做目录快照备份。是否继续？`
- 批量替换前：`这次会批量修改多个关键文件，是否先为全部目标创建可恢复备份？`
- 清理旧备份前：`将只保留最近 N 份备份，其余旧备份会删除。是否继续？`
- 恢复覆盖前：`恢复操作会覆盖当前文件内容。是否继续？`

若用户已明确表达“直接做”“继续”“就按这个来”，可直接执行。

## 真实可用命令
```sh
/var/minis/skills/file-backup-skill/scripts/backup.sh file <文件>
/var/minis/skills/file-backup-skill/scripts/backup.sh smart <文件> [窗口秒数] [保留份数]
/var/minis/skills/file-backup-skill/scripts/backup.sh batch <文件1> <文件2> ...
/var/minis/skills/file-backup-skill/scripts/backup.sh dir <目录>
/var/minis/skills/file-backup-skill/scripts/backup.sh list <原路径>
/var/minis/skills/file-backup-skill/scripts/backup.sh latest <原路径>
/var/minis/skills/file-backup-skill/scripts/backup.sh restore <备份路径> [恢复目标路径]
/var/minis/skills/file-backup-skill/scripts/backup.sh restore-latest <原路径>
/var/minis/skills/file-backup-skill/scripts/backup.sh clean <原路径> [保留份数]
```

## 默认策略
- `smart` 默认窗口：600 秒
- `smart` 默认保留：5 份
- 普通修改：不强制备份
- 关键节点：优先建议 `smart` 或 `dir`

## 边界条件
- 文件不存在：停止并报错
- 不是普通文件/目录：停止并报错
- 最近备份不存在：明确告知无法 `restore-latest`
- 无法自动推断恢复目标：要求用户显式提供目标路径
- 清理时保留份数大于现有数量：不报错
- 目录快照恢复会覆盖目标目录：先提醒用户

## 与 Minis 工具配合
- 新建文件：`file_write`
- 修改已有文件：按需决定是否先运行 `backup.sh`，再 `file_edit`
- 删除/批量替换/重构：优先评估是否属于关键节点
- git 可辅助回滚，但不能替代文件备份

## 禁止事项
- 把“所有修改都必须备份”写成硬规则
- 文档里写出脚本不支持的命令
- 默认全盘搜索或全盘备份
- 在高风险场景中跳过确认

## 测试要求
使用 `test-prompts.json` 做 2-3 个典型场景验证，至少覆盖：
1. 普通小改，不强制备份
2. 关键节点智能备份
3. 最近备份恢复或旧备份清理
4. 反例场景：不该建议备份时不要误报
5. 解释场景：只有用户追问时才展开原因

### 评估记录建议
每次 full test 至少记录：
- `prompt`
- `expected_action`
- `need_confirmation`
- `user_facing_style`
- `pass_criteria`
- `baseline_observation`
- `with_skill_observation`
- `final_judgement`
