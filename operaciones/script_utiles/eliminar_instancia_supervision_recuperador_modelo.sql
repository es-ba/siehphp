--xxxxx
--Esta encuesta se asigno a supervision por error,
--no paso por la instancia de recepción, se solicita sacar asignacion  y  cuestionario de de supervision 
-- Es una supervisión de recuperador
select t.pla_enc,pla_estado,pla_rea, pla_rea_enc,pla_norea, pla_norea_enc,pla_entrea,
pla_verificado_recu,pla_fecha_carga_sup, pla_cod_sup,pla_entrea,pla_rea_recu,
pla_fecha_descarga_sup, pla_dispositivo_sup, pla_norea_sup,pla_sup_aleat, pla_sup_dirigida,
pla_cod_recu, pla_norea_recu,pla_verificado_recu,pla_rea_recu,
pla_fin_ingreso_enc, pla_con_dato_enc, pla_a_ingreso_enc,pla_verificado_enc
--, pla_fecha_descarga_recu, pla_fecha_carga_recu
 from encu.plana_tem_ t
 inner join encu.plana_s1_ s on t.pla_enc=s.pla_enc
 where /*pla_cod_sup=xxx  and*/ t.pla_enc =  xxxxx;

 select comun.nueva_sesion_pgadmin('usuario','encu xxxxx');
--vemos antes del update toda la información cargada para el supervisor.
--select * from encu.respuestas   
   update encu.respuestas set res_valor=null, 
    res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var in('sup_aleat','result_sup','sup_dirigida','fecha_carga_sup','fecha_descarga_sup', 'cod_sup','fecha_primcarga_sup') and res_for='TEM'
     and res_enc = xxxxx;
 

--borrando formularios supervision
--info en respuestas y claves del cuestionario de supervisión, y en la plana
--select primero para constatar y despues delete
select *
--delete
from encu.respuestas
where res_ope=dbo.ope_actual() and res_for='SUP'
     and res_enc = xxxxx;

select *
--delete
from encu.claves
where cla_ope=dbo.ope_actual() and cla_for='SUP'
     and cla_enc = xxxxx;
--1 fila     
select *
--delete
from encu.plana_sup_
where  pla_enc = xxxxx and pla_hog=x;     
--borrada 1 fila


/* por si fuera necesario borrar el verificado_recu para que la encuesta pase a 37 */
select * from encu.respuestas  
--update encu.respuestas set res_valor= null,  --tiene valor 1
 -- res_tlg=(select pga_tlg from pgadmin) 
   where res_ope=dbo.ope_actual() and res_var='verificado_recu' and res_for='TEM'
     and res_enc = xxxxx;

--la encuesta pasa a 37


