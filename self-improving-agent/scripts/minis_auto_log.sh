#!/bin/sh
# self-improving-agent Minis 自动初始化 + 自动记录
set -e

SKILL_BASE="/var/minis/skills/self-improving-agent/data"
PUBLIC_BASE="/var/minis/skills/self-improving-agent/data/public"
TESTING_BASE="/var/minis/skills/self-improving-agent/data/testing"
BASE="${SELF_IMPROVING_BASE:-$SKILL_BASE}"
MODE="skill"
PROJECT_ROOT=""
TARGET=""

while [ $# -gt 0 ]; do
  case "$1" in
    --base)
      [ -n "$2" ] || { echo "缺少 --base 参数值" >&2; exit 1; }
      BASE="$2"
      MODE="custom"
      shift 2
      ;;
    --project)
      [ -n "$2" ] || { echo "缺少 --project 参数值" >&2; exit 1; }
      PROJECT_ROOT="$2"
      BASE="$2/.learnings"
      MODE="project"
      shift 2
      ;;
    --public|--workspace)
      BASE="$PUBLIC_BASE"
      MODE="public"
      shift 1
      ;;
    --testing)
      BASE="$TESTING_BASE"
      MODE="testing"
      shift 1
      ;;
    --skill)
      BASE="$SKILL_BASE"
      MODE="skill"
      shift 1
      ;;
    *)
      break
      ;;
  esac
done

LEARN="$BASE/LEARNINGS.md"
ERRS="$BASE/ERRORS.md"
FEAT="$BASE/FEATURE_REQUESTS.md"

contains_ci() {
  text="$1"
  pattern="$2"
  echo "$text" | grep -Eiq "$pattern"
}

should_route_testing() {
  text="$1"
  score=0

  contains_ci "$text" '测试|test|联调|回写|版式|初始化测试|promote|验证.*(生效|分流|覆盖|阻止|回填)|demo' && score=$((score + 2))
  contains_ci "$text" '是否|有没有|对不对|正确不正确|能不能|是否自动' && score=$((score + 1))
  contains_ci "$text" '脚本|机制|初始化|promote|testing|回写|去重|版式' && score=$((score + 1))

  contains_ci "$text" '长期规则|通用规则|最佳实践|跨项目复用|所有任务都适用|稳定规则' && score=$((score - 2))
  contains_ci "$text" '生产问题|线上故障|用户纠正|知识过时|长期偏好' && score=$((score - 1))

  [ "$score" -ge 2 ]
}

ensure_header() {
  file="$1"
  header="$2"
  [ -f "$file" ] || cat > "$file" <<EOF
$header
EOF
}

init() {
  mkdir -p "$BASE"
  ensure_header "$LEARN" "# Learnings"
  ensure_header "$ERRS" "# Errors"
  ensure_header "$FEAT" "# Feature Requests"
}

project_meta_line() {
  if [ -n "$PROJECT_ROOT" ]; then
    printf '%s\n' "- 项目路径: $PROJECT_ROOT"
  fi
}

meta_block() {
  printf '%s\n' "- 来源: conversation"
  printf '%s\n' "- 作用域: $MODE"
  printf '%s\n' "- 基础路径: $BASE"
  project_meta_line
  printf '%s\n' "- 关联文件: (可选)"
  printf '%s\n' "- 标签: (可选)"
}

new_id() {
  TYPE="$1"
  DATE=$(date -u +%Y%m%d)
  RAND=$(tr -dc A-Z0-9 </dev/urandom | head -c 3)
  echo "${TYPE}-${DATE}-${RAND}"
}

log_testing() {
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ID=$(new_id TST)
  SUMMARY="$1"
  DETAILS="${2:-（测试/验证说明）}"
  {
    printf '## [%s] testing\n\n' "$ID"
    printf '**记录时间**: %s\n' "$TS"
    printf '**优先级**: low\n'
    printf '**状态**: pending\n'
    printf '**领域**: testing\n\n'
    printf '### 摘要\n%s\n\n' "$SUMMARY"
    printf '### 详情\n%s\n\n' "$DETAILS"
    printf '### 建议动作\n若提炼出稳定规则，再重写为正式 learning / error / feature\n\n'
    printf '### 元数据\n'
    meta_block
    printf '%s\n' '- 测试记录: yes'
    printf '\n---\n'
  } >> "$LEARN"
  echo "已记录测试条目：$ID → $LEARN"
}

