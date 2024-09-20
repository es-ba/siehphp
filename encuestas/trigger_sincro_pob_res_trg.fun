--planilla_monitoreo_tem
insert into encu.pla_var (plavar_ope,plavar_var,plavar_planilla,plavar_editable,plavar_orden,plavar_tlg) 
values (dbo.ope_actual(),'pob_res','MON_TEM',false,681,1);
--planilla_monitoreo_campo
insert into encu.pla_var (plavar_ope,plavar_var,plavar_planilla,plavar_editable,plavar_orden,plavar_tlg) 
values (dbo.ope_actual(),'pob_res','MON_TEM_CAMPO',false,391,1);
--planilla_recepcion_encuestador
insert into encu.pla_var (plavar_ope,plavar_var,plavar_planilla,plavar_editable,plavar_orden,plavar_tlg) 
values (dbo.ope_actual(),'pob_res','REC_ENC',false,321,1);
--planilla_recepcion_recuperador
insert into encu.pla_var (plavar_ope,plavar_var,plavar_planilla,plavar_editable,plavar_orden,plavar_tlg) 
values (dbo.ope_actual(),'pob_res','REC_REC',false,321,1);
--planilla_recepcion_supervisor_campo
insert into encu.pla_var (plavar_ope,plavar_var,plavar_planilla,plavar_editable,plavar_orden,plavar_tlg) 
values (dbo.ope_actual(),'pob_res','REC_SUP_CAM',false,211,1);
--planilla_recepcion_supervisor_telefonico
insert into encu.pla_var (plavar_ope,plavar_var,plavar_planilla,plavar_editable,plavar_orden,plavar_tlg) 
values (dbo.ope_actual(),'pob_res','REC_SUP_TEL',false,211,1);
--planilla_mis_supervisiones_telefonicas
insert into encu.pla_var (plavar_ope,plavar_var,plavar_planilla,plavar_editable,plavar_orden,plavar_tlg) 
values (dbo.ope_actual(),'pob_res','PLA_MIS_SUP_TEL',false,321,1);
--Las siguientes dos planillas se actualizan agregando pla_pob_res en plana_tem_ y se retocó código en las grillas correspondientes.
--registro_claves
--viviendas_para_el_muestrista
ALTER TABLE encu.plana_tem_ ADD COLUMN pla_pob_res INTEGER;

--variable de la tem : pob_res
insert into encu.preguntas(pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
       pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
       pre_orden, pre_aclaracion_superior, pre_tlg) 
SELECT pre_ope, 'pob_res', 'población residente', pre_abreviado, pre_for, pre_mat, 
       pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
       892, pre_aclaracion_superior, 1
  from encu.preguntas where pre_pre='pob_tot';
insert into encu.variables ( var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
       var_tlg)
select var_ope, var_for, var_mat, 'pob_res', 'pob_res', 'población residente', var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
       1
   from encu.variables where var_var='pob_tot';
   
--correr seteo de lo que ya esta en tabla
with cant as (
    select pla_enc, count(*)filter(where pla_r0=1) can_res, count(*) cant_p from plana_s1_p 
	group by 1
  )
  UPDATE encu.respuestas 
        SET res_valor=can_res
		    from cant c
        WHERE res_ope=dbo.ope_actual() and res_for='TEM' and res_var='pob_res' and res_enc=c.pla_enc and cant_p > 0;

CREATE OR REPLACE FUNCTION encu.sincro_pob_res_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_delta   integer;
  v_registro    encu.plana_s1_p%rowtype;
BEGIN
	v_delta = 0;
  CASE 
    WHEN TG_OP= 'UPDATE' THEN
      v_registro=new;    
      if v_registro.pla_r0 = 1 and old.pla_r0 is distinct from 1 then 
        v_delta = 1; 
      end if;
      if v_registro.pla_r0 is distinct from 1 and old.pla_r0 = 1 then
        v_delta = -1; 
      end if;
    WHEN TG_OP= 'DELETE' THEN
      v_registro=OLD;
      if v_registro.pla_r0 = 1 then v_delta = -1; end if;          
    ELSE
      raise exception 'sincro_pob_res error operacion no considerada %', TG_OP;
  END CASE; 
  if v_delta!=0 then 
    UPDATE encu.respuestas 
      SET res_valor=coalesce(res_valor::integer,0) + v_delta 
      WHERE res_ope=dbo.ope_actual() and res_for='TEM' and res_var='pob_res' and res_enc=v_registro.pla_enc;
  END IF;    
  RETURN v_registro;
END
$BODY$
  LANGUAGE plpgsql;
  
ALTER FUNCTION encu.sincro_pob_res_trg()
  OWNER TO tedede_php;

CREATE TRIGGER sincro_pob_res_trg
  AFTER UPDATE of pla_r0 OR DELETE ON encu.plana_s1_p
  FOR EACH ROW 
  EXECUTE PROCEDURE encu.sincro_pob_res_trg();