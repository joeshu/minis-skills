#!/bin/sh
set -e
REPO='joeshu/opencode2api-enhanced'
RUNS_JSON=$(curl -s https://api.github.com/repos/$REPO/actions/runs?per_page=10)
python3 - <<'PY'
import json,sys,os
raw=sys.stdin.read()
data=json.loads(raw)
runs=data.get('workflow_runs', [])
need={'.github/workflows/smoke.yml':'Smoke Check','.github/workflows/docker-publish.yml':'Publish Docker Image'}
latest={}
for r in runs:
    p=r.get('path')
    if p in need and p not in latest:
        latest[p]=r
missing=[p for p in need if p not in latest]
if missing:
    print('missing workflows:', ', '.join(missing))
    sys.exit(1)
ok=True
for p,name in need.items():
    r=latest[p]
    conclusion=r.get('conclusion')
    status=r.get('status')
    sha=r.get('head_sha')
    print(f'{name}: status={status} conclusion={conclusion} sha={sha} url={r.get("html_url")}')
    if not (status == 'completed' and conclusion == 'success'):
        ok=False
if not ok:
    sys.exit(2)
PY
