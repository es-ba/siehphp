--Pasar a 23 encuestas que están en estado 27

--verifico estados 
select pla_enc,pla_estado, pla_semana,pla_cod_enc, pla_rea, pla_rea_enc,pla_norea, 
  pla_fecha_descarga_enc,
  pla_fin_ingreso_enc, pla_con_dato_enc, pla_a_ingreso_enc,pla_verificado_enc
 from encu.plana_tem_ 
 where pla_enc =xxxxxx and pla_cod_enc=xxx; 

 select comun.nueva_sesion_pgadmin('usuario','encuesta xxxxxx');
 
--select * from encu.respuestas   --verifico con un select antes de correr el update  que sean dos filas las que se van a cambiar.
update encu.respuestas set res_valor=null, 
  res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var in ('con_dato_enc', 'fecha_descarga_enc') and res_for='TEM'
     and res_enc =xxxxxxx ;


--verificar con primer select que  la encuesta se encuentra ahora  en estado 23