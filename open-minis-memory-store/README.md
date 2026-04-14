# open-minis-memory-store

用于把某类事情或某个项目的分散记忆，整理成 **1 条主记忆**，并清理其他重复、过时、零散的相关记忆。

## 主要能力
- 全量检索某主题的相关记忆
- 合并为唯一主记忆
- 若主记忆已存在，则优先更新而不是重复新建
- 删除其他重复/过时记忆
- 删除前自动要求先备份 memory 文件
- 保留敏感信息拦截规则
- 通过关键词定位候选记忆块，降低误删风险
- 支持误删后的备份回滚
- 对主记忆有质量标准，避免写成流水账

## 内置辅助脚本
- `references/scan_memory_topic.sh`
- `references/build_master_memory.sh`
- `references/backup_memory_files.sh`
- `references/locate_memory_blocks.sh`

## 推荐流程
```text
扫描相关记忆
→ 生成主记忆草稿
→ 定位待删记忆块
→ 用户确认
→ 备份 memory 文件
→ 删除旧记忆
→ 写入或更新主记忆
```

## 关键约束
- `memory_write` 只能追加，不能删除
- 删除旧记忆必须通过读取 memory 文件后再精确编辑
- 删除前必须先备份
- 只做最小必要删除，避免因模糊关键词误删其他主题
- 主记忆应控制在高信息密度、低噪音的范围内
