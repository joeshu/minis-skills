#!/usr/bin/env python3
"""
srt_to_transcript.py

将 SRT/VTT 字幕清洗为纯文本 transcript，便于喂给人物研究文件。

用法:
  python3 srt_to_transcript.py input.srt [output.txt]
  python3 srt_to_transcript.py input.vtt [output.txt]
"""

import sys
import re
from pathlib import Path


def clean_text(content: str) -> str:
    lines = content.strip().splitlines()
    texts = []
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith('WEBVTT') or line.startswith('NOTE'):
            continue
        if re.match(r'^\d+$', line):
            continue
        if re.match(r'^\d{2}:\d{2}:\d{2}', line):
            continue
        line = re.sub(r'<[^>]+>', '', line)
        line = re.sub(r'align:.*$|position:.*$|line:.*$', '', line).strip()
        if line:
            texts.append(line)

    deduped = []
    for t in texts:
        if not deduped or t != deduped[-1]:
            deduped.append(t)

    paragraphs = []
    current = []
    for t in deduped:
        current.append(t)
        joined = ' '.join(current)
        if len(joined) > 180 or re.search(r'[。！？.!?]$', t):
            paragraphs.append(joined)
            current = []
    if current:
        paragraphs.append(' '.join(current))
    return '\n\n'.join(paragraphs)


def main():
    if len(sys.argv) < 2:
        print('用法: python3 srt_to_transcript.py <input.srt|input.vtt> [output.txt]')
        sys.exit(1)

    input_path = Path(sys.argv[1])
    if not input_path.exists():
        print(f'❌ 文件不存在: {input_path}')
        sys.exit(1)

    output_path = Path(sys.argv[2]) if len(sys.argv) >= 3 else input_path.with_name(input_path.stem + '_transcript.txt')
    content = input_path.read_text(encoding='utf-8')
    result = clean_text(content)
    output_path.write_text(result, encoding='utf-8')
    print(f'✅ 转换完成: {output_path}')
    print(f'字数: {len(result)}')


if __name__ == '__main__':
    main()
