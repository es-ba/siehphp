##FUN
variables_ordenadas
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE VIEW encu.variables_ordenadas
 AS
 SELECT b.blo_for,
    b.blo_blo,
    b.blo_texto,
    b.blo_incluir_mat,
    b.blo_orden,
    v.var_ope,
    v.var_for,
    v.var_mat,
    v.var_pre,
    v.var_var,
    v.var_texto,
    v.var_aclaracion,
    v.var_conopc,
    v.var_conopc_texto,
    v.var_tipovar,
    v.var_destino,
    v.var_subordinada_var,
    v.var_subordinada_opcion,
    v.var_desp_nombre,
    v.var_expresion_habilitar,
    v.var_optativa,
    v.var_editable_por,
    v.var_orden,
    v.var_nsnc_atipico,
    v.var_destino_nsnc,
    v.var_calculada,
    p.pre_orden,
    row_number() OVER (ORDER BY f.for_orden, b.blo_orden, b.blo_mat, p.pre_orden, (comun.para_ordenar_numeros(COALESCE(
        CASE
            WHEN v.var_orden IS NOT NULL THEN lpad(v.var_orden::text, 4, '0'::text)
            ELSE NULL::text
        END, v.var_var::text))), (COALESCE(v.var_subordinada_var, ''::character varying))) AS orden,
    last_value(v.var_var) OVER (PARTITION BY b.blo_for, b.blo_mat ORDER BY f.for_orden, b.blo_orden, b.blo_mat, p.pre_orden, (comun.para_ordenar_numeros(COALESCE(
        CASE
            WHEN v.var_orden IS NOT NULL THEN lpad(v.var_orden::text, 4, '0'::text)
            ELSE NULL::text
        END, v.var_var::text))), (COALESCE(v.var_subordinada_var, ''::character varying)) ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS var_ultima_for,
    lead(v.var_var, 1, 'fin'::character varying) OVER (PARTITION BY b.blo_for, b.blo_mat ORDER BY f.for_orden, b.blo_orden, b.blo_mat, p.pre_orden, (comun.para_ordenar_numeros(COALESCE(
        CASE
            WHEN v.var_orden IS NOT NULL THEN lpad(v.var_orden::text, 4, '0'::text)
            ELSE NULL::text
        END, v.var_var::text))), v.var_pre) AS var_siguiente
   FROM encu.variables v
     JOIN encu.preguntas p ON p.pre_ope::text = v.var_ope::text AND p.pre_pre::text = v.var_pre::text AND p.pre_for::text = v.var_for::text AND p.pre_mat::text = v.var_mat::text
     JOIN encu.bloques b ON b.blo_blo::text = p.pre_blo::text AND b.blo_ope::text = p.pre_ope::text AND b.blo_for::text = p.pre_for::text AND b.blo_mat::text = p.pre_mat::text
     JOIN encu.formularios f ON f.for_for::text = b.blo_for::text AND f.for_ope::text = b.blo_ope::text
  WHERE f.for_for::text <> 'TEM'::text
  ORDER BY f.for_orden, b.blo_orden, b.blo_mat, p.pre_orden, (comun.para_ordenar_numeros(COALESCE(
        CASE
            WHEN v.var_orden IS NOT NULL THEN lpad(v.var_orden::text, 4, '0'::text)
            ELSE NULL::text
        END, v.var_var::text))), (COALESCE(v.var_subordinada_var, ''::character varying));
/*otra*/
ALTER TABLE encu.variables_ordenadas
    OWNER TO tedede_php;
