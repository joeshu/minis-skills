#!/bin/sh
set -e
[ -n "$ALI" ] || { echo 'ALI not set'; exit 1; }
[ -n "$API_KEY" ] || { echo 'API_KEY not set'; exit 1; }
sshpass -p "$ALI" ssh -o StrictHostKeyChecking=accept-new root@118.190.200.12 '
set -e
printf "== models ==\n"
curl -sS -m 20 http://127.0.0.1:10000/v1/models -H "Authorization: Bearer '$API_KEY'"
printf "\n\n== chat smoke ==\n"
curl -sS -m 90 http://127.0.0.1:10000/v1/chat/completions \
  -H "Authorization: Bearer '$API_KEY'" \
  -H "Content-Type: application/json" \
  -d '\''{"model":"opencode/kimi-k2.5-free","messages":[{"role":"user","content":"请回复 ok"}],"stream":false}'\''
printf "\n\n== responses smoke ==\n"
curl -sS -m 90 http://127.0.0.1:10000/v1/responses \
  -H "Authorization: Bearer '$API_KEY'" \
  -H "Content-Type: application/json" \
  -d '\''{"model":"opencode/kimi-k2.5-free","input":"请回复 ok","stream":false}'\''
printf "\n"
'
