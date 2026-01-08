@echo off
color 0B
mode con:cols=100 lines=20

::curl --max-time 5 -i -s https://p.thenewone.lol:8443/proxy.pac

for /f "tokens=2 delims= " %%i in ('curl --max-time 5 -i -s https://p.thenewone.lol:8443/proxy.pac ^| findstr /C:"Location:"') do powershell "Set-Clipboard '%%i'" && echo [+] URL copied: %%i

::cmd