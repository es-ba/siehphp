set post_dir=%ProgramFiles%\PostgreSQL\9.3\bin\
set psql="%post_dir%\psql.exe"
set prestore="%post_dir%\pg_restore.exe"
set PGOPTIONS=-c client_encoding=UTF8
set PGCLIENTENCODING=utf8
echo "empiezo la copia de todas las bases de hoy" >salida.txt
call subir_una_base_nocturnamente.bat cvp      produc copia 
:fin 