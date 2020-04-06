CREATE OR REPLACE FUNCTION encu.agregar_variable_tem(p_ope text, p_blo text, p_var text, p_orden integer, p_texto text, p_conopc text, p_tipovar text) returns text
  language plpgsql
as 
$BODY$
DECLARE
  v_sql text;
BEGIN
  if p_tipovar='numeros' then 
    v_sql:=replace($$ALTER TABLE encu.plana_tem_ ADD column pla_#VARIABLE# integer$$,'#VARIABLE#',p_var);
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
$BODY$;

select encu.agregar_variable_tem('pp2012','1', 'norea_e',10,'NO REA Encuestador',null,'numeros');
select encu.agregar_variable_tem('pp2012','1', 'norea_r',20,'NO REA Recuperador',null,'numeros');
select encu.agregar_variable_tem('pp2012','1', 'cod_enc',9,'Código de encuestador',null,'numeros');
-- select encu.agregar_variable_tem('pp2012','1', 'cod_recu',19,'Código de recuperador',null,'numeros');
-- select encu.agregar_variable_tem('pp2012','1', 'cod_sup',30,'Código de supervisor',null,'numeros');
select encu.agregar_variable_tem('pp2012','1', 'cod_recep',40,'Código de recepcionista',null,'numeros');