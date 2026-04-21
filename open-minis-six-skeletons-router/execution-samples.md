# execution-samples

## Sample 1：跨会话继续
**用户输入**：继续上次项目并整理交接。

**预期路由**：
- task_level: 重
- routed_system: handoff
- chain: plan -> implement -> review -> receipt
- receipt_expected: true

**期望行为**：
- 先读取 handoff / cross-session 入口
- 明确这是跨会话恢复，不直接裸执行
- 输出以交接恢复为主，而不是直接进入普通实现

---

## Sample 2：记忆系统治理
**用户输入**：审计一下当前记忆系统。

**预期路由**：
- task_level: 重
- routed_system: memory-system-maintainer
- chain: plan -> implement -> review -> receipt
- receipt_expected: true

**期望行为**：
- 先挂维护器而不是把普通 memory_get 当成全部动作
- 区分“日常单条记忆”与“系统治理/审计”
- 审计结果应带验证结论

---

## Sample 3：新项目骨架
**用户输入**：新建一个系统项目骨架。

**预期路由**：
- task_level: 重
- routed_system: project-bootstrapper
- chain: plan -> implement -> review -> receipt
- receipt_expected: true

**期望行为**：
- 命中 project bootstrap，而不是只回答原则
- 输出最小可执行骨架、目录或落地文件
- 保留后续 review / receipt 闭环

---

## Sample 4：普通轻任务
**用户输入**：把这段命令解释一下。

**预期路由**：
- task_level: 轻
- routed_system: direct
- chain: implement
- receipt_expected: false

**期望行为**：
- 不要过度流程化
- 不强行挂 review / receipt
- 直接给最短可用解释
