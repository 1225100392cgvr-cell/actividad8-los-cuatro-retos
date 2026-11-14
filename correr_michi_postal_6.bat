@echo off
title Prueba 6 - michi_postal
mode con cols=130 lines=18
cd /d C:\tacho_actividad8\michi_postal
echo C:\tacho_actividad8\michi_postal^> flutter test -r expanded --plain-name "cada ocasion trae 3 frases sugeridas"
echo.
call flutter test -r expanded --plain-name "cada ocasion trae 3 frases sugeridas"
echo.
echo listo> "C:\tacho_actividad8\listo_michi_postal_6.txt"
:espera
if not exist "C:\tacho_actividad8\listo_michi_postal_6.txt.cap" ( timeout /t 1 /nobreak >nul & goto espera )
exit
