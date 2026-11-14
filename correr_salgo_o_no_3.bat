@echo off
title Prueba 3 - salgo_o_no
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\salgo_o_no
echo C:\tacho_actividad8\salgo_o_no^> flutter test -r expanded --plain-name "viento de 45 km/h en bici resta 60 puntos (amarillo)"
echo.
call flutter test -r expanded --plain-name "viento de 45 km/h en bici resta 60 puntos (amarillo)"
echo.
echo listo> "C:\tacho_actividad8\listo_salgo_o_no_3.txt"
:espera
if not exist "C:\tacho_actividad8\listo_salgo_o_no_3.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
