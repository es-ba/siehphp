set post_dir=%ProgramFiles%\PostgreSQL\9.3\bin\
set psql="%post_dir%\psql.exe"
%psql% --command="select clock_timestamp(),encu.actualizar_monitoreo_viv_ant_ope()" --dbname=etoi152_produc_db --username=operador_backup --no-password >>actualizar_monitoreo_viv_ant_ope.txt 2>>&1
