#!/bin/sh
set -e
[ -n "$ALI" ] || { echo 'ALI not set'; exit 1; }
[ -n "$API_KEY" ] || { echo 'API_KEY not set'; exit 1; }

# 0) require GitHub Actions green before deploy
sh /var/minis/skills/opencode2api-aliyun-node-ops/scripts/check_github_actions_green.sh

HOST='root@118.190.200.12'
API_KEY_B64=$(python3 -c 'import os,base64; print(base64.b64encode(os.environ["API_KEY"].encode()).decode())')

# 1) stop old processes first
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "== stop old processes ==\n"; pkill -f "/root/opencode2api-enhanced/index.js" || true; pkill -f "node index.js" || true; pkill -f "opencode serve --hostname 127.0.0.1 --port 10001" || true'

# 1.5) ensure 10000 is really free before starting new proxy
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== ensure 10000 is free ==\n"; ss -lntp | grep ":10000 " || true'

# 2) pull latest code
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== git pull ==\n"; git config --global --add safe.directory /root/opencode2api-enhanced || true; chown -R root:root /root/opencode2api-enhanced || true; cd /root/opencode2api-enhanced; git pull --ff-only'

# 3) install deps
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== npm install ==\n"; cd /root/opencode2api-enhanced; npm install; npm install -g opencode-ai'

# 4) run smoke with no old process interference
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== smoke ==\n"; cd /root/opencode2api-enhanced; npm run verify:smoke'

# 5) start backend
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== start backend ==\n"; rm -f /root/opencode-serve.log; nohup /usr/local/bin/opencode serve --hostname 127.0.0.1 --port 10001 >/root/opencode-serve.log 2>&1 </dev/null &'

# 6) start proxy
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" "printf '\n== start proxy ==\n'; API_KEY=\$(printf %s '$API_KEY_B64' | base64 -d) sh -lc 'rm -f /root/opencode2api-enhanced/opencode2api.log; cd /root/opencode2api-enhanced; nohup env API_KEY=\"\$API_KEY\" OPENCODE_PROXY_MANAGE_BACKEND=false OPENCODE_SERVER_URL=\"http://127.0.0.1:10001\" OPENCODE_PROFILE=stable /usr/bin/node /root/opencode2api-enhanced/index.js >/root/opencode2api-enhanced/opencode2api.log 2>&1 </dev/null &'"

# 7) wait
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'sleep 8'

# 8) ports
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== ports ==\n"; ss -lntp | grep -E "10000|10001" || true'

# 9) live
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== live ==\n"; curl -sS -m 10 http://127.0.0.1:10000/health/live; echo'

# 10) ready
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" 'printf "\n== ready ==\n"; curl -sS -m 10 -i http://127.0.0.1:10000/health/ready; echo'

# 11) models smoke
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new "$HOST" "API_KEY=\$(printf %s '$API_KEY_B64' | base64 -d) python3 -c 'import os,urllib.request; req=urllib.request.Request(\"http://127.0.0.1:10000/v1/models\",headers={\"Authorization\":\"Bearer \"+os.environ[\"API_KEY\"]}); print(); print(\"== models ==\"); print(urllib.request.urlopen(req,timeout=20).read().decode())'"
