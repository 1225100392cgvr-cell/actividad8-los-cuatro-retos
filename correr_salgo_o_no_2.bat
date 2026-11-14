@echo off
title Prueba 2 - salgo_o_no
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\salgo_o_no
echo C:\tacho_actividad8\salgo_o_no^> flutter test -r expanded --plain-name "con lluvia no conviene tender la ropa (rojo)"
echo.
call flutter test -r expanded --plain-name "con lluvia no conviene tender la ropa (rojo)"
echo.
echo listo> "C:\tacho_actividad8\listo_salgo_o_no_2.txt"
:espera
if not exist "C:\tacho_actividad8\listo_salgo_o_no_2.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
