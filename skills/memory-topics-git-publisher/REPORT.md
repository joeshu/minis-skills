# REPORT

## 目标
- 将 `/var/minis/shared/memory_topics/` 下的当前回答风格 / 检索治理体系，以单独目录形式镜像到 `joeshu/minis-skills` 仓库，并支持恢复到本机。

## 设计原则
- 只同步目标体系相关文件
- 默认包含 `GLOBAL.md` 镜像
- 先 check，再 sync，再 push
- 恢复前先 restore-check，再 restore-sync
- 恢复时先备份本机再覆盖
- 不处理真实 daily memory

## 当前状态
- 已具备 SKILL / README / tests / execution samples / 同步与恢复脚本
- 已支持发布与恢复双向闭环

## 风险边界
- 仓库未挂载时不假装可推
- 检测到敏感内容时停止 push
- 只 add 目标子目录，不扩大提交范围
- 恢复前默认先做本机备份
