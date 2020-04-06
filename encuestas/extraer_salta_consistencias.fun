##FUN
extraer_salta_consistencias
##ESQ
comun
##PARA
produccion
##PUBLICA
Sí
##PAR
p_texto TEXT
##TIPO_DEVUELTO
TEXT[]
##CUERPO
-- DROP FUNCTION comun.extraer_salta_consistencias(text);
CREATE OR REPLACE FUNCTION comun.extraer_salta_consistencias(p_texto text)
    RETURNS text[] AS
        $BODY$
            declare
              vpos integer;
              vcons text[];
            begin
                vpos=strpos(p_texto,' SALTA ');
                IF vpos>0 then
                    SELECT string_to_array(SUBSTR($1, vpos+7),  ' ') INTO vcons;
                END IF;
                RETURN vcons;   
            end
        $BODY$
    LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.extraer_salta_consistencias(p_texto text)
    OWNER TO tedede_php;

--select SUBSTR(' abcsalta SALTA QWZ_E 3SW8', strpos(' abcsalta SALTA QWZ_E 3SW8',' SALTA ')+7), string_to_array(SUBSTR(' abcsalta SALTA QWZ_E 3SW8', strpos(' abcsalta SALTA QWZ_E 3SW8',' SALTA ')+7),  ' ')
--select SUBSTR(p_texto, strpos(p_texto,' SALTA ')+7), string_to_array(SUBSTR(p_texto, strpos(p_texto,' SALTA ')+7),  ' ')

--select comun.extraer_salta_consistencias(' abcsalta SALTA QWZ_E 3SW8'),{QWZ_E,3SW8}
--select comun.extraer_salta_consistencias(' abcsalta QWZ_E 3SW8'),null::text[]