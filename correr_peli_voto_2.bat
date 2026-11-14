@echo off
title Prueba 2 - peli_voto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\peli_voto
echo C:\tacho_actividad8\peli_voto^> flutter test -r expanded --plain-name "a empate de votos gana la mejor calificada"
echo.
call flutter test -r expanded --plain-name "a empate de votos gana la mejor calificada"
echo.
echo listo> "C:\tacho_actividad8\listo_peli_voto_2.txt"
:espera
if not exist "C:\tacho_actividad8\listo_peli_voto_2.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
