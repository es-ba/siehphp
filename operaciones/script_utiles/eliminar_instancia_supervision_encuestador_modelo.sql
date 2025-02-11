--Se solicita sacar instancia de supervision de la encuesta nº xxxxxx, 
--se cerro, por error ,con un código erróneo y salio a supervision ,
--tendría que haber salido a recuperación, tendría que quedar en estado 27   

--verifico estado, debe estar en 47. Tambien en este caso revisamos la entrea del o los hogares ( en gral no hace falta pero a veces conviene mirarlo)
select t.pla_enc,s.pla_hog, pla_estado,pla_rea, pla_rea_enc,pla_norea, pla_norea_enc,pla_entrea,
  pla_verificado_recu,pla_fecha_carga_sup, pla_cod_sup,pla_rea_recu,
  pla_fecha_descarga_sup, pla_norea_sup,pla_sup_aleat, pla_sup_dirigida,
  pla_cod_recu, pla_norea_recu,pla_verificado_recu,pla_rea_recu,
  pla_fin_ingreso_enc, pla_con_dato_enc, pla_a_ingreso_enc,pla_verificado_enc
 from encu.plana_tem_ t
 inner join encu.plana_s1_ s on t.pla_enc=s.pla_enc
 where /*pla_cod_sup=xxx  and*/ t.pla_enc =  xxxxxx;


select comun.nueva_sesion_pgadmin('usuario','encu  xxxxxx');

--select * from encu.respuestas    --verifico primero siempre con un select
update encu.respuestas set res_valor=null, 
 res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var in('sup_aleat','result_sup','sup_dirigida','fecha_carga_sup','fecha_descarga_sup', 'cod_sup','fecha_primcarga_sup','dispositivo_sup') and res_for='TEM'
     and res_enc = xxxxxx;

--borrando formulario de supervision
--controlo que exista primero 
select *
--delete
from encu.respuestas
where res_ope=dbo.ope_actual() and res_for='SUP'
     and res_enc = xxxxxx;

select *
--delete
from encu.claves
where cla_ope=dbo.ope_actual() and cla_for='SUP'
     and cla_enc = xxxxxx;     
select *
--delete
from encu.plana_sup_
where  pla_enc = xxxxxx and pla_hog=x;    

--borrar fila
--pasar la encuesta a 27
select * from encu.respuestas  
--update encu.respuestas set res_valor= null, 
  res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var='verificado_enc' and res_for='TEM'
     and res_enc = xxxxxx;

--la encuesta pasa a 27
