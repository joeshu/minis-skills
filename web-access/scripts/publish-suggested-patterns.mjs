#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const dir = '/var/minis/workspace/web-access-suggestions';
const out = path.join(dir, 'PUBLISH-READY.md');

if (!fs.existsSync(dir)) {
  fs.mkdirSync(dir, { recursive: true });
}

const files = fs.readdirSync(dir).filter(f => f.endsWith('.candidate.md')).sort();
const seen = new Set();
const kept = [];

for (const file of files) {
  const full = path.join(dir, file);
  const raw = fs.readFileSync(full, 'utf8').trim();
  const key = raw.toLowerCase().replace(/\s+/g, ' ');
  if (seen.has(key)) continue;
  seen.add(key);
  kept.push({ file, raw });
}

let output = '# PUBLISH-READY\n\n';
output += `候选文件数：${files.length}\n\n`;
output += `去重后保留：${kept.length}\n\n`;

for (const item of kept) {
  output += `## ${item.file}\n\n`;
  output += `${item.raw}\n\n`; 
}

fs.writeFileSync(out, output);
console.log(JSON.stringify({ dir, input_count: files.length, kept_count: kept.length, output: out }, null, 2));
