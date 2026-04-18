# 记忆系统全量运行与链路模拟报告

时间：2026-04-18

## 一、结论
当前记忆系统全量结构检查与关键链路模拟结果均为 `ok`。

## 二、本轮执行内容
1. 运行轻量检查脚本：`audit_memory_system.py`
2. 运行全量检查脚本：`full_memory_system_check.py`
3. 运行链路模拟脚本：`simulate_memory_workflows.py`
4. 修复本轮发现的 shared ↔ repo 镜像漂移

## 三、结构检查结果
- 核心记忆技能目录齐全
- 核心技能关键文件齐全：`SKILL.md` / `README.md` / `test-prompts.json`
- 关键 shared docs 齐全
- 关键 memory_topics 齐全
- 审计脚本齐全：`audit_memory_system.py` / `full_memory_system_check.py`
- 当前 shared ↔ repo 关键镜像无漂移

## 四、链路模拟覆盖
本轮链路模拟覆盖 6 条关键治理链：
1. 写入链：`memory-write-gatekeeper -> memory-layer-governor`
2. 检索链：`memory-topic-router`
3. 审计归并链：`memory-dedup-auditor -> open-minis-memory-store`
4. 全局维护链：`memory-system-maintainer -> memory-dedup-auditor`
5. 前中后 handoff 链：`memory-topic-router -> memory-layer-governor -> session-context-compactor`
6. 删除前护栏链：先摘要、先列必要文件、删除前确认

## 五、本轮修复
- 修复 1 处专题镜像漂移：`/var/minis/shared/memory_topics/README.md` 与 repo 镜像不一致
- 已同步到：`/var/minis/shared/minis-skills/docs/memory-topics/README.md`

## 六、当前判断
当前已没有发现会导致整套记忆系统明显失效的结构性缺口。
现阶段主要风险不再是“文件缺失”，而是未来运行态 shared 与 repo 镜像再次漂移；对此已通过轻量检查 + 全量复测脚本降低风险。

## 七、统一检查入口
已新增统一入口：`/var/minis/skills/memory-system-maintainer/memory_system_check.py`

推荐用法：
- 轻量检查：`python3 /var/minis/skills/memory-system-maintainer/memory_system_check.py --light`
- 轻量检查并修复 shared 缺口：`python3 /var/minis/skills/memory-system-maintainer/memory_system_check.py --light --repair`
- 全量结构检查：`python3 /var/minis/skills/memory-system-maintainer/memory_system_check.py --full`
- 链路模拟：`python3 /var/minis/skills/memory-system-maintainer/memory_system_check.py --simulate`
- 一次性全跑：`python3 /var/minis/skills/memory-system-maintainer/memory_system_check.py --all`

## 八、建议执行策略
- 日常：仅在异常或维护时跑 `memory_system_check.py --light`
- 全量：仅在系统级复测、发布前、或怀疑漂移时跑 `memory_system_check.py --full` 或 `--all`
- 若以后再发现链路异常，优先先跑检查，再判断是否真是技能逻辑问题
