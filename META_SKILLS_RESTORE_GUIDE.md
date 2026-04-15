# META_SKILLS_RESTORE_GUIDE

生成时间：2026-04-15

## 一、目标

本指南用于把当前 Minis 元技能体系从 git 仓库恢复回 Minis 环境。

适用对象：
- `open-minis-project-bootstrapper`
- `open-minis-skill-lifecycle-manager`
- `open-minis-output-governor`
- `SKILL_SCORING_STANDARD.md`
- `SKILL_REVIEW_CHECKLIST.md`
- `META_SKILLS_INDEX.md`
- `META_SKILLS_REPORT.md`
- `META_SKILLS_FREEZE_NOTE.md`
- `META_SKILLS_EXECUTION_INDEX.md`
- `darwin-skill`

---

## 二、恢复前提

默认仓库：
- `https://github.com/joeshu/minis-skills.git`

默认分支：
- `master`

默认恢复位置：
- `/var/minis/skills`

---

## 三、最常见恢复方式

### 方式 A：全量恢复（适合新环境）

```sh
cd /var/minis
rm -rf skills
git clone https://github.com/joeshu/minis-skills.git skills
cd skills
git checkout master
```

适用：
- 新装 Minis
- 本地 `skills/` 丢失
- 需要从远端完整重建仓库

---

### 方式 B：增量更新（适合已有仓库）

```sh
cd /var/minis/skills
git checkout master
git pull origin master
```

适用：
- 本地仓库还在
- 只需要同步最新版本

---

### 方式 C：指定提交恢复

```sh
cd /var/minis/skills
git checkout <commit>
```

适用：
- 需要回看历史版本
- 需要定位某次高分/封板状态

说明：
- 若后续要回到主线，记得再切回 `master`

---

## 四、恢复后建议检查

恢复完成后，建议至少确认以下文件存在：

### 主技能
- `open-minis-project-bootstrapper/SKILL.md`
- `open-minis-skill-lifecycle-manager/SKILL.md`
- `open-minis-output-governor/SKILL.md`

### 规范层
- `SKILL_SCORING_STANDARD.md`
- `SKILL_REVIEW_CHECKLIST.md`

### 系统文档层
- `META_SKILLS_INDEX.md`
- `META_SKILLS_REPORT.md`
- `META_SKILLS_FREEZE_NOTE.md`
- `META_SKILLS_EXECUTION_INDEX.md`
- `META_SKILLS_RESTORE_GUIDE.md`

### 方法来源
- `darwin-skill/SKILL.md`

---

## 五、最小检查命令

```sh
cd /var/minis/skills && \
for f in \
  open-minis-project-bootstrapper/SKILL.md \
  open-minis-skill-lifecycle-manager/SKILL.md \
  open-minis-output-governor/SKILL.md \
  SKILL_SCORING_STANDARD.md \
  SKILL_REVIEW_CHECKLIST.md \
  META_SKILLS_INDEX.md \
  META_SKILLS_REPORT.md \
  META_SKILLS_FREEZE_NOTE.md \
  META_SKILLS_EXECUTION_INDEX.md \
  META_SKILLS_RESTORE_GUIDE.md \
  darwin-skill/SKILL.md
  do [ -f "$f" ] && echo OK:$f || echo MISS:$f; done
```

---

## 六、与记忆系统恢复的区别

元技能体系恢复相对更简单，因为：
- 这些文件本来就是 git 仓库资产
- 不涉及 `/var/minis/memory/` 的敏感原始数据
- 不需要先做脱敏导出再恢复

所以：
- **元技能体系**：直接 clone / pull 即可
- **记忆系统原始 memory**：仍应遵循脱敏镜像与专门恢复流程

---

## 七、建议使用方式

### 恢复后如果想继续使用元技能体系
推荐顺序：
1. 先看 `META_SKILLS_INDEX.md`
2. 再看 `META_SKILLS_REPORT.md`
3. 若已进入维护态，再看 `META_SKILLS_FREEZE_NOTE.md`
4. 如要补真实案例，再看 `META_SKILLS_EXECUTION_INDEX.md`

---

## 八、结论

这套元技能体系天然适合：
- 同步到 git
- 从 git 恢复回 Minis
- 在恢复后继续作为元治理主栈直接使用

换句话说：

# **它本身就是 git-first、恢复友好的 Minis 系统资产**
