--verficar que la encuesta no esté cargada en un dm (chequeando estado), antes de realizar las actualizaciones
select pla_semana,pla_enc,pla_cod_enc,pla_estado,pla_rea, pla_norea,
   pla_rea_enc,pla_norea_enc, pla_rea_recu, pla_norea_recu, 
   pla_cod_recu, pla_dispositivo_recu,pla_con_dato_recu,
   pla_fecha_primcarga_recu, pla_fecha_carga_recu,pla_fecha_descarga_recu, 
   pla_verificado_enc
   from encu.plana_tem_
where  pla_enc= xxxxxx;
select comun.nueva_sesion_pgadmin('usuario','enc xxxxxx');

--select * from encu.respuestas    --verificar primero siempre con un select
 update encu.respuestas set res_valor=null, 
  res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var in('dispositivo_recu','fecha_carga_recu','fecha_primcarga_recu','fecha_descarga_recu', 'cod_recu','con_dato_recu') and res_for='TEM'
     and res_enc = xxxxxx;
     
--si piden también Cambiar rea=3 por rea=1, verificado_enc=6 por verificado_enc=1 
--select * from encu.respuestas    --verificar primero siempre con un select
 update encu.respuestas set res_valor=1, 
   res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var ='rea' and res_for='TEM'
     and res_enc = xxxxxx; 
     
--select * from encu.respuestas    --verificar primero siempre con un select
 update encu.respuestas set res_valor=1, 
  res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var ='verificado_enc' and res_for='TEM'
     and res_enc = xxxxxx; 
     
