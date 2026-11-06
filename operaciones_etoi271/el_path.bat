if "%PG_PATH%"=="" goto poner_path
goto fin
:poner_path
if exist "c:\Program Files (x86)\PostgreSQL\8.4\bin"\psql.exe set PG_PATH=c:\Program Files (x86)\PostgreSQL\8.4\bin
if exist "%ProgramFiles%\PostgreSQL\8.4\bin"\psql.exe set PG_PATH=%ProgramFiles%\PostgreSQL\8.4\bin
if exist "%ProgramFiles%\PostgreSQL\9.0\bin"\psql.exe set PG_PATH=%ProgramFiles%\PostgreSQL\9.0\bin
if exist "%ProgramFiles%\PostgreSQL\9.1\bin"\psql.exe set PG_PATH=%ProgramFiles%\PostgreSQL\9.1\bin
if exist "%ProgramFiles%\PostgreSQL\9.2\bin"\psql.exe set PG_PATH=%ProgramFiles%\PostgreSQL\9.2\bin
if exist "%ProgramFiles%\PostgreSQL\9.3\bin"\psql.exe set PG_PATH=%ProgramFiles%\PostgreSQL\9.3\bin
if exist "%ProgramFiles%\PostgreSQL\9.5\bin"\psql.exe set PG_PATH=%ProgramFiles%\PostgreSQL\9.5\bin
set PATH=%PATH%;%PG_PATH%
set PGOPTIONS=-c client_encoding=UTF8
set PGCLIENTENCODING=utf8
:fin