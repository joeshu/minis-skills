#!/bin/sh
set -e
cd /var/minis/workspace/opencode2api-enhanced
printf "== branch ==\n"
git status --short --branch
printf "\n== remotes ==\n"
git remote -v
printf "\n== diff stat ==\n"
git diff --stat || true
printf "\n== staged diff stat ==\n"
git diff --cached --stat || true
printf "\n== unstaged file list ==\n"
git diff --name-only || true
printf "\n== staged file list ==\n"
git diff --cached --name-only || true
printf "\n== recent commits ==\n"
git log --oneline -5
printf "\n== smoke hint ==\n"
echo "Run: npm run verify:smoke"
