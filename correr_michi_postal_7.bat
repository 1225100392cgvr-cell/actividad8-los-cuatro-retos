@echo off
title Prueba 7 - michi_postal
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\michi_postal
echo C:\tacho_actividad8\michi_postal^> flutter test -r expanded --plain-name "guardar una postal la agrega al album"
echo.
call flutter test -r expanded --plain-name "guardar una postal la agrega al album"
echo.
echo listo> "C:\tacho_actividad8\listo_michi_postal_7.txt"
:espera
if not exist "C:\tacho_actividad8\listo_michi_postal_7.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
