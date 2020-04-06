@echo off
rem UTF8:Sí
rem ejecuta el script que se la pasa como parámetro y pone en salida.txt la salida
set psql=psql
set find=find
if z%2==z goto falta_el_parametro
set en_que_base=yeah_db
rem el tercer parámetro puede especificar el servidor ej: --host=server_cvp
if exist configuracion_local.bat call configuracion_local.bat
%psql% %3 %4 --file=%2 %en_que_base% %1 >salida.txt 2>&1
if z%UBICA% == zbmitre136 set find=%systemroot%\system32\find
%find% "ERROR" salida.txt >errores.txt
type errores.txt 
goto fin
:falta_el_parametro
echo '**** ERROR falta especificar agún parametro 
echo el primer parámetro es el usuario el: abel_desa
echo el segundo es el nombre del script
goto fin
:fin
