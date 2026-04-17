#!/bin/sh
set -e
DATE_STR=$(date '+%Y-%m-%d %H:%M:%S')
cat <<EOF
# 发布报告

- 时间: $DATE_STR
- 项目: joeshu/opencode2api-enhanced
- 本地目录: /var/minis/workspace/opencode2api-enhanced
- 服务器: 118.190.200.12

## 本次改动
- 

## Git 信息
- 分支: 
- 提交: 
- 提交信息: 

## 本地验证
- verify:smoke: 
- 其他测试: 

## 服务器动作
- git pull: 
- npm install: 
- server smoke: 
- restart: 

## 健康检查
- 10000: 
- 10001: 
- /health/live: 
- /health/ready: 
- /v1/models: 

## 日志观察
- serve log: 
- proxy log: 

## 风险与后续
- 风险: 
- 后续: 
EOF
