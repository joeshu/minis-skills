# meta-skills-git-sync

用途：安全地把 Minis 元技能体系同步到 git，并支持一键恢复回 Minis。

## 模式
- `check`：只检查同步范围和风险
- `push`：限定范围提交并推送
- `restore`：输出一键恢复顺序与命令模板

## 默认原则
- 只同步元技能体系相关内容
- 默认排除无关技能改动与临时文件
- 默认从 `https://github.com/joeshu/minis-skills.git` 的 `master` 分支恢复

## 恢复原则
- 元技能体系本身是 git-first 资产
- 全量恢复：clone 仓库到 `/var/minis/skills`
- 增量恢复：在现有仓库里 `git pull origin master`
