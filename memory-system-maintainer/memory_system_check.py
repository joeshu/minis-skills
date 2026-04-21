#!/usr/bin/env python3
from pathlib import Path
import json
import subprocess
import sys

BASE = Path('/var/minis/skills/memory-system-maintainer')
LIGHT = BASE / 'audit_memory_system.py'
FULL = BASE / 'full_memory_system_check.py'
SIM = BASE / 'simulate_memory_workflows.py'

args = sys.argv[1:]
mode = 'light'
if '--full' in args:
    mode = 'full'
elif '--simulate' in args:
    mode = 'simulate'
elif '--all' in args:
    mode = 'all'
elif '--light' in args:
    mode = 'light'

repair = '--repair' in args

scripts_exist = {
    'light': LIGHT.exists(),
    'full': FULL.exists(),
    'simulate': SIM.exists(),
}

if mode != 'all' and not scripts_exist.get(mode, False):
    print(json.dumps({'status': 'needs_attention', 'mode': mode, 'error': 'script_missing'}, ensure_ascii=False, indent=2))
    sys.exit(1)

if mode == 'all' and not all(scripts_exist.values()):
    print(json.dumps({'status': 'needs_attention', 'mode': mode, 'scripts_exist': scripts_exist}, ensure_ascii=False, indent=2))
    sys.exit(1)

commands = []
if mode == 'light':
    commands.append(['python3', str(LIGHT)] + (['--repair'] if repair else []))
elif mode == 'full':
    commands.append(['python3', str(FULL)])
elif mode == 'simulate':
    commands.append(['python3', str(SIM)])
elif mode == 'all':
    commands.append(['python3', str(LIGHT)] + (['--repair'] if repair else []))
    commands.append(['python3', str(FULL)])
    commands.append(['python3', str(SIM)])

results = []
overall_ok = True
for cmd in commands:
    proc = subprocess.run(cmd, capture_output=True, text=True)
    stdout = proc.stdout.strip()
    stderr = proc.stderr.strip()
    parsed = None
    try:
        parsed = json.loads(stdout) if stdout else None
    except Exception:
        parsed = {'raw_stdout': stdout}
    result = {
        'command': cmd,
        'returncode': proc.returncode,
        'stdout': parsed,
        'stderr': stderr,
    }
    if proc.returncode != 0:
        overall_ok = False
    else:
        if isinstance(parsed, dict) and parsed.get('status') not in (None, 'ok'):
            overall_ok = False
    results.append(result)

print(json.dumps({
    'mode': mode,
    'repair': repair,
    'scripts_exist': scripts_exist,
    'status': 'ok' if overall_ok else 'needs_attention',
    'results': results,
}, ensure_ascii=False, indent=2))
