@echo off
title Prueba 3 - peli_voto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\peli_voto
echo C:\tacho_actividad8\peli_voto^> flutter test -r expanded --plain-name "sin votos no se consulta nada y regresa lista vacia"
echo.
call flutter test -r expanded --plain-name "sin votos no se consulta nada y regresa lista vacia"
echo.
echo listo> "C:\tacho_actividad8\listo_peli_voto_3.txt"
:espera
if not exist "C:\tacho_actividad8\listo_peli_voto_3.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
