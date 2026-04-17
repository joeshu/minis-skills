#!/usr/bin/env python3
"""
merge_research_open_minis.py

汇总 Open Minis 人物型 skill 的 references/research/ 研究目录，输出研究完整度概览。

用法:
  python3 merge_research_open_minis.py <skill目录路径>

示例:
  python3 merge_research_open_minis.py /var/minis/skills/zhang-yiming-perspective-open-minis
"""

import sys
import re
from pathlib import Path

DIMENSIONS = {
    '01-writings.md': '著作/长文',
    '02-conversations.md': '对话/访谈',
    '03-expression-dna.md': '表达DNA',
    '04-external-views.md': '外部视角',
    '05-decisions.md': '重大决策',
    '06-timeline.md': '时间线',
}


def count_urls(text: str) -> int:
    return len(set(re.findall(r'https?://[^\s\)]+', text)))


def count_markers(text: str, pattern: str) -> int:
    return len(re.findall(pattern, text, re.IGNORECASE))


def preview_findings(text: str) -> str:
    headings = re.findall(r'^##\s+(.+)$', text, re.MULTILINE)
    if headings:
        s = ' / '.join(headings[:3])
        return s[:40] + ('...' if len(s) > 40 else '')
    lines = [l.strip() for l in text.splitlines() if l.strip() and not l.startswith('#')]
    if not lines:
        return '—'
    s = ' / '.join(lines[:2])
    return s[:40] + ('...' if len(s) > 40 else '')


def main():
    if len(sys.argv) < 2:
        print('用法: python3 merge_research_open_minis.py <skill目录路径>')
        sys.exit(1)

    skill_dir = Path(sys.argv[1])
    research_dir = skill_dir / 'references' / 'research'
    if not research_dir.exists():
        print(f'❌ 未找到 research 目录: {research_dir}')
        sys.exit(1)

    rows = []
    missing = []
    total_urls = 0
    total_primary = 0
    total_secondary = 0

    for filename, label in DIMENSIONS.items():
        path = research_dir / filename
        if not path.exists():
            missing.append(label)
            rows.append((label, '❌ 缺失', '—', '—'))
            continue

        text = path.read_text(encoding='utf-8')
        urls = count_urls(text)
        primary = count_markers(text, r'一手|本人|原文|原始|直接引用|公开信|演讲全文')
        secondary = count_markers(text, r'二手|评论|分析|报道|媒体整理|转述')
        total_urls += urls
        total_primary += primary
        total_secondary += secondary
        rows.append((label, str(urls), f'{primary}/{secondary}', preview_findings(text)))

    print('研究完整度概览')
    print('=' * 72)
    print(f"{'维度':<12} {'来源数':<8} {'一手/二手':<10} {'摘要预览'}")
    print('-' * 72)
    for row in rows:
        print(f"{row[0]:<12} {row[1]:<8} {row[2]:<10} {row[3]}")
    print('-' * 72)
    ratio = f'{total_primary}/{total_primary + total_secondary}' if (total_primary + total_secondary) else '未标记'
    print(f'总URL数: {total_urls}')
    print(f'一手标记占比: {ratio}')
    print(f'缺失维度: {", ".join(missing) if missing else "无"}')

    if missing:
        print('\n⚠️ 建议先补齐缺失维度，再做高强度人物蒸馏。')
    if total_urls < 6:
        print('⚠️ URL来源偏少，若目标是高质量人物型样本，建议继续补料。')


if __name__ == '__main__':
    main()
