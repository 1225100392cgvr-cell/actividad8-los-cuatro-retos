@echo off
title Prueba 4 - michi_postal
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\michi_postal
echo C:\tacho_actividad8\michi_postal^> flutter test -r expanded --plain-name "la diagonal"
echo.
call flutter test -r expanded --plain-name "la diagonal"
echo.
echo listo> "C:\tacho_actividad8\listo_michi_postal_4.txt"
:espera
if not exist "C:\tacho_actividad8\listo_michi_postal_4.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
