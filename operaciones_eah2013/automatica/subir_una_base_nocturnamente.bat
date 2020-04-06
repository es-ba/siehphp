set proyecto=%1
set nombre_archivo_backup=%proyecto%_%2_db.backup 
set nombre_base_local=%proyecto%_%3_db
echo copiando %proyecto% >>salida.txt
copy \\10.32.72.10\en_desarrollo\%nombre_archivo_backup% 
rem %psql% --file=eliminar_%nombre_base_local%.psql postgres postgres >>salida.txt 2>>errores.txt
%psql% --command="drop database if exists %nombre_base_local%;" -h localhost -p 5435 postgres postgres >>salida.txt 2>>errores.txt
%psql% --command="create database %nombre_base_local% WITH OWNER = tedede_owner ENCODING = 'UTF8';" -h localhost -p 5435 postgres postgres >>salida.txt 2>>errores.txt
%prestore% --host localhost --port 5435 --username "postgres" --dbname "%nombre_base_local%" --no-password %nombre_archivo_backup% >>salida.txt 2>>errores.txt
