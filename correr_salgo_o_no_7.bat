@echo off
title Prueba 7 - salgo_o_no
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\salgo_o_no
echo C:\tacho_actividad8\salgo_o_no^> flutter test -r expanded --plain-name "muestra la temperatura y el veredicto del plan"
echo.
call flutter test -r expanded --plain-name "muestra la temperatura y el veredicto del plan"
echo.
echo listo> "C:\tacho_actividad8\listo_salgo_o_no_7.txt"
:espera
if not exist "C:\tacho_actividad8\listo_salgo_o_no_7.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
