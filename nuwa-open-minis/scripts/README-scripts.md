# README-scripts

> `nuwa-open-minis/scripts/` 最小工具包使用说明。

---

## 一、工具列表

### 1. `merge_research_open_minis.py`
**作用**：汇总人物型 skill 的 research 目录，查看研究完整度。

**用法**：
```bash
python3 /var/minis/skills/nuwa-open-minis/scripts/merge_research_open_minis.py <skill目录路径>
```

**示例**：
```bash
python3 /var/minis/skills/nuwa-open-minis/scripts/merge_research_open_minis.py /var/minis/skills/zhang-yiming-perspective-open-minis
```

**适用时机**：
- research 文件刚补完后
- 想判断 01-06 六个维度是否缺失时
- 准备进入人物型高强度蒸馏前

---

### 2. `quality_check_open_minis.py`
**作用**：检查人物型 `SKILL.md` 是否达到较高质量样本标准。

**用法**：
```bash
python3 /var/minis/skills/nuwa-open-minis/scripts/quality_check_open_minis.py <SKILL.md路径>
```

**示例**：
```bash
python3 /var/minis/skills/nuwa-open-minis/scripts/quality_check_open_minis.py /var/minis/skills/zhang-yiming-perspective-open-minis/SKILL.md
```

**检查项**：
- 主文件研究压强
- 人物锚点
- 表达DNA微动作层
- 典型问题开口
- 张力主骨架
- 假像风险

**适用时机**：
- 生成人物型 `SKILL.md` 后
- 封板前
- 并排评审前后做回归检查

---

### 3. `srt_to_transcript.py`
**作用**：把访谈/演讲字幕清洗成 transcript，便于喂入 research 文件。

**用法**：
```bash
python3 /var/minis/skills/nuwa-open-minis/scripts/srt_to_transcript.py <input.srt|input.vtt> [output.txt]
```

**示例**：
```bash
python3 /var/minis/skills/nuwa-open-minis/scripts/srt_to_transcript.py ./interview.srt
```

**适用时机**：
- 拿到 YouTube / 播客 / 演讲字幕后
- 准备把访谈材料喂给 `02-conversations.md`

---

## 二、推荐使用顺序

### 场景 A：从视频/访谈材料做人物研究
1. 先拿到字幕文件（.srt / .vtt）
2. 用 `srt_to_transcript.py` 清洗成 transcript
3. 把结果整理进 `references/research/02-conversations.md`
4. 用 `merge_research_open_minis.py` 检查 research 完整度

### 场景 B：人物型 `SKILL.md` 初稿完成后
1. 先用 `quality_check_open_minis.py` 跑一遍
2. 若不过关，再优先修：
   - 主文件研究压强
   - 人物锚点
   - 典型问题开口
   - 张力主骨架

### 场景 C：封板前
1. 先跑 `quality_check_open_minis.py`
2. 再结合：
   - `人物型假像识别清单.md`
   - `人物型样本回归优化清单.md`
   做最终判断

---

## 三、使用原则
- 工具是辅助，不替代判断
- 脚本结果不能代替并排评审
- 质量检查通过 ≠ 一定达到原版压强，只表示已进入较高质量区间
- 如果真实样本暴露出新问题，应优先回写规则，而不是盲信脚本通过结果

---

## 四、给女娲的工作口径
对于人物型任务：
- **先做人，再做表**：先保证人物立住，再看脚本指标
- **先修主文件，再修附录**：脚本只是提醒，不能让主文件失去人物感
- **先真实回归，再抽象扩规**：脚本输出应服务于真实样本回归，而不是替代它
