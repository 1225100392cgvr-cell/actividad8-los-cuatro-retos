@echo off
title Prueba 4 - peli_voto
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\peli_voto
echo C:\tacho_actividad8\peli_voto^> flutter test -r expanded --plain-name "lee el JSON de TMDB y rellena lo que falta"
echo.
call flutter test -r expanded --plain-name "lee el JSON de TMDB y rellena lo que falta"
echo.
echo listo> "C:\tacho_actividad8\listo_peli_voto_4.txt"
:espera
if not exist "C:\tacho_actividad8\listo_peli_voto_4.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
