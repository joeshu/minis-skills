#!/bin/sh
set -eu
cmd="${1:-}"
[ -n "$cmd" ] || { echo "usage: gh_sync.sh <command> [options]" >&2; exit 1; }
shift || true
need_repo(){ git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not inside a git repo" >&2; exit 1; }; }
need_token(){ [ -n "${GITHUB_TOKEN:-}" ] || { echo "GITHUB_TOKEN not set" >&2; exit 1; }; }
repo_slug(){ git remote get-url origin 2>/dev/null | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##'; }
api(){ need_token; curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" "$@"; }
arg(){ key="$1"; shift; while [ $# -gt 0 ]; do [ "$1" = "$key" ] && { [ $# -ge 2 ] && { echo "$2"; return 0; }; }; shift; done; return 1; }
case "$cmd" in
clone) url=$(arg --url "$@") || { echo "missing --url" >&2; exit 1; }; git clone "$url" ;;
init) git init ;;
status) need_repo; git status --short --branch ;;
diff) need_repo; git diff "$@" ;;
log) need_repo; git log --oneline --decorate -n "${1:-10}" ;;
remotes) need_repo; git remote -v ;;
add-remote) need_repo; n=$(arg --name "$@") || n=origin; u=$(arg --url "$@") || { echo "missing --url" >&2; exit 1; }; git remote add "$n" "$u" ;;
set-remote-url) need_repo; n=$(arg --name "$@") || n=origin; u=$(arg --url "$@") || { echo "missing --url" >&2; exit 1; }; git remote set-url "$n" "$u" ;;
remove-remote) need_repo; n=$(arg --name "$@") || { echo "missing --name" >&2; exit 1; }; git remote remove "$n" ;;
add-upstream) need_repo; u=$(arg --upstream "$@") || { echo "missing --upstream owner/repo" >&2; exit 1; }; git remote add upstream "https://github.com/$u.git" ;;
branches) need_repo; git branch -a ;;
create-branch) need_repo; n=$(arg --name "$@") || { echo "missing --name" >&2; exit 1; }; git checkout -b "$n" ;;
checkout) need_repo; n=$(arg --name "$@") || { echo "missing --name" >&2; exit 1; }; git checkout "$n" ;;
delete-branches) need_repo; mode=$(arg --mode "$@" || true); [ "$mode" = remote ] && git branch -r | sed 's#^..##' | grep -v '/HEAD ->' | grep -v '/main$' | while read -r b; do git push origin --delete "${b#origin/}"; done || git branch | sed 's#^..##' | grep -v '^main$' | xargs -r git branch -D ;;
add) need_repo; [ $# -gt 0 ] && git add "$@" || git add -A ;;
commit) need_repo; m=$(arg --message "$@") || { echo "missing --message" >&2; exit 1; }; git commit -m "$m" ;;
fetch) need_repo; git fetch "$@" ;;
pull) need_repo; git pull "$@" ;;
push) need_repo; git push "$@" ;;
push-main) need_repo; git push origin HEAD:main ;;
empty-dir) d=$(arg --dir "$@") || { echo "missing --dir" >&2; exit 1; }; rm -rf "$d"; mkdir -p "$d" ;;
restore-dir) src=$(arg --src "$@") || { echo "missing --src" >&2; exit 1; }; dst=$(arg --dst "$@") || { echo "missing --dst" >&2; exit 1; }; rm -rf "$dst"; mkdir -p "$dst"; cp -R "$src"/. "$dst"/ ;;
pr) echo "Use GitHub compare URL or API/gh CLI as available; manual PR creation may be required in Minis." ;;
gh-issues-list) need_repo; api "https://api.github.com/repos/$(repo_slug)/issues?state=open" ;;
gh-issue-create) need_repo; title=$(arg --title "$@") || { echo "missing --title" >&2; exit 1; }; body=$(arg --body "$@" || true); api -X POST "https://api.github.com/repos/$(repo_slug)/issues" -d "{\"title\":\"$title\",\"body\":\"${body:-}\"}" ;;
gh-issue-close) need_repo; num=$(arg --number "$@") || { echo "missing --number" >&2; exit 1; }; api -X PATCH "https://api.github.com/repos/$(repo_slug)/issues/$num" -d '{"state":"closed"}' ;;
gh-labels-list) need_repo; api "https://api.github.com/repos/$(repo_slug)/labels" ;;
gh-label-create) need_repo; name=$(arg --name "$@") || { echo "missing --name" >&2; exit 1; }; color=$(arg --color "$@" || true); api -X POST "https://api.github.com/repos/$(repo_slug)/labels" -d "{\"name\":\"$name\",\"color\":\"${color:-ededed}\"}" ;;
gh-milestones-list) need_repo; api "https://api.github.com/repos/$(repo_slug)/milestones" ;;
gh-milestone-create) need_repo; title=$(arg --title "$@") || { echo "missing --title" >&2; exit 1; }; api -X POST "https://api.github.com/repos/$(repo_slug)/milestones" -d "{\"title\":\"$title\"}" ;;
gh-releases-list) need_repo; api "https://api.github.com/repos/$(repo_slug)/releases" ;;
gh-release-create) need_repo; tag=$(arg --tag "$@") || { echo "missing --tag" >&2; exit 1; }; name=$(arg --name "$@" || true); api -X POST "https://api.github.com/repos/$(repo_slug)/releases" -d "{\"tag_name\":\"$tag\",\"name\":\"${name:-$tag}\"}" ;;
gh-actions-list) need_repo; api "https://api.github.com/repos/$(repo_slug)/actions/workflows" ;;
gh-actions-dispatch) need_repo; wf=$(arg --workflow "$@") || { echo "missing --workflow" >&2; exit 1; }; ref=$(arg --ref "$@" || true); api -X POST "https://api.github.com/repos/$(repo_slug)/actions/workflows/$wf/dispatches" -d "{\"ref\":\"${ref:-main}\"}" ;;
*) echo "unknown command: $cmd" >&2; exit 1 ;;
esac
