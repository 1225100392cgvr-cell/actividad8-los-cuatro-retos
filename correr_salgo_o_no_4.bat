@echo off
title Prueba 4 - salgo_o_no
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\salgo_o_no
echo C:\tacho_actividad8\salgo_o_no^> flutter test -r expanded --plain-name "el puntaje nunca baja de 0 aunque haya tormenta"
echo.
call flutter test -r expanded --plain-name "el puntaje nunca baja de 0 aunque haya tormenta"
echo.
echo listo> "C:\tacho_actividad8\listo_salgo_o_no_4.txt"
:espera
if not exist "C:\tacho_actividad8\listo_salgo_o_no_4.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
