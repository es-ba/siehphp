update encu.respuestas
  set res_valor=case res_var when 'per' then 62 when 'per_a_cargar' then null when 'estado_carga' then 1 when 'rol' then 1 end
  where res_var in ('per','per_a_cargar','estado_carga','rol')
    and res_for='TEM' 
    and res_enc in (
select pla_enc
  from encu.plana_tem_
  where pla_lote=16)

/*
update encu.respuestas
  set res_valor=case res_var when 'per' then 34 when 'per_a_cargar' then null when 'estado_carga' then 1 end
  where res_var in ('per','per_a_cargar','estado_carga')
    and res_for='TEM' 
    and res_enc in (112274,112273)
    -- */