#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const dir = '/var/minis/workspace/web-access-suggestions';
const out = '/var/minis/workspace/web-access-suggestions/MERGED-SUGGESTIONS.md';

if (!fs.existsSync(dir)) {
  console.log('No suggestions directory found.');
  process.exit(0);
}

const files = fs.readdirSync(dir)
  .filter(f => f.endsWith('.candidate.md'))
  .sort();

if (files.length === 0) {
  console.log('No candidate files found.');
  process.exit(0);
}

const blocks = ['# MERGED-SUGGESTIONS', ''];
for (const file of files) {
  const full = path.join(dir, file);
  const raw = fs.readFileSync(full, 'utf8').trim();
  blocks.push(`## ${file}`);
  blocks.push(raw);
  blocks.push('');
}

fs.writeFileSync(out, blocks.join('\n'));
console.log(out);
