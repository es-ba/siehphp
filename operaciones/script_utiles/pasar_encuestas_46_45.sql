--se solicita pasar encuestas de estado 46 a 45 
--en este caso no fue necesario modificar el cod_sup, pero si hubiera que hacerlo el personal de campo puede hacerlo antes o se incorpora a este script
---verifico estado, que debe estar en 46
select t.pla_enc,pla_estado,pla_rea, pla_rea_enc,pla_norea, pla_norea_enc,
  pla_verificado_recu,pla_fecha_carga_sup, pla_cod_sup ,pla_rea_recu,
  pla_fecha_descarga_sup, pla_norea_sup,pla_sup_aleat, pla_sup_dirigida,
  pla_cod_recu, pla_norea_recu,pla_verificado_recu,pla_rea_recu,
  pla_fin_ingreso_enc, pla_con_dato_enc, pla_a_ingreso_enc,pla_verificado_enc
 from encu.plana_tem_ t
 where  t.pla_enc in  (xxxxxx,xxxxxx);


select comun.nueva_sesion_pgadmin('usuario','Operativo*nroreq');

--select * from encu.respuestas    --verifico primero siempre con un select
update encu.respuestas set res_valor=null, 
  res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var in('dispositivo_sup') and res_for='TEM'
     and res_enc in (xxxxxx,xxxxxx );
--la/s encuesta/s pasan a 45
