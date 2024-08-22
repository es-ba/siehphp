-- aggregar pob_res a la tem y agregar trigger para sincronizar con pla_r0
--  tambien agregar en tablas de metadato de planillas pla_var 

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
   
--seguramente  hay que agregar la variable pla_pob_res en plana_tem_ . fijarse si tambien en tem_  

--trigger function
CREATE OR REPLACE FUNCTION encu.sincro_pob_res_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_signo integer;
  v_sum   integer;
  v_registro    encu.plana_s1_p%rowtype;
BEGIN 
   -- ver si asi  va ok o es mejor hacer una consulta con  group by en plana_s1_p  para hacer el update

    CASE 
        WHEN TG_OP= 'UPDATE' THEN
            v_registro=new;
            v_signo=1            
        WHEN TG_OP= 'DELETE' THEN
            v_registro=OLD;
            v_signo=-1
        ELSE
            raise exception 'sincro_pob_res error operacion no considerada %', TG_OP;
    END CASE;
    v_sum=CASE WHEN v_registro.r0=1 THEN v_signo ELSE 0 END;
    --raise notice ' sum % signo % ', v_sum, v_signo,;    
    if v_sum!=0 then 
      UPDATE encu.respuestas 
        SET res_valor=coalesce(res_valor,0) + v_sum 
        WHERE res_ope=dbo.ope_actual() and res_for='TEM' and res_var='pob_res' and res_enc=v_registro.pla_enc ;
    END IF;    
    RETURN v_registro;
END
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION encu.sincro_pob_res_trg()
  OWNER TO tedede_php;


CREATE TRIGGER sincro_sincro_pob_res_trg
    AFTER UPDATE of pla_r0 OR DELETE ON encu.plana_s1_p
    FOR EACH ROW 
    EXECUTE PROCEDURE encu.sincro_sincro_pob_res_trg();


--correr seteo de lo que ya esta en tabla
  with cant as (
    select pla_enc, count(*)nres from plana_s1_p where pla_r0=1
  )
  update plana_tem_
    set pla_pob_res= nres
    From cant
    where pla_enc=cant.pla_enc and pla_rea is distinct from 2 --ver    

--- agregar variable pob_tot a  pla_var para las grillas?