--pasar un área de estado 23 a estado 27 para que pase directo a recuperación
--(una encuestadora se niega a descargar la info  )
select pla_enc,pla_estado, pla_semana,pla_cod_enc, pla_rea, pla_rea_enc,pla_norea, 
pla_fecha_descarga_enc,
pla_fin_ingreso_enc, pla_con_dato_enc, pla_a_ingreso_enc,pla_verificado_enc
 from encu.plana_tem_ 
 where pla_area =xxxx and pla_cod_enc=xx; 
 --verifico que esté en 23
select comun.nueva_sesion_pgadmin('usuario','encu_areaxxxx'); 
--select * from encu.respuestas    --verifico primero antes de hacer el update
update encu.respuestas set res_valor=1, --anteriormente tenia valor null esta variable
 res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var='fin_ingreso_enc' and res_for='TEM'
     and res_enc  in (select pla_enc from encu.plana_tem_ where pla_area =xxxx and pla_cod_enc=xx);
--pasa a estado 27