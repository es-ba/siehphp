set post_dir=%ProgramFiles%\PostgreSQL\9.3\bin\
set psql="%post_dir%\psql.exe"
%psql% --command='select encu.fin_de_campo_automatico()' --dbname=eah2013_produc_db --username=operador_backup --no-password >fin_de_campo_automatico.txt 2>fin_de_campo_automatico.log