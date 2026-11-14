@echo off
title Prueba 3 - alcancia_cripto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\alcancia_cripto
echo C:\tacho_actividad8\alcancia_cripto^> flutter test -r expanded --plain-name "si el precio llega en 0 no truena: la cantidad es 0"
echo.
call flutter test -r expanded --plain-name "si el precio llega en 0 no truena: la cantidad es 0"
echo.
echo listo> "C:\tacho_actividad8\listo_alcancia_cripto_3.txt"
:espera
if not exist "C:\tacho_actividad8\listo_alcancia_cripto_3.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
