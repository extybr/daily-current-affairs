@echo off
mode con cols=125 lines=50
curl wttr.in/Komsomolsk-on-Amur?lang=ru
:: mode con codepage select=866 > nul
echo ---------------
set "n=&echo."
set "IP=&curl https://api.ipify.org"
echo Your IP address: %IP% %n%
echo --------------- %n%
cmd