log_learning() {
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ID=$(new_id LRN)
  SUMMARY="$1"
  DETAILS="${2:-（可选）}"

  if [ "$MODE" != "testing" ] && should_route_testing "$SUMMARY $DETAILS"; then
    echo "检测到测试/验证语义，已自动改记到 testing 层" >&2
    old_base="$BASE"
    old_mode="$MODE"
    old_learn="$LEARN"
    old_errs="$ERRS"
    old_feat="$FEAT"
    BASE="$TESTING_BASE"
    MODE="testing"
    LEARN="$BASE/LEARNINGS.md"
    ERRS="$BASE/ERRORS.md"
    FEAT="$BASE/FEATURE_REQUESTS.md"
    init
    log_testing "$SUMMARY" "$DETAILS"
    BASE="$old_base"
    MODE="$old_mode"
    LEARN="$old_learn"
    ERRS="$old_errs"
    FEAT="$old_feat"
    return 0
  fi

  {
    printf '## [%s] category\n\n' "$ID"
    printf '**记录时间**: %s\n' "$TS"
    printf '**优先级**: medium\n'
    printf '**状态**: pending\n'
    printf '**领域**: docs\n\n'
    printf '### 摘要\n%s\n\n' "$SUMMARY"
    printf '### 详情\n%s\n\n' "$DETAILS"
    printf '### 建议动作\n（待补充）\n\n'
    printf '### 元数据\n'
    meta_block
    printf '\n---\n'
  } >> "$LEARN"
  echo "已记录：$ID → $LEARN"
}

log_error() {
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ID=$(new_id ERR)
  SUMMARY="$1"
  DETAILS="${2:-（粘贴错误信息）}"

  if [ "$MODE" != "testing" ] && should_route_testing "$SUMMARY $DETAILS"; then
    echo "检测到测试/验证语义，已自动改记到 testing 层" >&2
    old_base="$BASE"
    old_mode="$MODE"
    old_learn="$LEARN"
    old_errs="$ERRS"
    old_feat="$FEAT"
    BASE="$TESTING_BASE"
    MODE="testing"
    LEARN="$BASE/LEARNINGS.md"
    ERRS="$BASE/ERRORS.md"
    FEAT="$BASE/FEATURE_REQUESTS.md"
    init
    log_testing "$SUMMARY" "$DETAILS"
    BASE="$old_base"
    MODE="$old_mode"
    LEARN="$old_learn"
    ERRS="$old_errs"
    FEAT="$old_feat"
    return 0
  fi

  {
    printf '## [%s] command\n\n' "$ID"
    printf '**记录时间**: %s\n' "$TS"
    printf '**优先级**: high\n'
    printf '**状态**: pending\n'
    printf '**领域**: infra\n\n'
    printf '### 摘要\n%s\n\n' "$SUMMARY"
    printf '### Error\n```\n%s\n```\n\n' "$DETAILS"
    printf '### Context\n- 尝试的命令/操作：\n- 输入或参数：\n- 环境细节：\n\n'
    printf '### 建议修复\n（待补充）\n\n'
    printf '### 元数据\n'
    printf '%s\n' '- 可复现: unknown'
    printf '%s\n' "- 作用域: $MODE"
    printf '%s\n' "- 基础路径: $BASE"
    project_meta_line
    printf '%s\n\n' '- 关联文件: (可选)'
    printf '%s\n' '---'
  } >> "$ERRS"
  echo "已记录：$ID → $ERRS"
}

log_feature() {
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ID=$(new_id FEAT)
  SUMMARY="$1"
  DETAILS="${2:-（可选）}"

  if [ "$MODE" != "testing" ] && should_route_testing "$SUMMARY $DETAILS"; then
    echo "检测到测试/验证语义，已自动改记到 testing 层" >&2
    old_base="$BASE"
    old_mode="$MODE"
    old_learn="$LEARN"
    old_errs="$ERRS"
    old_feat="$FEAT"
    BASE="$TESTING_BASE"
    MODE="testing"
    LEARN="$BASE/LEARNINGS.md"
    ERRS="$BASE/ERRORS.md"
    FEAT="$BASE/FEATURE_REQUESTS.md"
    init
    log_testing "$SUMMARY" "$DETAILS"
    BASE="$old_base"
    MODE="$old_mode"
    LEARN="$old_learn"
    ERRS="$old_errs"
    FEAT="$old_feat"
    return 0
  fi

  {
    printf '## [%s] capability\n\n' "$ID"
    printf '**记录时间**: %s\n' "$TS"
    printf '**优先级**: medium\n'
    printf '**状态**: pending\n'
    printf '**领域**: docs\n\n'
    printf '### 需求能力\n%s\n\n' "$SUMMARY"
    printf '### 用户背景\n%s\n\n' "$DETAILS"
    printf '### 复杂度评估\nmedium\n\n'
    printf '### 建议实现\n（待补充）\n\n'
    printf '### 元数据\n'
    printf '%s\n' '- 频次: first_time'
    printf '%s\n' "- 作用域: $MODE"
    printf '%s\n' "- 基础路径: $BASE"
    project_meta_line
    printf '%s\n\n' '- 关联功能: (可选)'
    printf '%s\n' '---'
  } >> "$FEAT"
  echo "已记录：$ID → $FEAT"
}

status() {
  init
  echo "模式: $MODE"
  echo "基础路径: $BASE"
  [ -n "$PROJECT_ROOT" ] && echo "项目路径: $PROJECT_ROOT"
  echo "技能默认区: $SKILL_BASE"
  echo "公共区: $PUBLIC_BASE"
  echo "LEARNINGS: $LEARN"
  echo "ERRORS: $ERRS"
  echo "FEATURES: $FEAT"
}

