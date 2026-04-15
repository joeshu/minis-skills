import os, re, pathlib, sys
SRC = pathlib.Path('/var/minis/memory')
DST = pathlib.Path('/var/minis/skills/docs/memory-export-sanitized')
DST.mkdir(parents=True, exist_ok=True)
patterns = [
    re.compile(r'(?i)(api[_ -]?key|token|secret|password|passwd|private[_ -]?key|credential|bearer|cookie|验证码|密钥|私钥|密码|令牌|口令|凭证)'),
    re.compile(r'(?i)(email|邮箱|phone|手机号|telephone|身份证|id card|address|住址)'),
    re.compile(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'),
    re.compile(r'(?<!\d)1[3-9]\d{9}(?!\d)'),
]
files = 0
redactions = 0
for p in sorted(SRC.glob('*.md')):
    text = p.read_text(encoding='utf-8', errors='ignore').splitlines()
    out = []
    for line in text:
        if any(r.search(line) for r in patterns):
            out.append('[REDACTED: sensitive/private content removed]')
            redactions += 1
        else:
            out.append(line)
    (DST / p.name).write_text('\n'.join(out) + '\n', encoding='utf-8')
    files += 1
print(f'files={files}')
print(f'redactions={redactions}')
