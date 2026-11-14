@echo off
title Prueba 5 - michi_postal
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\michi_postal
echo C:\tacho_actividad8\michi_postal^> flutter test -r expanded --plain-name "el filtro"
echo.
call flutter test -r expanded --plain-name "el filtro"
echo.
echo listo> "C:\tacho_actividad8\listo_michi_postal_5.txt"
:espera
if not exist "C:\tacho_actividad8\listo_michi_postal_5.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
