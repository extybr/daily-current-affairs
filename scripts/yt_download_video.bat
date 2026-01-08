@echo off

cd /d "C:\Users\%USERNAME%\Desktop\yt-dlp"
powershell -command "$url = Get-Clipboard; if ($url) { .\yt-dlp.exe --proxy http://127.0.0.1:1080 -f 'best[height=480]' $url } else { echo 'url not found!' }"

pause