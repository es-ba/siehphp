call el_path.bat
set pg_dump="pg_dump"
%pg_dump% --host localhost --port 5432 --username yeahowner --format plain --ignore-version --file baseComun.sql --schema comun yeah_db 
%pg_dump% --host localhost --port 5432 --username yeahowner --format plain --ignore-version --file baseYeah.sql --schema yeah --schema dbo yeah_db 
%pg_dump% --host localhost --port 5432 --username yeahowner --format plain --ignore-version --file estructuraYeah.sql --schema-only --schema yeah --schema dbo yeah_db 
%pg_dump% --host localhost --port 5432 --username yeahowner --format plain --ignore-version --file estructuraResto.sql --schema-only --exclude-schema=yeah --exclude-schema=comun --exclude-schema=dbo yeah_db 
php -f dump_json_yeah.php
pause