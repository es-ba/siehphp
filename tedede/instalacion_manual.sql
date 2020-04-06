/*CREATE ROLE tedede_owner LOGIN PASSWORD 'laclave' VALID UNTIL 'infinity';

CREATE DATABASE tedede_db WITH ENCODING='UTF8' OWNER=tedede_owner LC_COLLATE='Spanish, Argentina' CONNECTION LIMIT=-1;

CREATE ROLE tedede_php LOGIN PASSWORD 'laclave' VALID UNTIL 'infinity';
GRANT CREATE ON DATABASE tedede_db TO tedede_php;
*/
CREATE SCHEMA comun AUTHORIZATION tedede_php;
CREATE SCHEMA dbo AUTHORIZATION tedede_php;
CREATE SCHEMA encu AUTHORIZATION tedede_php;

alter role tedede_php set search_path = encu,dbo,comun,public;

GRANT USAGE ON SCHEMA comun TO public;

CREATE OR REPLACE FUNCTION comun.probar(p_sentencia text)
  RETURNS text AS
$BODY$
begin
  execute p_sentencia;
  return 'Ejecuto sin excepciones';
exception
  when others then
    return sqlstate || ': ' || sqlerrm;
end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION comun.probar(text)
  OWNER TO tedede_php;

