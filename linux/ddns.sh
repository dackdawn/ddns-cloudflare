#!/bin/bash
last_ipv4="0.0.0.0"
while : ; do
now_ipv4=$(curl http://ipv4.ip.sb -k -s)
#now_ipv4=$(ifconfig pppoe | grep "inet addr" | awk -F " " '{print $2}' | awk -F ":" '{print $2}')
if [ $now_ipv4 != $last_ipv4 ];
then
        last_ipv4=$now_ipv4
result=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$id" -H "X-Auth-Email: example@example.com" -H "X-Auth-Key: $key" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$domain\",\"content\":\"$ip_ipv4\",\"ttl\":120,\"proxied\":false}" -k -s)
fi
done
sleep 3600
