CREATE OR REPLACE FUNCTION agregar_variable_tem(p_ope text, p_blo text, p_var text, p_orden integer, p_texto text, p_conopc text, p_tipovar text) returns text
  language plpgsql
as 
$BODY$
DECLARE
  v_sql text;
BEGIN
  if p_tipovar='numeros' then 
    v_sql:=replace($$ALTER TABLE plana_tem_ ADD column pla_#VARIABLE# integer$$,'#VARIABLE#',p_var);
  else if p_tipovar='texto' then 
    v_sql:=replace($$ALTER TABLE plana_tem_ ADD column pla_#VARIABLE# text$$,'#VARIABLE#',p_var);
  else
    raise exception 'No se como agregar variables de tipo %', var_tipovar;
  end if;
  execute v_sql;
  INSERT INTO preguntas(
            pre_ope, pre_pre, pre_for, pre_mat, 
            pre_blo, pre_orden, pre_tlg)
    VALUES (p_ope, upper(p_var), 'TEM', '',
            p_blo, p_orden, 1);
  INSERT INTO variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, 
            var_conopc, var_tipovar, var_tlg)
    VALUES (p_ope, 'TEM', '',upper(p_var), p_var, p_texto,
            p_conopc, p_tipovar, 1);
  return 'ok';
END;
$BODY$;

/*
select agregar_variable_tem('colon2015','1', 'norea_e',10,'NO REA Encuestador',null,'numeros');
select agregar_variable_tem('colon2015','1', 'norea_r',20,'NO REA Recuperador',null,'numeros');
select agregar_variable_tem('colon2015','1', 'cod_enc',9,'Código de encuestador',null,'numeros');
-- select agregar_variable_tem('colon2015','1', 'cod_recu',19,'Código de recuperador',null,'numeros');
-- select agregar_variable_tem('colon2015','1', 'cod_sup',30,'Código de supervisor',null,'numeros');
select agregar_variable_tem('colon2015','1', 'cod_recep',40,'Código de recepcionista',null,'numeros');

select agregar_variable_tem('colon2015','1', 'sup_dirigida',315,'Supervision dirigida',null,'numeros');

select agregar_variable_tem('colon2015','1', 'estado_procesamiento',2400,'Estado procesamiento',null,'numeros');
select agregar_variable_tem('colon2015','1', 'devolucion_campo',2410,'Devolución campo',null,'numeros');
select agregar_variable_tem('colon2015','1', 'devolucion_tematico',2420,'Devolución temático',null,'numeros');
select agregar_variable_tem('colon2015','1', 'destinatario_tematico',2430,'Destinatario temático',null,'texto');
select agregar_variable_tem('colon2015','1', 'estado',2490,'Estado',null,'numeros');


*/