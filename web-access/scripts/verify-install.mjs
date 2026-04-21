#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const root = '/var/minis/skills/web-access';
const required = [
  'SKILL.md',
  'README.md',
  'scripts/match-site.mjs',
  'scripts/find-url.mjs',
  'references/site-patterns'
];

const result = {
  root,
  exists: fs.existsSync(root),
  node: process.version,
  checks: []
};

for (const rel of required) {
  const full = path.join(root, rel);
  result.checks.push({ path: rel, exists: fs.existsSync(full) });
}

const missing = result.checks.filter(x => !x.exists).map(x => x.path);
result.ok = result.exists && missing.length === 0;
result.missing = missing;
console.log(JSON.stringify(result, null, 2));
