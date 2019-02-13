@echo off
set ROOT=E:\ddns
set IP = none
:loop
E:\ddns\curl\curl http://checkip.dns.he.net -o %ROOT%\out.txt
Set n=0
for /f "skip=7 tokens=6" %%i in (%ROOT%\out.txt) do (
If %n% EQU 0 (
echo %%i > %ROOT%\ip.txt
Set n = 1
)
)
for /f "delims=<" %%i in (%ROOT%\ip.txt) do (
Set IP=%%i
)

E:\ddns\curl\curl -X PUT https://api.cloudflare.com/client/v4/zones/%zoneid%/dns_records/%id% -H "X-Auth-Email: example@example.com" -H "X-Auth-Key: $key" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"%name%\",\"content\":\"%IP%\",\"ttl\":120,\"proxied\":false}" -o out.txt

choice /t 300 /d y /n >nul
goto loop
