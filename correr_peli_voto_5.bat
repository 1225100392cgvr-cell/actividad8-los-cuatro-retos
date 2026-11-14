@echo off
title Prueba 5 - peli_voto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\peli_voto
echo C:\tacho_actividad8\peli_voto^> flutter test -r expanded --plain-name "arma la URL completa del poster"
echo.
call flutter test -r expanded --plain-name "arma la URL completa del poster"
echo.
echo listo> "C:\tacho_actividad8\listo_peli_voto_5.txt"
:espera
if not exist "C:\tacho_actividad8\listo_peli_voto_5.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
