@echo off
title Prueba 1 - peli_voto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\peli_voto
echo C:\tacho_actividad8\peli_voto^> flutter test -r expanded --plain-name "primero va la pelicula que deja contentos a mas votantes"
echo.
call flutter test -r expanded --plain-name "primero va la pelicula que deja contentos a mas votantes"
echo.
echo listo> "C:\tacho_actividad8\listo_peli_voto_1.txt"
:espera
if not exist "C:\tacho_actividad8\listo_peli_voto_1.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