search_all() {
  KEYWORD="$1"
  [ -n "$KEYWORD" ] || { echo "缺少搜索关键词" >&2; exit 1; }
  find /var/minis/skills/self-improving-agent /var/minis/workspace -type f \( -path '/var/minis/skills/self-improving-agent/data/*.md' -o -path '/var/minis/skills/self-improving-agent/data/public/*.md' -o -path '/var/minis/skills/self-improving-agent/data/testing/*.md' -o -path '*/.learnings/*.md' \) -print0 2>/dev/null |
    xargs -0 grep -n -i -- "$KEYWORD" 2>/dev/null || true
}

promote_to_public() {
  ENTRY_ID="$1"
  [ -n "$ENTRY_ID" ] || { echo "缺少条目 ID" >&2; exit 1; }
  init
  SRC=$(find /var/minis/skills/self-improving-agent /var/minis/workspace -type f \( -path '/var/minis/skills/self-improving-agent/data/*.md' -o -path '/var/minis/skills/self-improving-agent/data/public/*.md' -o -path '/var/minis/skills/self-improving-agent/data/testing/*.md' -o -path '*/.learnings/*.md' \) -print0 2>/dev/null | xargs -0 grep -l "\[$ENTRY_ID\]" 2>/dev/null | head -n 1)
  [ -n "$SRC" ] || { echo "未找到条目：$ENTRY_ID" >&2; exit 1; }
  case "$SRC" in
    "$PUBLIC_BASE"/*)
      echo "条目已在公共区：$SRC"
      exit 0
      ;;
    "$TESTING_BASE"/*)
      echo "测试层条目禁止直接提升到公共区，请先重写为正式 learning / error / feature" >&2
      exit 2
      ;;
  esac

  BLOCK=$(awk -v id="$ENTRY_ID" '
    BEGIN {capture=0}
    $0 ~ "^## \\[" id "\\]" {capture=1}
    capture {print}
    capture && $0 == "---" {exit}
  ' "$SRC")

  echo "$BLOCK" | grep -Eiq '测试记录: yes|测试|test|demo|联调|回写|版式|初始化|promote' && {
    echo "检测到测试/演示语义，禁止直接提升到公共区，请先重写为正式规则" >&2
    exit 2
  }

  TARGET="$PUBLIC_BASE/$(basename "$SRC")"
  mkdir -p "$PUBLIC_BASE"
  [ -f "$TARGET" ] || printf '# %s\n' "$(basename "$TARGET" .md | tr '_' ' ')" > "$TARGET"
  if grep -q "\[$ENTRY_ID\]" "$TARGET" 2>/dev/null; then
    echo "条目已存在于公共区：$TARGET"
    exit 0
  fi
  echo "$BLOCK" >> "$TARGET"
  echo "" >> "$TARGET"

  TMP=$(mktemp)
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  awk -v id="$ENTRY_ID" -v target="$TARGET" -v ts="$TS" '
    BEGIN {in_block=0; promoted_done=0; resolution_seen=0}
    {
      if ($0 ~ "^## \\[" id "\\]") {
        in_block=1
      }

      if (in_block && $0 == "**状态**: pending") {
        print "**状态**: promoted"
        next
      }

      if (in_block && $0 ~ /^\*\*已提升到\*\*:/) {
        promoted_done=1
      }

      if (in_block && $0 == "### 解决记录") {
        resolution_seen=1
      }

      if (in_block && $0 == "---") {
        if (!promoted_done) print "**已提升到**: " target
        if (!resolution_seen) {
          print ""
          print "### 解决记录"
          print "- **解决时间**: " ts
          print "- **说明**: 已提升到技能内公共区"
        }
        print
        in_block=0
        promoted_done=0
        resolution_seen=0
        next
      }

      print
    }
  ' "$SRC" > "$TMP"
  mv "$TMP" "$SRC"

  echo "已提升：$ENTRY_ID → $TARGET"
  echo "已回写源条目状态为 promoted"
}

usage() {
  echo "用法：$0 [--skill | --project 项目目录 | --public | --testing | --workspace | --base 路径] init | status | learning <摘要> [详情] | error <摘要> [错误] | feature <摘要> [背景] | testing <摘要> [详情] | search <关键词> | promote <条目ID>" >&2
  exit 1
}

case "$1" in
  init)
    init
    echo "已初始化：$BASE"
    ;;
  status)
    status
    ;;
  learning)
    init
    [ -n "$2" ] || usage
    log_learning "$2" "$3"
    ;;
  error)
    init
    [ -n "$2" ] || usage
    log_error "$2" "$3"
    ;;
  feature)
    init
    [ -n "$2" ] || usage
    log_feature "$2" "$3"
    ;;
  testing)
    BASE="$TESTING_BASE"
    MODE="testing"
    LEARN="$BASE/LEARNINGS.md"
    ERRS="$BASE/ERRORS.md"
    FEAT="$BASE/FEATURE_REQUESTS.md"
    init
    [ -n "$2" ] || usage
    log_testing "$2" "$3"
    ;;
  search)
    search_all "$2"
    ;;
  promote)
    promote_to_public "$2"
    ;;
  *)
    usage
    ;;
esac
