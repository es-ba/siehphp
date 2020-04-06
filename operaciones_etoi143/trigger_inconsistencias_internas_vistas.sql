set search_path = encu, comun, public;

/*

delete from encu.respuestas where res_enc=100001 and res_var='cod_supe';
update encu.plana_tem_ set pla_cod_supr=2 where pla_enc=100001;
delete from encu.plana_tem_ where pla_enc=100002;

-- */

CREATE OR REPLACE FUNCTION operaciones.generar_vista_inconsistencias_internas() RETURNS TEXT 
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
  v_enter text:=chr(13)||chr(10);
  v_script_creador text;
  v_variables record;
  v_matrices record;
BEGIN
v_script_creador:=$SCRIPT$
create or replace view encu.inconsistencias_internas
  as 
$SCRIPT$;
-- faltan registros en respuestas: ver que para cada registro de claves haya al menos una respuesta
v_script_creador:=v_script_creador||$SCRIPT$
  select 'faltan registros en respuestas'::text as clase, cla_for as inc_for, cla_mat as inc_mat, cla_enc as inc_enc, null::text as inc_var
       from encu.claves left join encu.respuestas 
         on cla_ope=res_ope and cla_for=res_for and cla_mat=res_mat and cla_enc=res_enc and cla_hog=res_hog and cla_mie=res_mie and cla_exm=res_exm
       where res_ope is null
$SCRIPT$;
-- no coincide respuestas con su tabla plana
  FOR v_variables IN 
    SELECT * 
      FROM encu.variables 
      ORDER BY var_for,var_mat,var_var
  LOOP
    v_script_creador:=v_script_creador||replace(replace(replace(replace($SCRIPT$
      UNION 
        SELECT 'no coincide respuestas con su tabla plana' as clase, res_for, res_mat, res_enc, res_var
          FROM encu.respuestas INNER JOIN encu.plana_#FOR#_#MAT# ON res_enc=pla_enc AND res_hog=pla_hog AND res_mie=pla_mie AND res_exm=pla_exm
          WHERE res_var='#VAR#' 
            AND CASE WHEN res_valesp='//' THEN '-9'
                     WHEN res_valesp='--' THEN '-1' 
                     WHEN res_valor_con_error IS NOT NULL THEN '-5'
                     ELSE res_valor END::#CAST# is distinct from pla_#VAR#
$SCRIPT$,'#FOR#',v_variables.var_for),'#MAT#',v_variables.var_mat),'#VAR#',v_variables.var_var),'#CAST#',
           CASE v_variables.var_tipovar 
             WHEN 'opciones' THEN 'numeric' 
             WHEN 'marcar' THEN 'numeric' 
             WHEN 'si_no' THEN 'numeric' 
             WHEN 'anios' THEN 'numeric' 
             WHEN 'meses' THEN 'numeric' 
             WHEN 'monetaria' THEN 'numeric' 
             WHEN 'numeros' THEN 'numeric' 
             WHEN 'timestamp' THEN 'timestamp' 
             ELSE 'text' 
           END);
  END LOOP;
-- no coincide claves con su tabla plana
  FOR v_matrices IN 
    SELECT * 
      FROM encu.matrices 
      ORDER BY mat_for,mat_mat
  LOOP
    v_script_creador:=v_script_creador||replace(replace(replace($SCRIPT$
      UNION 
        SELECT 'no coincide claves con su tabla plana' as clase, cla_for, cla_mat, cla_enc, null
          FROM encu.claves LEFT JOIN encu.plana_#FOR#_#MAT# ON cla_enc=pla_enc AND cla_hog=pla_hog AND cla_mie=pla_mie AND cla_exm=pla_exm
          WHERE cla_for='#FOR#' AND cla_mat='#MAT#' and cla_ope='#OPE#'
            AND pla_enc IS NULL
$SCRIPT$,'#OPE#',v_matrices.mat_ope),'#FOR#',v_matrices.mat_for),'#MAT#',v_matrices.mat_mat);
  END LOOP;
  EXECUTE v_script_creador;
  RETURN NULL;
--  RETURN v_script_creador;
END;
$CUERPO$;

select operaciones.generar_vista_inconsistencias_internas();

select * 
  from encu.inconsistencias_internas
  order by inc_enc;

/*
select * from encu.claves where cla_enc=100001;

select * from encu.plana_tem_ where pla_enc=100001;
select * from encu.plana_sm1_ where pla_enc=100001;
-- */