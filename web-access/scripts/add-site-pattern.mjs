#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const [domain, ...rest] = process.argv.slice(2);
const note = rest.join(' ').trim();

if (!domain || !note) {
  console.error('Usage: node add-site-pattern.mjs <domain> <note>');
  process.exit(1);
}

const base = '/var/minis/skills/web-access/references/site-patterns';
const file = path.join(base, `${domain}.md`);

const header = `---\naliases: []\npreferred_route: browser_use\nnotes:\n  - ${note.replace(/\n/g, ' ')}\npitfalls:\n  - \nrecommended_flow:\n  - \n---\n`;

if (!fs.existsSync(base)) fs.mkdirSync(base, { recursive: true });

if (fs.existsSync(file)) {
  const now = `\n- ${note.replace(/\n/g, ' ')}\n`;
  const current = fs.readFileSync(file, 'utf8');
  const updated = current.includes('notes:')
    ? current.replace('notes:\n', `notes:\n  - ${note.replace(/\n/g, ' ')}\n`)
    : current + now;
  fs.writeFileSync(file, updated, 'utf8');
  console.log(`updated: ${file}`);
} else {
  fs.writeFileSync(file, header, 'utf8');
  console.log(`created: ${file}`);
}
