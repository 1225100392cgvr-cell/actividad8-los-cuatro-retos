@echo off
title Prueba 1 - salgo_o_no
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\salgo_o_no
echo C:\tacho_actividad8\salgo_o_no^> flutter test -r expanded --plain-name "15 grados, despejado y sin viento: correr da verde y 100 puntos"
echo.
call flutter test -r expanded --plain-name "15 grados, despejado y sin viento: correr da verde y 100 puntos"
echo.
echo listo> "C:\tacho_actividad8\listo_salgo_o_no_1.txt"
:espera
if not exist "C:\tacho_actividad8\listo_salgo_o_no_1.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
