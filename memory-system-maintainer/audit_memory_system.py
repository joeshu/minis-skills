#!/usr/bin/env python3
from pathlib import Path
import json
import shutil
import sys

BASE = Path('/var/minis')
repo = BASE / 'shared' / 'minis-skills'
repo_docs = repo / 'docs' / 'memory-system'
shared_docs = BASE / 'shared' / 'docs' / 'memory-system'
shared_topics = BASE / 'shared' / 'memory_topics'
skills_dir = BASE / 'skills'

MODE = 'check'
if '--repair' in sys.argv:
    MODE = 'repair'

# 只保留少量高价值入口，避免高频检查成本过高
required_shared_docs = [
    'memory-subsystems-responsibility-matrix.md',
    'memory-system-final-maturity-report.md',
]
required_topics = [
    'TopicIndex.md',
    'memory-maintenance.md',
]
required_skills = [
    'memory-topic-router',
    'memory-write-gatekeeper',
    'memory-layer-governor',
    'memory-dedup-auditor',
    'open-minis-memory-store',
    'memory-system-maintainer',
]

report = {
    'mode': MODE,
    'repo_exists': repo.exists(),
    'shared_docs_exists': shared_docs.exists(),
    'shared_topics_exists': shared_topics.exists(),
    'missing_shared_docs': [],
    'missing_shared_topics': [],
    'missing_skills': [],
    'repo_only_docs': [],
    'skill_test_missing': [],
    'repaired': [],
    'status': 'ok',
}

for name in required_shared_docs:
    shared_path = shared_docs / name
    repo_path = repo_docs / name
    if not shared_path.exists():
        report['missing_shared_docs'].append(name)
        if repo_path.exists():
            report['repo_only_docs'].append(name)
            if MODE == 'repair':
                shared_docs.mkdir(parents=True, exist_ok=True)
                shutil.copy2(repo_path, shared_path)
                report['repaired'].append(name)

for name in required_topics:
    if not (shared_topics / name).exists():
        report['missing_shared_topics'].append(name)

for name in required_skills:
    skill_path = skills_dir / name
    if not skill_path.exists():
        report['missing_skills'].append(name)
    else:
        if not (skill_path / 'SKILL.md').exists():
            report['missing_skills'].append(f'{name}/SKILL.md')
        if not (skill_path / 'test-prompts.json').exists():
            report['skill_test_missing'].append(name)

# repair 后重算缺失情况
if MODE == 'repair' and report['repaired']:
    report['missing_shared_docs'] = [
        name for name in required_shared_docs
        if not (shared_docs / name).exists()
    ]

if (
    report['missing_shared_docs']
    or report['missing_shared_topics']
    or report['missing_skills']
    or report['skill_test_missing']
):
    report['status'] = 'needs_attention'

print(json.dumps(report, ensure_ascii=False, indent=2))
