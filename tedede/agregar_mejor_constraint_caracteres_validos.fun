##FUN
agregar_mejor_constraint_caracteres_validos
##ESQ
comun
##PARA
revisar 
##DETALLE
##PROVISORIO

CREATE OR REPLACE FUNCTION comun.agregar_mejor_constraint_caracteres_validos(p_nombre_esquema text, p_nombre_tabla text, p_nombre_columna text, p_mejorar_antes boolean)
  RETURNS boolean AS
$BODY$
DECLARE
    v_nombre_constraint varchar;
    v_sql text;
    vVersion record;
BEGIN
    if p_mejorar_antes then
      EXECUTE 'UPDATE '||p_nombre_esquema||'.'||p_nombre_tabla||' SET '||p_nombre_columna||' = TRIM('||p_nombre_columna||') WHERE '||p_nombre_columna||' <> TRIM('||p_nombre_columna||')'; 
      EXECUTE 'UPDATE '||p_nombre_esquema||'.'||p_nombre_tabla||' SET '||p_nombre_columna||' = comun.buscar_reemplazar_espacios_raros('||p_nombre_columna||') WHERE '||p_nombre_columna||' <> comun.buscar_reemplazar_espacios_raros('||p_nombre_columna||')'; 
    end if;
    v_nombre_constraint := 'texto invalido en ' || p_nombre_columna || ' de tabla ' || p_nombre_tabla;
    v_sql:='ALTER TABLE '||p_nombre_esquema||'.'||p_nombre_tabla||' DROP CONSTRAINT "'|| v_nombre_constraint || '";';
    BEGIN
      EXECUTE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    FOR vVersion in 
        select 1 AS orden,'codigo' as version 
        union select 0,'identificador' 
        union select 2,'extendido' 
        union select 3,'castellano' 
        union select 4,'formula'
        union select 5,'json'
        union select 6,'castellano y formula'
        union select 99,'cualquiera'
        ORDER BY orden
    LOOP
      BEGIN
        v_sql:='ALTER TABLE '||p_nombre_esquema||'.'||p_nombre_tabla||' ADD CONSTRAINT "'|| v_nombre_constraint || '" CHECK (comun.cadena_valida('||p_nombre_columna||','''||vVersion.version||'''));';
        EXECUTE v_sql;
        EXIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
  END LOOP;
  RETURN true;
  /* Para correrlo:
    select comun.agregar_mejor_constraint_caracteres_validos('encu','consistencias','con_importancia',true);
  */
END;
$BODY$
  LANGUAGE plpgsql ;
ALTER FUNCTION comun.agregar_mejor_constraint_caracteres_validos(text, text, text, boolean)
  OWNER TO tedede_php;