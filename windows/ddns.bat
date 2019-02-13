@echo off
set ROOT=E:\ddns
set IP = none
:loop
curl\curl http://ipv4.ip.sb -o out.txt -s

for /f "delims=<" %%i in (out.txt) do (
Set IP=%%i
)

curl\curl -s -X PUT https://api.cloudflare.com/client/v4/zones/%zoneid%/dns_records/%id% -H "X-Auth-Email: example@example.com" -H "X-Auth-Key: %key%" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"%name%\",\"content\":\"%IP%\",\"ttl\":120,\"proxied\":false}" -o out.txt

choice /t 300 /d y /n >nul
goto loop
