--pasar de 46 a 42 problemas en la carga
--tienen que volver a cargarle la info al supervisor
select pla_enc,pla_estado, pla_fecha_carga_sup,pla_fecha_descarga_sup, pla_cod_sup,pla_cod_recu,pla_semana
 from encu.plana_tem_ 
 where pla_cod_sup=xxx  and pla_estado=46;
--verifico que estén en estado 46 originalmente y si son la cantidad solicitada
--select comun.nueva_sesion_pgadmin('usuario','supexxx'); 
--select * from encu.respuestas    --verifico primero antes de hacer el update
 update encu.respuestas set res_valor=null, 
   res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var='fecha_carga_sup' and res_for='TEM'
     and res_enc  in (select pla_enc from encu.plana_tem_ where pla_cod_sup=xxx and pla_estado=46);
--las encuestas pasan a estado 42 