#!/bin/bash
last_ipv4="0.0.0.0"
zoneid=""
identifier=""
apiKEY=""
email=""
domain=""
while true
do
  now_ipv4=$(curl http://ipv4.ip.sb -k -s)
  #now_ipv4=$(ifconfig eth0.3 | grep "inet addr" | awk -F " " '{print $2}' | awk -F ":" '{print $2}')
  if [ $now_ipv4 != $last_ipv4 ];
  then
    last_ipv4=$now_ipv4
    result=$(curl -s -k -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$identifier" -H "X-Auth-Email: $email" -H "X-Auth-Key: $apiKEY" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$domain\",\"content\":\"$last_ipv4\",\"ttl\":120,\"proxied\":false}")
  fi
  sleep 3600
done
