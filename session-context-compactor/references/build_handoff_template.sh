#!/bin/sh
# Usage: sh build_handoff_template.sh <output_file>
OUT="$1"
if [ -z "$OUT" ]; then
  echo "usage: sh build_handoff_template.sh <output_file>" >&2
  exit 2
fi
cat > "$OUT" <<'EOF'
# 会话执行摘要

## 当前目标
- 

## 关键约束
- 

## 已完成
- 

## 当前状态
- 

## 必要保留文件
- 

## 下一步
- 

## 风险 / 注意事项
- 
EOF
echo "written: $OUT"
