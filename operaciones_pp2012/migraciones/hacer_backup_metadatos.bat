set pg_dump="C:\Archivos de programa\PostgreSQL\9.1\bin\pg_dump.exe" 
if exist %pg_dump% goto ok
set pg_dump="C:\Program Files\PostgreSQL\9.1\bin\pg_dump.exe" 
if exist %pg_dump% goto ok
set pg_dump="C:\Archivos de programa\PostgreSQL\9.0\bin\pg_dump.exe" 
if exist %pg_dump% goto ok
echo "no encuentro el pg_dump"
pause
goto fin
:ok
%pg_dump% --host localhost --port 5432 --username "postgres" --format plain --data-only --inserts --column-inserts --no-privileges --no-tablespaces --file "metadatos.sql" --table "encu.operativos" --table "encu.con_opc" --table "encu.formularios" --table "encu.bloques" --table "encu.filtros" --table "encu.matrices" --table "encu.preguntas" --table "encu.opciones" --table "encu.ua" --table "encu.variables" --table "encu.saltos" --table "encu.relaciones" --table "encu.estados_ingreso" "tedede_db"
cd ..
php -f dump_json_pp2012_metadatos.php
cd migraciones
:fin
