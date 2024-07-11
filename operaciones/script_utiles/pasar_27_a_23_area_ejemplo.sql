--Pasar a 23 encuestas que están en estado 27
--por error de la recepcionista pusieron el verificado en varias encuestas
--antes de que terminara la descarga y se trabó la tablet porque tienen aun encuestas cargadas
--paso las dos áreas 

--verifico estados 
select pla_enc,pla_estado, pla_semana,pla_cod_enc, pla_rea, pla_rea_enc,pla_norea, 
  pla_fecha_descarga_enc,
  pla_fin_ingreso_enc, pla_con_dato_enc, pla_a_ingreso_enc,pla_verificado_enc
 from encu.plana_tem_ 
 where pla_area in(xxxx, xxxx) and pla_cod_enc=xxx; 

 select comun.nueva_sesion_pgadmin('usuario','encu_areasxxxxxx');
--select * from encu.respuestas   --verifico con un select antes de correr el update 
update encu.respuestas set res_valor=null, --
  res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var='fecha_descarga_enc' and res_for='TEM'
     and res_enc  in (select pla_enc from encu.plana_tem_ where pla_area in(xxxx, xxxx) and pla_cod_enc=xxx)
--UPDATE 20

--select * from encu.respuestas   
update encu.respuestas set res_valor=null, --
  res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var='con_dato_enc' and res_for='TEM'
     and res_enc  in (select pla_enc from encu.plana_tem_ where pla_area in(xxxx, xxxx) and pla_cod_enc=xxx)
     
--listo las dos áreas se encuentran en 23