#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const root = '/var/minis/skills/web-access';
const patternsDir = path.join(root, 'references', 'site-patterns');

const query = (process.argv.slice(2).join(' ') || '').trim();
const q = query.toLowerCase();

function hasAny(words) {
  return words.some(w => q.includes(w));
}

function loadSitePatterns() {
  if (!fs.existsSync(patternsDir)) return [];
  const files = fs.readdirSync(patternsDir).filter(f => f.endsWith('.md'));
  const matches = [];

  for (const name of files) {
    const domain = name.replace(/\.md$/, '');
    const full = path.join(patternsDir, name);
    const raw = fs.readFileSync(full, 'utf8');
    const aliasesLine = raw.split(/\r?\n/).find(l => l.startsWith('aliases:')) || '';
    const routeLine = raw.split(/\r?\n/).find(l => l.startsWith('preferred_route:')) || '';
    const aliases = aliasesLine
      .replace(/^aliases:\s*/, '')
      .replace(/^\[/, '').replace(/\]$/, '')
      .split(',')
      .map(v => v.trim())
      .filter(Boolean);
    const preferred_route = routeLine.replace(/^preferred_route:\s*/, '').trim();
    const tokens = [domain.toLowerCase(), ...aliases.map(a => a.toLowerCase())];
    if (tokens.some(t => t && q.includes(t))) {
      matches.push({ domain, path: full, aliases, preferred_route });
    }
  }
  return matches;
}

function routeTask(text, matchedSites) {
  const dynamic = hasAny(['登录', '点击', '展开', '滚动', '搜索', '输入', '上传', '发布', '表单', '动态页面', '交互', '评论', '话题']);
  const article = hasAny(['正文', '文章', '总结', '摘要', '提取', '网页', '读一下', '内容']);
  const urlFinding = hasAny(['网址', '链接', '官网', '地址', '哪个页面', '找页面', '入口']);
  const multiTarget = hasAny(['同时', '对比', '多个', '几家', '批量', '5个', '10个']);

  let primary_route = 'browser_use';
  let rationale = '默认使用 Minis 内置浏览器能力处理网页任务。';

  if (article && !dynamic) {
    primary_route = 'extractor_first';
    rationale = '更像正文/内容提取任务，应优先低成本正文抽取路径，再按需升级到浏览器交互。';
  } else if (dynamic) {
    primary_route = 'browser_interactive';
    rationale = '任务包含明显交互动作，应优先 browser_use 导航、点击、输入、滚动与页面观察。';
  } else if (urlFinding) {
    primary_route = 'search_then_browser';
    rationale = '更像找入口/找网址任务，应先定位目标 URL，再进入浏览器读取或操作。';
  }

  if (matchedSites.length > 0) {
    const sitePref = matchedSites[0].preferred_route;
    if (sitePref === 'browser_use' && primary_route === 'extractor_first') {
      primary_route = 'browser_interactive';
      rationale = '命中站点经验，站点特性优先于通用正文路由，改走 browser 交互/观察路径。';
    }
    if (sitePref === 'extractor_first' && primary_route === 'browser_use') {
      primary_route = 'extractor_first';
      rationale = '命中站点经验，站点内容更适合正文抽取优先。';
    }
  }

  return { primary_route, rationale, multi_target: multiTarget };
}

const matchedSites = loadSitePatterns();
const result = {
  query,
  task: routeTask(query, matchedSites),
  matched_sites: matchedSites,
  recommended_steps: []
};

switch (result.task.primary_route) {
  case 'extractor_first':
    result.recommended_steps = [
      '先尝试正文抽取或 browser_use.get_readable',
      '若主内容不完整，再 navigate + wait_for_dom_stable + get_text',
      '必要时再升级到 click/scroll/execute_js'
    ];
    break;
  case 'browser_interactive':
    result.recommended_steps = [
      'navigate 到目标页面',
      'wait_for_dom_stable',
      'find_elements / get_backbone 观察页面结构',
      '执行 click/type/scroll/scroll_and_collect',
      '必要时截图或执行 JS 校验状态'
    ];
    break;
  case 'search_then_browser':
    result.recommended_steps = [
      '先定位 URL 或站内入口',
      '再进入 browser_use 读取或操作',
      '若是曾访问过但难搜目标，再考虑历史/书签检索兼容脚本'
    ];
    break;
  default:
    result.recommended_steps = [
      '优先使用 browser_use',
      '必要时降级/升级到更轻或更重路径'
    ];
}

console.log(JSON.stringify(result, null, 2));
