#!/usr/bin/env python3
from pathlib import Path
import json
import hashlib

BASE = Path('/var/minis')
repo = BASE / 'shared' / 'minis-skills'
repo_docs = repo / 'docs' / 'memory-system'
repo_topics = repo / 'docs' / 'memory-topics'
shared_docs = BASE / 'shared' / 'docs' / 'memory-system'
shared_topics = BASE / 'shared' / 'memory_topics'
skills = BASE / 'skills'

skill_names = [
    'memory-topic-router',
    'memory-write-gatekeeper',
    'memory-layer-governor',
    'memory-dedup-auditor',
    'open-minis-memory-store',
    'memory-system-maintainer',
    'memory-system-git-sync',
    'open-minis-handoff-orchestrator',
    'session-context-compactor',
]

required_skill_files = ['SKILL.md', 'README.md', 'test-prompts.json']
required_shared_docs = [
    'memory-subsystems-responsibility-matrix.md',
    'memory-system-final-maturity-report.md',
    'memory-system-skill-map.md',
    'memory-system-usage-guide.md',
    'memory-topics-index.md',
]
required_topics = [
    'TopicIndex.md',
    'README.md',
    'memory-maintenance.md',
    'global_memory_style_and_retrieval_rules.md',
    'ResponseStyle-AGENTS.md',
    'ResponseStyle-HighDensity.md',
    'ResponseModePrefixes.md',
    'SystemArchitecture.md',
]

def sha256(path: Path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            h.update(chunk)
    return h.hexdigest()

report = {
    'repo_exists': repo.exists(),
    'shared_docs_exists': shared_docs.exists(),
    'shared_topics_exists': shared_topics.exists(),
    'skills': {},
    'missing_shared_docs': [],
    'missing_shared_topics': [],
    'repo_to_shared_doc_drift': [],
    'topic_sync_gap': [],
    'python_audit_scripts': {},
    'status': 'ok',
}

for name in skill_names:
    skill_dir = skills / name
    entry = {'exists': skill_dir.exists(), 'missing_files': []}
    if skill_dir.exists():
        for fname in required_skill_files:
            if not (skill_dir / fname).exists():
                entry['missing_files'].append(fname)
    else:
        entry['missing_files'] = required_skill_files[:]
    report['skills'][name] = entry

for name in required_shared_docs:
    sp = shared_docs / name
    rp = repo_docs / name
    if not sp.exists():
        report['missing_shared_docs'].append(name)
    if sp.exists() and rp.exists():
        if sha256(sp) != sha256(rp):
            report['repo_to_shared_doc_drift'].append(name)

for name in required_topics:
    sp = shared_topics / name
    rp = repo_topics / name
    if not sp.exists():
        report['missing_shared_topics'].append(name)
    elif rp.exists() and sha256(sp) != sha256(rp):
        report['topic_sync_gap'].append(name)

for script_name in ['audit_memory_system.py', 'full_memory_system_check.py']:
    p = skills / 'memory-system-maintainer' / script_name
    report['python_audit_scripts'][script_name] = p.exists()

if report['missing_shared_docs'] or report['missing_shared_topics'] or report['repo_to_shared_doc_drift'] or report['topic_sync_gap']:
    report['status'] = 'needs_attention'

for entry in report['skills'].values():
    if entry['missing_files']:
        report['status'] = 'needs_attention'
        break

print(json.dumps(report, ensure_ascii=False, indent=2))
