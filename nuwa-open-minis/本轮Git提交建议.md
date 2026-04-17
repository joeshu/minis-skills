# 本轮 Git 提交建议（nuwa-open-minis）

## 一、建议提交范围
本轮建议提交 `nuwa-open-minis` 下以下变更：

### 主文件
- `SKILL.md`

### 人物型评估/回归体系
- `人物型样本回归优化清单.md`
- `人物型假像识别清单.md`
- `人物型总评估入口.md`
- `张一鸣案例-对女娲系统的最终增量总结.md`
- `第二人物样本验证建议.md`
- `第二人物样本验证总结-PaulGraham.md`
- `本轮可提交变更摘要.md`

### 脚本工具包
- `scripts/README-scripts.md`
- `scripts/merge_research_open_minis.py`
- `scripts/quality_check_open_minis.py`
- `scripts/srt_to_transcript.py`

---

## 二、建议提交信息

### 推荐提交信息（英文）
`enhance nuwa-open-minis with character evaluation loop, fake-pattern checks, second-sample validation, and utility scripts`

### 简洁版
`enhance nuwa-open-minis character workflow and scripts`

### 中文语义版
`增强 nuwa-open-minis：补人物型评估闭环、第二样本验证与最小脚本工具包`

---

## 三、提交说明可用摘要
本轮核心成果：
- 继续细化人物型高质量规则
- 补齐人物型样本回归优化清单
- 补齐人物型假像识别清单
- 新增人物型总评估入口
- 引入最小脚本工具包（研究汇总 / 质量检查 / 字幕清洗）
- 用张一鸣与 Paul Graham 两个风格明显不同的人物样本完成真实回归验证
- 同时修正 `quality_check_open_minis.py` 的人物锚点检测样本偏置

---

## 四、提交前建议动作
建议提交前至少再确认：
1. `quality_check_open_minis.py` 可运行
2. `scripts/README-scripts.md` 与脚本实现一致
3. 第二人物样本验证总结已纳入提交范围
4. 若不想提交 workspace 样本文件，可只提交 `nuwa-open-minis` 系统本体与文档/脚本
