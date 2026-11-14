@echo off
title Prueba 2 - alcancia_cripto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\alcancia_cripto
echo C:\tacho_actividad8\alcancia_cripto^> flutter test -r expanded --plain-name "maquina del tiempo"
echo.
call flutter test -r expanded --plain-name "maquina del tiempo"
echo.
echo listo> "C:\tacho_actividad8\listo_alcancia_cripto_2.txt"
:espera
if not exist "C:\tacho_actividad8\listo_alcancia_cripto_2.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
