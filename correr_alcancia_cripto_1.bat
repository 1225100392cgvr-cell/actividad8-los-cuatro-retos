@echo off
title Prueba 1 - alcancia_cripto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\alcancia_cripto
echo C:\tacho_actividad8\alcancia_cripto^> flutter test -r expanded --plain-name "con 100 USD y BTC a 50,000 se compran 0.002 BTC = 200,000 satoshis"
echo.
call flutter test -r expanded --plain-name "con 100 USD y BTC a 50,000 se compran 0.002 BTC = 200,000 satoshis"
echo.
echo listo> "C:\tacho_actividad8\listo_alcancia_cripto_1.txt"
:espera
if not exist "C:\tacho_actividad8\listo_alcancia_cripto_1.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
