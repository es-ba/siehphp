CREATE OR REPLACE FUNCTION encu.agregar_variable_tem(p_ope text, p_blo text, p_var text, p_orden integer, p_texto text, p_conopc text, p_tipovar text)
  RETURNS text AS
$BODY$
DECLARE
  v_sql text;
BEGIN
  if p_tipovar='numeros' then 
    v_sql:=replace($$ALTER TABLE encu.plana_tem_ ADD column pla_#VARIABLE# integer$$,'#VARIABLE#',p_var);
  elseif p_tipovar='texto' then 
    v_sql:=replace($$ALTER TABLE encu.plana_tem_ ADD column pla_#VARIABLE# text$$,'#VARIABLE#',p_var);
  else
    raise exception 'No se como agregar variables de tipo %', var_tipovar;
  end if;
  execute v_sql;
  INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_for, pre_mat, 
            pre_blo, pre_orden, pre_tlg)
    VALUES (p_ope, upper(p_var), 'TEM', '',
            p_blo, p_orden, 1);
  INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, 
            var_conopc, var_tipovar, var_tlg)
    VALUES (p_ope, 'TEM', '',upper(p_var), p_var, p_texto,
            p_conopc, p_tipovar, 1);
  return 'ok';
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.agregar_variable_tem(text, text, text, integer, text, text, text)
  OWNER TO postgres;
---------------------------
    
---------------------------
select encu.agregar_variable_tem('eah2012','1', 'fin_campo',2400,'Fin campo',null,'numeros');
select encu.agregar_variable_tem('eah2012','1', 'estado_procesamiento',2410,'Estado procesamiento',null,'numeros');
select encu.agregar_variable_tem('eah2012','1', 'devolucion_campo',2420,'Devolución campo',null,'numeros');
select encu.agregar_variable_tem('eah2012','1', 'devolucion_tematico',2430,'Devolución temático',null,'numeros');
select encu.agregar_variable_tem('eah2012','1', 'destinatario_tematico',2440,'Destinatario temático',null,'texto');
select encu.agregar_variable_tem('eah2012','1', 'estado',2490,'Estado',null,'numeros');

