call ..\operaciones\el_path.bat
set pg_restore="%PG_PATH%/pg_restore.exe" 
%pg_restore% --host localhost --port 5432 --username "postgres" --dbname "tedede_capa_db" --verbose "eah2012_produc_schema.dump" 
%pg_restore% --host localhost --port 5432 --username "postgres" --dbname "tedede_capa_db" --verbose --disable-triggers  "eah2012_produc_data.dump" 
%pg_restore% --host localhost --port 5432 --username "postgres" --dbname "tedede_capa_db" --verbose --disable-triggers "eah2012_produc_2011.dump" 
