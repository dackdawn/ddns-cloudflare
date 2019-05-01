#!/bin/bash

#This shell can auto update your ip to cloudflare.

#usage:
#0.Install jq curl
#1.Fill out the follow 4 variables.
#2.Use crontab or others to auto run this shell.

#This shell will create a log file in the current directory.
#But it will NOT auto delete this log file. So you should set
#a plan to delete it.

#You MUST input the follow 4 variables: apiKEY email domain zone_identifier
#If you are too lazy to copy the zone_identifier, then it can 
#be left blank, but you must ensure that your top-level domain 
#is a second-level domain.For example:
#the end of your domain MUST be xxx.com rather than xxx.com.cn
#or you can change the 42 lines :
#origin : zone_name=$(echo $domain | awk -F "." '{print $(NF-1)"."$NF}')
#after  : zone_name=$(echo $domain | awk -F "." '{print $(NF-2)"."$(NF-1)"."$NF}')

apiKEY=""
email=""
domain=""
zone_identifier=""

echo "[info] $(date) : start ddns." >> ./ddns.log
#ping -c 1 baidu.com > /dev/null 2>&1
#ping -c 1 google.com > /dev/null 2>&1
curl ip.sb > /dev/null 2>&1
if [ $? -ne 0 ]
then
  echo "[err] $(date) : network error." >> ./ddns.log
  echo "[info] $(date) : end of ddns." >> ./ddns.log
  exit
fi


if [ "$zone_identifier" == "" ]
then
  zone_name=$(echo $domain | awk -F "." '{print $(NF-1)"."$NF}')
  zone_identifier=$(curl -k -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: $email" -H "X-Auth-Key: $apiKEY" -H "Content-Type: application/json" | jq ".result[0].id" | sed 's/\"//g')
fi

remote_result=$(curl -k -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$domain" -H "X-Auth-Email: $email" -H "X-Auth-Key: $apiKEY" -H "Content-Type: application/json")

remote_ip=$(echo $remote_result | jq ".result[0].content" | sed 's/\"//g')
identifier=$(echo $remote_result | jq ".result[0].id" | sed 's/\"//g')

if [ $remote_ip == "null" ]
then
  echo "[err] $(date) : can't find DNS record." >> ./ddns.log
  echo "[info] $(date) : end of ddns." >> ./ddns.log
  exit
fi

#WAN IP
local_ip=$(curl http://ipv4.ip.sb -k -s)
#local_ip=$(curl ip.6655.com/ip.aspx -k -s)

#LAN IP
#local_ip=$(ifconfig eth0.3 | grep "inet addr" | awk -F " " '{print $2}' | awk -F ":" '{print $2}')

if [ $local_ip != $remote_ip ]
then
  echo "[info] $(date) : local_ip and remote_ip are different." >> ./ddns.log
  update_result=$(curl -s -k -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$identifier" -H "X-Auth-Email: $email" -H "X-Auth-Key: $apiKEY" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$domain\",\"content\":\"$local_ip\",\"ttl\":120,\"proxied\":false}")
  if [ $(echo $update_result | jq ".success") == true ]
  then
    echo "[info] $(date) : update success!" >> ./ddns.log
  else
    echo "[err] $(date) : update fail!" >> ./ddns.log
	echo "[err] $(date) : Response is " >> ./ddns.log
	echo "                $update_result" >> ./ddns.log
  fi
else
  echo "[info] $(date) : local_ip and remote_ip are the same." >> ./ddns.log
fi

echo "[info] $(date) : end of ddns." >> ./ddns.log

