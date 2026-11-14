@echo off
title Prueba 2 - michi_postal
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\michi_postal
echo C:\tacho_actividad8\michi_postal^> flutter test -r expanded --plain-name "sin id pide un gato al azar"
echo.
call flutter test -r expanded --plain-name "sin id pide un gato al azar"
echo.
echo listo> "C:\tacho_actividad8\listo_michi_postal_2.txt"
:espera
if not exist "C:\tacho_actividad8\listo_michi_postal_2.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
