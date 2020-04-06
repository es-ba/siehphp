copy \\10.32.72.10\en_desarrollo\etoi143_produc_db.backup 
set post_dir=%ProgramFiles%\PostgreSQL\9.3\bin\
set psql="%post_dir%\psql.exe"
set prestore="%post_dir%\pg_restore.exe"
set PGOPTIONS=-c client_encoding=UTF8
set PGCLIENTENCODING=utf8
%psql% --file=eliminar_etoi143_copia_db.psql postgres postgres >salida.txt 2>errores.txt
%prestore% --host localhost --port 5432 --username "postgres" --dbname "etoi143_copia_db" --no-password etoi143_produc_db.backup
