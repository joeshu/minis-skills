#!/usr/bin/env python3
"""
quality_check_open_minis.py

面向 Open Minis 女娲的人物型 SKILL.md 质量检查器。
重点检查：主文件研究压强、人物锚点、表达DNA微动作层、典型问题开口、张力主骨架、假像风险。

用法:
  python3 quality_check_open_minis.py <SKILL.md路径>
"""

import sys
import re
from pathlib import Path


def section_text(content: str, keywords: str) -> str:
    m = re.search(rf'(##\s+.*(?:{keywords}).*?)(?=\n##\s|\Z)', content, re.DOTALL | re.IGNORECASE)
    return m.group(1) if m else ''


def check_research_pressure(content: str):
    markers = len(re.findall(r'原话|研究依据|证据|真实案例|公开信|演讲|微博|访谈|案例', content))
    passed = markers >= 8
    return passed, f'研究压强信号 {markers} 项' + (' ✅' if passed else ' ❌ (建议≥8)')


def check_anchor_points(content: str):
    text = section_text(content, r'身份卡|我是谁|锚点')
    patterns = [
        r'锦秋家园|推荐系统|吃老本|过拟合|徐汇区|推荐系统实践|10 个人|10个人',
        r'Viaweb|佛罗伦萨|RISD|英格兰乡下|Y Combinator|essay|writer|programmer|画画|画家',
        r'伯克希尔|巴菲特|Daily Journal|Too Hard|激励|律师|房地产|副董事长|终身学习者|不蠢',
        r'具体锚点|我是谁|最初是为了|后来发现|住在|公开承认|重新公开出现|我会说',
    ]
    markers = 0
    for p in patterns:
        if re.search(p, text, re.IGNORECASE):
            markers += 1
    bullet_count = len(re.findall(r'^-\s+', text, re.MULTILINE))
    passed = markers >= 2 and bullet_count >= 4
    return passed, f'人物锚点信号 {markers} 组 / {bullet_count} 条' + (' ✅' if passed else ' ❌ (建议≥2组强锚点且≥4条)')


def check_expression_micro_actions(content: str):
    text = section_text(content, r'表达 DNA|表达DNA')
    markers = len(re.findall(r'起手|拒绝回答|切换框架|微动作|不要每次|不要滥用|禁用|反机械', text))
    passed = markers >= 4
    return passed, f'表达DNA微动作信号 {markers} 项' + (' ✅' if passed else ' ❌ (建议≥4)')


def check_opening_lines(content: str):
    markers = len(re.findall(r'典型问题开口', content))
    passed = markers >= 3
    return passed, f'典型问题开口段 {markers} 处' + (' ✅' if passed else ' ❌ (建议≥3)')


def check_tensions(content: str):
    text = section_text(content, r'张力|矛盾')
    markers = len(re.findall(r'vs|张力|矛盾|反差|未解决', text, re.IGNORECASE))
    passed = markers >= 4
    return passed, f'张力信号 {markers} 项' + (' ✅' if passed else ' ❌ (建议≥4)')


def check_fake_risk(content: str):
    risk = 0
    if len(re.findall(r'金句|名言', content)) > 3:
        risk += 1
    if '典型问题开口' not in content:
        risk += 1
    if '拒绝回答' not in content and '切换框架' not in content:
        risk += 1
    if '真实案例' not in content:
        risk += 1
    passed = risk <= 1
    return passed, f'假像风险项 {risk} 个' + (' ✅' if passed else ' ❌ (风险偏高)')


def main():
    if len(sys.argv) < 2:
        print('用法: python3 quality_check_open_minis.py <SKILL.md路径>')
        sys.exit(1)

    path = Path(sys.argv[1])
    if not path.exists():
        print(f'❌ 文件不存在: {path}')
        sys.exit(1)

    content = path.read_text(encoding='utf-8')
    checks = [
        ('主文件研究压强', check_research_pressure),
        ('人物锚点', check_anchor_points),
        ('表达DNA微动作层', check_expression_micro_actions),
        ('典型问题开口', check_opening_lines),
        ('张力主骨架', check_tensions),
        ('假像风险', check_fake_risk),
    ]

    passed_count = 0
    print(f'质量检查: {path.name}')
    print('=' * 56)
    for name, fn in checks:
        passed, detail = fn(content)
        print(f"{name:<18} {'✅ PASS' if passed else '❌ FAIL'}  {detail}")
        if passed:
            passed_count += 1
    print('=' * 56)
    print(f'结果: {passed_count}/{len(checks)} 通过')
    if passed_count == len(checks):
        print('🎉 已达到较高质量人物型样本标准')
        sys.exit(0)
    elif passed_count >= len(checks) - 1:
        print('⚠️ 已接近高质量，可做点状抛光')
        sys.exit(1)
    else:
        print('❌ 仍建议继续做样本回归和假像修正')
        sys.exit(1)


if __name__ == '__main__':
    main()
