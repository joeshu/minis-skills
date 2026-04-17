# memory-system-maintainer

用途：维护整套 Minis 记忆系统，把写入审查、分层治理、专题路由、审计与归并串起来。

## 默认顺序
1. 写入前先审查
2. 再判断写入层级
3. 读取时专题优先
4. 清理前先审计
5. 归并时再动旧记忆

## 子技能分工
- `memory-write-gatekeeper`：该不该写
- `memory-layer-governor`：写到哪层
- `memory-topic-router`：先读哪层
- `memory-dedup-auditor`：先审计再清理
- `open-minis-memory-store`：归并旧记忆

## 复合问题处理
- 新规则进入系统：先 gatekeeper，再 layer-governor
- 主题记忆变乱：先 auditor，再 memory-store
- 继续某项目：先 topic-router，再按需补查其他层
- 全局维护：先审计，再按问题类型分发子技能

## 默认输出
- 当前问题类型
- 建议先用哪个子技能
- 如需组合，给最短执行顺序
