#!/bin/sh
# Usage: sh score_summary_quality.sh <summary_file>
FILE="$1"
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  echo "usage: sh score_summary_quality.sh <summary_file>" >&2
  exit 2
fi

score=0
check() {
  pattern="$1"
  pts="$2"
  if grep -q "$pattern" "$FILE"; then
    score=$((score + pts))
    echo "PASS +$pts : $pattern"
  else
    echo "MISS +0 : $pattern"
  fi
}

check "## 当前目标" 15
check "## 关键约束" 15
check "## 已完成" 10
check "## 当前状态" 10
check "## 必要保留文件" 20
check "## 下一步" 15
check "## 风险 / 注意事项" 15

lines=$(wc -l < "$FILE")
if [ "$lines" -le 60 ]; then
  score=$((score + 10))
  echo "PASS +10 : summary length <= 60 lines"
else
  echo "MISS +0 : summary too long ($lines lines)"
fi

if [ "$score" -gt 100 ]; then
  score=100
fi

echo "TOTAL=$score/100"
