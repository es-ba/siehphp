create or replace function dbo.dic_parte(p_dic text, p_origen text, p_destino integer) returns boolean 
language sql as
$BODY$
  select p_origen ~ 
    ('(\m' || coalesce((select string_agg(dictra_ori, '\M|\m') 
      from encu.dictra
      where dictra_dic=p_dic and dictra_des=p_destino),'')|| '\M)' )
$BODY$;
ALTER FUNCTION dbo.dic_parte(text, text, integer) OWNER TO tedede_owner;

--- para consistencia serv_dom_txt
select pla_t37,pla_t37sd, *
  from encu.plana_i1_
  where pla_t37 is not null and pla_t37sd is distinct from 1
    and dbo.dic_parte($$serv_dom_txt$$,pla_t37,1) and not(dbo.dic_parte($$serv_dom_txt$$,pla_t37,2))
    and (not pla_t38=1 and pla_t39_bis2=13);
--- para consistencia dic_falta_t39_barrio
select pla_t39_barrio, *
  from encu.plana_i1_
  where pla_t39_barrio is not null 
    and dbo.dic_tradu($$barrio$$,pla_t39_barrio) is null;
   
    
create or replace function dbo.dic_tradu(p_dic text, p_origen text) returns integer
language sql as
$BODY$
  select dictra_des from encu.dictra where dictra_dic=p_dic and dictra_ori=dbo.cadena_normalizar(p_origen)
$BODY$;
ALTER FUNCTION dbo.dic_tradu(text, text) OWNER TO tedede_owner;

select pla_t39_barrio, dbo.dic_tradu($$barrio$$,pla_t39_barrio)
  from encu.plana_i1_
  where pla_t39_barrio is not null
  limit 100;
  