# session-context-compactor

用于把当前长会话压缩成一份后续可继续执行的精简摘要，并在用户允许时删除历史会话，只保留必要文件与执行摘要。

## 双模式
- **模式 A：仅整理摘要**
- **模式 B：整理摘要 + 删除历史会话**

## 核心规则
- 先生成摘要，再删除历史会话
- 必要文件必须保留
- 删除前必须确认
- 若已有旧摘要，优先更新 latest，不重复制造摘要噪音
- **跨会话默认优先写入 `/var/minis/shared/`**
- 不要默认依赖 `/var/minis/workspace/` 作为新会话 handoff 入口
- 删完后以后续共享摘要 + 文件继续执行

## 推荐目录
- `/var/minis/shared/session-handoffs/<topic>/`
- `/var/minis/shared/<topic>/session-handoffs/`
- `/var/minis/workspace/session-handoffs/<topic>/`（仅当前会话临时调试）

## 辅助脚本
- `references/write_session_summary.sh`
- `references/list_required_files.sh`
- `references/build_handoff_template.sh`
- `references/score_summary_quality.sh`
- `references/rank_required_files.sh`
- `references/write_versioned_summary.sh`
- `references/write_versioned_handoff.sh`
