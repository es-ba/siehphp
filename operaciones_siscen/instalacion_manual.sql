/*
CREATE ROLE siscen_owner LOGIN PASSWORD 'laclave' VALID UNTIL 'infinity';

CREATE DATABASE siscen_db WITH ENCODING='UTF8' OWNER=siscen_owner LC_COLLATE='Spanish, Argentina' CONNECTION LIMIT=-1;

CREATE ROLE siscen_php LOGIN PASSWORD 'laclave' VALID UNTIL 'infinity';
GRANT CREATE ON DATABASE siscen_db TO siscen_php;
*/
CREATE SCHEMA siscen AUTHORIZATION siscen_php;
CREATE SCHEMA comun AUTHORIZATION siscen_php;

alter role siscen_php set search_path = siscen,comun,public;

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
  OWNER TO siscen_php;

GRANT USAGE ON SCHEMA siscen TO siscen_php;
