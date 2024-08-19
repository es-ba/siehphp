--USO: cambiar norea_enc y rea_enc
/* parametros
--a completar
pUSER:usuario que realiza el cambio
pTextoTarea:texto corto que representa la tarea, poner algo univoco, por ejemplo operativo y nro de ticket
pEnc1: codigo de encuesta 1
pEnc2: codigo de encuesta 2
pOpe: operativo
nnnnnnnnn lo que devueve la consulta select comun.nueva_sesion_pgadmin('pUser','pTextoTarea' )
*/

--------
set search_path= encu, dbo, comun;

select comun.nueva_sesion_pgadmin('pUser','pTextoTarea' );
-- copiar el numero que tira, ese es valor para el tlg
select * from pg_admin; --"nnnnnnnnn"
select pla_enc, pla_estado, pla_rea, pla_norea, pla_rea_enc, pla_norea_enc, pla_verificado_enc, pla_rea_recu, pla_norea_recu 
  from plana_tem_
  where pla_enc in (pEnc1, pEnc2)
  order by 1;

----------
--Ejemplo: cambiar rea_enc=1 y norea_enc=null
update respuestas
  set res_valor='1',
      --res_tlg=nnnnnnnnn
      res_tlg=(select pga_tlg from pgadmin ) 
  --select res_enc, res_for, res_var, res_valor from respuestas    
  where res_ope='pOpe' and res_for='TEM' and res_var='rea_enc' 
      and res_enc in (pEnc1, penc2) and res_valor='0'
;
update respuestas
  set res_valor=null,
    res_tlg=(select pga_tlg from pgadmin )
    --select res_enc, res_for, res_var, res_valor from respuestas      
  where res_ope='pOpe' and res_for='TEM'  and res_var='norea_enc'
        and res_enc in (pEnc1, pEnc2)
; 

-- revisar luego del cambio
select pla_enc, pla_estado, pla_rea, pla_norea, pla_rea_enc, pla_norea_enc, pla_verificado_enc, pla_rea_recu, pla_norea_recu 
  from plana_tem_
  where pla_enc in (pEnc1, pEnc2)
  order by 1;


