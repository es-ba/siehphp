-- Database: sieh_db
-- DROP DATABASE sieh_db;

CREATE DATABASE sieh_db
  WITH OWNER = tedede_owner
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Spanish_Spain.1252'
       LC_CTYPE = 'Spanish_Spain.1252'
       CONNECTION LIMIT = -1;
--permisoa para los usuarios tedede_owner y tedede_php por el momento, hay que determinar si se define uno nuevo
--GRANT CONNECT, TEMPORARY ON DATABASE sieh_db TO public;
GRANT ALL ON DATABASE sieh_db TO tedede_owner;
GRANT CREATE ON DATABASE sieh_db TO tedede_php;

