##FUN
nombre_largo_para_documentacion_ut
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
DROP FUNCTION if exists encu.nombre_largo_para_documentacion_ut(text,text);
/*otra*/
CREATE OR REPLACE FUNCTION encu.nombre_largo_para_documentacion_ut(p_var text, p_baspro text)
  RETURNS text AS
$BODY$
DECLARE
   v_nombre_largo_para_documentacion text;
BEGIN
select trim(coalesce(var_nombre_dr,
                    varcal_nombre_dr,
                    nullif(
                      coalesce(pre_texto,'')||' '||coalesce(var_texto,''),
                      ' '
                    ),
                    varcal_nombre,
                    basprovar_var
                    )
                    ) into v_nombre_largo_para_documentacion 
              FROM encu.baspro_var_ut b 
                LEFT JOIN encu.variables v ON b.basprovar_ope = v.var_ope AND b.basprovar_var = v.var_var
                LEFT JOIN encu.varcal c ON b.basprovar_ope = c.varcal_ope AND b.basprovar_var = c.varcal_varcal
                LEFT JOIN encu.preguntas p ON v.var_ope = p.pre_ope AND v.var_pre = p.pre_pre 
where basprovar_var = p_var and basprovar_baspro = p_baspro and basprovar_ope = dbo.ope_actual();
RETURN v_nombre_largo_para_documentacion;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
ALTER FUNCTION encu.nombre_largo_para_documentacion_ut(text,text)
  OWNER TO tedede_php;
