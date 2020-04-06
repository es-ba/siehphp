set post_dir=%ProgramFiles%\PostgreSQL\9.5\bin

set psql="%post_dir%\psql.exe"
set prestore="%post_dir%\pg_restore.exe"
set PGOPTIONS=-c client_encoding=UTF8
set PGCLIENTENCODING=utf8
echo "empiezo la copia de todas las bases de hoy" >salida.txt

rem call subir_una_base_nocturnamente.bat eah2015   produc copia
rem goto fin
rem así se comenta en DOS

rem call subir_una_base_nocturnamente.bat etoi163   produc copia 
rem call subir_una_base_nocturnamente.bat eah2016   produc copia 
rem call subir_una_base_nocturnamente.bat ut2016    produc copia 

rem call subir_una_base_nocturnamente.bat colon2015 produc copia 

REM call subir_una_base_nocturnamente.bat cvp       produc copia 
rem call subir_una_base_nocturnamente.bat etoi153   produc copia 
rem call subir_una_base_nocturnamente.bat eah2014   produc copia:fin 