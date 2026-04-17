#!/bin/sh
set -e
[ -n "$ALI" ] || { echo 'ALI not set'; exit 1; }
[ -n "$TARGET" ] || { echo 'TARGET not set (example: TARGET=HEAD~1 or TARGET=<commit>)'; exit 1; }
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
set -e
git config --global --add safe.directory /root/opencode2api-enhanced || true
cd /root/opencode2api-enhanced
printf "== before rollback ==\n"
git --no-pager log --oneline -3
printf "\n== reset ==\n"
git reset --hard '"'$TARGET'"'
printf "\n== npm install ==\n"
npm install
printf "\n== restart ==\n"
pkill -f "/root/opencode2api-enhanced/index.js" || true
pkill -f "node index.js" || true
pkill -f "opencode serve --hostname 127.0.0.1 --port 10001" || true
rm -f /root/opencode-serve.log /root/opencode2api-enhanced/opencode2api.log
nohup /usr/local/bin/opencode serve --hostname 127.0.0.1 --port 10001 >/root/opencode-serve.log 2>&1 </dev/null &
nohup env API_KEY="$API_KEY" OPENCODE_PROXY_MANAGE_BACKEND=false OPENCODE_SERVER_URL="http://127.0.0.1:10001" OPENCODE_PROFILE=stable /usr/bin/node /root/opencode2api-enhanced/index.js >/root/opencode2api-enhanced/opencode2api.log 2>&1 </dev/null &
sleep 6
printf "\n== ready ==\n"
curl -sS -m 10 -i http://127.0.0.1:10000/health/ready
printf "\n"
'
