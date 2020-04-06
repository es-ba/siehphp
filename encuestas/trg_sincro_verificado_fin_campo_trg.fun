--probando subida
set search_path=encu, dbo, comun;
--variable especial verificado_norea
INSERT INTO encu.varcal(varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, varcal_activa, varcal_tipo, varcal_baseusuario, varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_tlg, varcal_valida, varcal_opciones_excluyentes) VALUES 
 (dbo.ope_actual(), 'verificado_norea', 'hog',  1, 'verificacion norea en S1', true, 'especial', false, NULL, 'entero', 1, true, false);

ALTER TABLE encu.plana_s1_ ADD COLUMN pla_verificado_norea integer;
ALTER TABLE his.plana_s1_ ADD COLUMN pla_verificado_norea integer;

--variable de la tem verificado_fin_campo
insert into encu.preguntas(pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
       pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
       pre_orden, pre_aclaracion_superior, pre_tlg) 
SELECT pre_ope, 'verificado_fin_campo', 'verificado NoRea OK', pre_abreviado, pre_for, pre_mat, 
       pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
       889, pre_aclaracion_superior, 1
  from encu.preguntas where pre_pre='verificado_recu';
insert into encu.variables ( var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
       var_tlg)
select var_ope, var_for, var_mat, 'verificado_fin_campo', 'verificado_fin_campo', 'verificado NoRea Ok', var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
       1
   from encu.variables where var_var='verificado_recu';

--nuevo estado
INSERT INTO estados(
            est_ope, est_est, est_nombre, est_criterio, est_editar_encuesta, 
            est_editar_tem, est_tlg)
select est_ope, 68, 'Revision de NoRea', est_criterio, 'subcoor_campo', est_editar_tem, 1
  from estados
  where est_est=69;

update encu.estados
 set est_criterio= '( '||est_criterio ||' ) and (coalesce(verificado_fin_campo,0)>0 or rea=1 or rea=3 or rea=4)'
 where est_est=69;
--luego regenerar estados via funcion
select operaciones.generar_calculo_estado_trg();
 
 
--trigger
CREATE OR REPLACE FUNCTION encu.sincro_verificado_fin_campo_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_enc         integer;
  v_actual      integer;
  v_nuevo       integer;
  v_rea_actual  integer;
  v_estado_actual integer;
  v_registro    encu.plana_s1_%rowtype;
  v_hacer       boolean;
BEGIN 
    v_hacer=true;
    CASE 
        WHEN TG_OP= 'INSERT' or TG_OP= 'UPDATE' THEN
            v_enc=new.pla_enc;
            v_registro=new;            
            v_hacer= (TG_OP= 'UPDATE') and new.pla_verificado_norea is distinct from old.pla_verificado_norea;
        WHEN TG_OP= 'DELETE' THEN
            v_enc=old.pla_enc;
            v_registro=OLD;
        ELSE
            raise exception 'sincro_verificado_fin_campo error operacion no considerada %', TG_OP;
    END CASE;
    --raise notice ' hacer % actual % nuevo % rea%', v_hacer, v_actual, v_nuevo, v_rea_actual;    
    if v_hacer then  
      SELECT 
        CASE WHEN count(case when pla_entrea in (2,4) then 1 else null end ) = count(case when pla_verificado_norea >0 then 1 else null end) and count(case when pla_verificado_norea >0 then 1 else null end)>0 THEN 1 ELSE null END nuevo
            , min(pla_verificado_fin_campo) actual, min(pla_rea) rea_actual, min(pla_estado) estado_actual
        INTO v_nuevo, v_actual, v_rea_actual, v_estado_actual
        FROM plana_s1_  s join plana_tem_ t on  t.pla_enc= s.pla_enc
        WHERE s.pla_enc=v_enc;
        --raise notice ' actual %  nuevo %', v_actual, v_nuevo;
      IF not (v_rea_actual in (0,2) and v_estado_actual =68) THEN
            v_nuevo=null;
      END IF;
      UPDATE encu.respuestas 
        SET res_valor=v_nuevo::text 
        WHERE res_ope=dbo.ope_actual() and res_for='TEM' and res_var='verificado_fin_campo' and res_enc=v_enc and coalesce(res_valor,'-1')=coalesce(v_actual::text, '-1') and v_nuevo is distinct from v_actual;
    END IF;    
    RETURN v_registro;
END
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION encu.sincro_verificado_fin_campo_trg()
  OWNER TO tedede_php;


CREATE TRIGGER sincro_verificado_fin_campo_trg
    AFTER INSERT OR UPDATE OR DELETE ON encu.plana_s1_
    FOR EACH ROW 
    EXECUTE PROCEDURE encu.sincro_verificado_fin_campo_trg();


/*
    SELECT 
      CASE WHEN count(case when pla_entrea in (0,2) then 1 else null end ) = count(case when pla_verificado_norea >0 then 1 else null end) and count(case when pla_verificado_norea >0 then 1 else null end)>0 THEN 1 ELSE null END nuevo, min(pla_verificado_fin_campo) actual
      --INTO v_actual, v_nuevo
      FROM plana_s1_  s join plana_tem_ t on  t.pla_enc= s.pla_enc
      WHERE s.pla_enc=144664;

update encu.plana_s1_
   set pla_verificado_norea=1
   where pla_enc=144664 and pla_hog=1;
*/