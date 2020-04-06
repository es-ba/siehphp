##FUN
destino_variable
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
DROP FUNCTION if exists encu.destino_variable(text,text);
/*otra*/
CREATE OR REPLACE FUNCTION encu.destino_variable(p_var text, p_baspro text)
  RETURNS text AS
$BODY$
DECLARE
   v_destino text;
   v_cuantos integer;
   v_for text;
   v_mat text;
BEGIN
    select distinct(varcal_destino), count(*) 
      into v_destino, v_cuantos 
      from encu.varcal 
      where varcal_varcal = p_var and varcal_ope = dbo.ope_actual() 
      group by varcal_destino;
    if v_cuantos > 0 then
      return v_destino;
    end if;
    select var_for, var_mat into v_for, v_mat 
      from encu.variables 
      where var_var = p_var and var_ope = dbo.ope_actual();
    if v_for='I1' or v_for='S1' and v_mat='P' then
      v_destino = 'mie';
    elsif v_for='A1' or v_for = 'S1' then
      v_destino = 'hog';
    elsif v_for='A1' and v_mat = 'X' then
      v_destino = 'exm';
    end if;
    RETURN v_destino;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
ALTER FUNCTION encu.destino_variable(text, text)
  OWNER TO tedede_php;
