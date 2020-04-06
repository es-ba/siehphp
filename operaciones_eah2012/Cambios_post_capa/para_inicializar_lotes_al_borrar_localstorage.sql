
select res_ope, res_enc, res_valor from encu.respuestas 
where res_var in ('per','estado_carga', 'carga', 'rol', 'dispositivo', 'fecha_carga', 'fecha_descarga') 
and res_ope = 'eah2012' 
and res_enc in (select pla_enc from encu.plana_tem_ where pla_per = 150 and pla_lote=332);

/* para actualizar tem cuando se borro localstorage de encuestador en ipad y se quiere volver a asignar esos lotes -- pla_per es el encuestador
  update encu.respuestas   set res_valor=null   where 
  res_var in ('per','estado_carga', 'carga', 'rol', 'dispositivo', 'fecha_carga', 'fecha_descarga') 
  and res_ope = 'eah2012' 
  and res_enc in (select pla_enc from encu.plana_tem_ where pla_per = 150 and pla_lote=332);
-- */

select pla_estado_carga,pla_per, pla_per_a_cargar,pla_rol,pla_carga,pla_enc, * from encu.plana_tem_ where pla_per = 150 and pla_lote=332

