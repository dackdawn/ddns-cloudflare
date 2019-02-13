#!/bin/bash
ip_ipv4=$(curl http://ipv4.ip.sb -k -s)
result=$(curl -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$id" -H "X-Auth-Email: example@example.com" -H "X-Auth-Key: $key" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$domain\",\"content\":\"$ip_ipv4\",\"ttl\":120,\"proxied\":false}" -k -s)

echo $result
