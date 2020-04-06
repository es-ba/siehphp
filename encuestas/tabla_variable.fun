##FUN
tabla_variable
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
DROP FUNCTION if exists encu.tabla_variable(text);
/*otra*/
CREATE OR REPLACE FUNCTION encu.tabla_variable(p_var text)
  RETURNS text AS
$BODY$
DECLARE
   v_tabla text;
BEGIN
    SELECT table_name into v_tabla
      FROM information_schema.columns  
      WHERE table_name IN ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_','plana_a1_m','plana_a1_x','pla_ext_hog','diario_actividades_ajustado_vw') 
        AND table_schema='encu' 
        AND substr(column_name,5)=p_var
      ORDER BY substr(column_name,5) NOT IN ('enc','hog','mie','exm','tlg') 
      LIMIT 1;
    RETURN v_tabla;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
ALTER FUNCTION encu.tabla_variable(text)
  OWNER TO tedede_php;
