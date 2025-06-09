

--consulta bitacora

set search_path=encu; 
 select bit_proceso, bit_inicio, bit_fin,*,bit_resultado
  from bitacora inner join tiempo_logico on bit_tlg = tlg_tlg
       inner join sesiones on tlg_ses = ses_ses
       inner join http_user_agent on ses_httpua = httpua_httpua
  where bit_proceso ilike '%cargar_dispositivo%' and bit_parametros::jsonb->>'tra_cod_per' = 'xxx'
  order by bit_inicio desc
  limit 40;
 