#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const [domain, ...rest] = process.argv.slice(2);
const note = (rest.join(' ') || '').trim();

if (!domain || !note) {
  console.error('Usage: node suggest-site-pattern.mjs <domain> <note>');
  process.exit(1);
}

const outDir = '/var/minis/workspace/web-access-suggestions';
fs.mkdirSync(outDir, { recursive: true });
const out = path.join(outDir, `${domain}.candidate.md`);

const body = `---
aliases: []
preferred_route: browser_use
notes:
  - ${note}
pitfalls:
  - 待补充
recommended_flow:
  - 待补充
---
候选经验：${note}
`;

fs.writeFileSync(out, body, 'utf8');
console.log(JSON.stringify({ domain, candidate_file: out, status: 'ok' }, null, 2));
