set search_path = siscen, comun, public;

/*
-- verificamos que hay una única acción para cada posible cambio entre estados

select reqestflu_origen, reqestflu_destino, count(*), string_agg(reqestflu_accion, ', ')
  from req_est_flu
  group by reqestflu_origen, reqestflu_destino;

-- y nos lo aseguramos para el futuro
alter table req_est_flu add constraint "origen, destino debe ser unico" unique (reqestflu_origen, reqestflu_destino);
-- */

/*
create or replace view req_cambio_estado as 
select reqnov_proy as reqcam_proy, 
       reqnov_req as reqcam_req, 
       reqnov_reqnov as reqcam_reqnov, 
       reqnov_reqest as reqcam_reqest, 
       lead(reqnov_reqest, -1) over (partition by reqnov_proy, reqnov_req order by reqnov_reqnov) as reqcam_est_ant,
       tlg_momento as reqcam_momento,
       req_costo as reqcam_costo
  from req_nov inner join requerimientos on req_proy=reqnov_proy and req_req=reqnov_req -- pk verificada
       inner join tiempo_logico on tlg_tlg=reqnov_tlg -- pk verificada
-- */


-- vamos a ver si todos los cambios son explicados por algúna acción

select to_char(trimestre,'YYYY-Q'), *,
    (select count(*) as cantidad_novedades
            from req_nov inner join tiempo_logico on reqnov_tlg=tlg_tlg
            where tlg_momento between trimestre and trimestre + interval '3 month') abiertos_viejos 
 from (
select date_trunc('quarter',reqcam_momento) as trimestre, 
       count(case when reqestflu_origen is null and reqcam_est_ant is not null then 1 else null end) as errores,
       sum(case when reqestflu_accion='terminar' then coalesce(reqcam_costo,1) else null end) as terminados,
       sum(case when reqestflu_accion='reabrir' then coalesce(reqcam_costo,1) else null end) as reabiertos
  from req_cambio_estado left join req_est_flu on reqcam_reqest = reqestflu_destino and reqcam_est_ant = reqestflu_origen
  group by date_trunc('quarter',reqcam_momento)) x
  order by 1;