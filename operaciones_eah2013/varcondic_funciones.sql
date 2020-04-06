create or replace function dbo.dic_parte(p_dic text, p_origen text, p_destino integer) returns boolean 
language sql stable as
$BODY$
  select p_origen ~ 
    ('(\m' || coalesce((select string_agg(varcondic_origen, '\M|\m') 
      from encu.varcondic 
      where varcondic_dic=p_dic and varcondic_destino=p_destino),'')|| '\M)' )
$BODY$;
ALTER FUNCTION dbo.dic_parte(text, text, integer) OWNER TO tedede_owner;
  
-- Ejemplo:
select pla_t37,pla_t37sd,*
  from encu.plana_i1_
  where pla_t37 is not null and pla_t37sd is distinct from 1
    and dbo.dic_parte($$serv_dom_txt$$,pla_t37,1);

create or replace function dbo.dic_tradu(p_dic text, p_origen text) returns integer
language sql stable as
$BODY$
  select varcondic_destino from encu.varcondic where varcondic_dic=p_dic and varcondic_origen=dbo.cadena_normalizar(p_origen)
$BODY$;
ALTER FUNCTION dbo.dic_tradu(text, text) OWNER TO tedede_owner;

select pla_t39_barrio, dbo.dic_tradu($$t39_barrio$$,pla_t39_barrio)
  from encu.plana_i1_
  where pla_t39_barrio is not null
  limit 100;
  