##FUN
contiene_findelinea
##ESQ
comun
##PARA
revisar  
##DETALLE
NUEVA
##PROVISORIO
-- Determina si en la cadena que se pasa como parámetro existe al menos un fin de línea.
-- DROP FUNCTION comun.contiene_findelinea(text);

CREATE OR REPLACE FUNCTION comun.contiene_findelinea(p_cadena text)
  RETURNS boolean AS
$BODY$
DECLARE
  v2  text;
BEGIN
    select (regexp_matches(p_cadena, '\n')) into v2;
    if v2 is not null THEN
        --raise exception 'Existe al menos un fin de línea en el texto (%) ',p_cadena;
        return true;
    end if;
  return false;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.contiene_findelinea(text)
  OWNER TO tedede_php;
  
##CASOS_SQL 
-- select comun.contiene_findelinea(null) ; --devuelve false
-- select comun.contiene_findelinea('abcdefgh/') ; --devuelve false
-- select comun.contiene_findelinea('Se reemplaza x area 8140
 (semana 4 comuna 5)') ; --devuelve true
 