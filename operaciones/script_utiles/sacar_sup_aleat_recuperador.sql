--sacar supervision aleatoria de recuperacion, a pedido de campo

select pla_enc,pla_estado, pla_fecha_carga_sup,pla_cod_recu, 
       pla_fecha_descarga_sup, pla_cod_sup,pla_cod_recu,pla_semana, pla_sup_aleat
 from encu.plana_tem_ 
 where  pla_enc= xxxxxx and pla_estado=37 and pla_cod_recu=xxx;
 --verifico que la encuesta tiene que estar descargada, en estado 37 y con codigo de sup_aleat

select comun.nueva_sesion_pgadmin('usuario','encu-xxxxxx'); 
select * from encu.respuestas    --verificar primero antes de hacer el update
 --update encu.respuestas set res_valor=null, 
 -- res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var='sup_aleat' and res_for='TEM'
     and res_enc  in (select pla_enc from encu.plana_tem_ where pla_enc= xxxxxx and pla_estado=37 and pla_cod_recu=xxx);
