#!/usr/bin/env python3
from pathlib import Path
import json

BASE = Path('/var/minis')

cases = [
    {
        'id': 'write_flow',
        'prompt': '帮我记住这条新规则，但先判断它值不值得进长期记忆。',
        'expected_order': ['memory-write-gatekeeper', 'memory-layer-governor'],
        'reason': '写入类默认强制入口应先审查再分层',
    },
    {
        'id': 'read_flow',
        'prompt': '继续这个项目，先按过去约定来，先帮我查对专题记忆。',
        'expected_order': ['memory-topic-router'],
        'reason': '读取类应先走专题优先路由',
    },
    {
        'id': 'audit_store_flow',
        'prompt': '先把重复和冲突查出来，确认后再归并旧记忆。',
        'expected_order': ['memory-dedup-auditor', 'open-minis-memory-store'],
        'reason': '清理类应先审计再归并',
    },
    {
        'id': 'global_maintenance_flow',
        'prompt': '我想把整个记忆系统整理顺一点，你按合适顺序帮我处理。',
        'expected_order': ['memory-system-maintainer', 'memory-dedup-auditor'],
        'reason': '全局治理先由总管编排，再分发具体治理动作',
    },
    {
        'id': 'handoff_flow',
        'prompt': '我想做一个完整的前中后闭环：开始先查记忆，中间按需记，结束后再交接。',
        'expected_order': ['memory-topic-router', 'memory-layer-governor', 'session-context-compactor'],
        'reason': '完整 handoff 链路应覆盖开始前检索、中途分层、结束后压缩交接',
    },
    {
        'id': 'delete_guardrail_flow',
        'prompt': '我做完这轮后要删掉历史会话，你先把后续继续需要的东西整理好。',
        'expected_order': ['session-context-compactor'],
        'must_include': ['先生成摘要', '先列必要文件', '删除前确认'],
        'reason': '删除历史前必须先过摘要与必要文件护栏',
    },
]

required_paths = [
    BASE / 'skills' / 'memory-write-gatekeeper' / 'SKILL.md',
    BASE / 'skills' / 'memory-layer-governor' / 'SKILL.md',
    BASE / 'skills' / 'memory-topic-router' / 'SKILL.md',
    BASE / 'skills' / 'memory-dedup-auditor' / 'SKILL.md',
    BASE / 'skills' / 'open-minis-memory-store' / 'SKILL.md',
    BASE / 'skills' / 'memory-system-maintainer' / 'SKILL.md',
    BASE / 'skills' / 'open-minis-handoff-orchestrator' / 'SKILL.md',
    BASE / 'skills' / 'session-context-compactor' / 'SKILL.md',
    BASE / 'skills' / 'memory-system-maintainer' / 'audit_memory_system.py',
    BASE / 'skills' / 'memory-system-maintainer' / 'full_memory_system_check.py',
]

missing = [str(p) for p in required_paths if not p.exists()]
status = 'ok' if not missing else 'needs_attention'

report = {
    'status': status,
    'missing_required_paths': missing,
    'cases': cases,
    'summary': {
        'case_count': len(cases),
        'covers_write': True,
        'covers_read': True,
        'covers_audit_store': True,
        'covers_global_maintenance': True,
        'covers_handoff': True,
        'covers_delete_guardrail': True,
    }
}

print(json.dumps(report, ensure_ascii=False, indent=2))
