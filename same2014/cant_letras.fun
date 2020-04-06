##FUN
cant_letras
##ESQ
dbo
##PARA
revisar 
##DETALLE

##PROVISORIO
set search_path = encu, comun, public;

create or replace function dbo.cant_letras(p_enc integer, p_hog integer) returns bigint
  language sql
as $$
select count(case when pla_l0<>'' then 1 else null end) 
  from encu.plana_s1_p p 
  where p_enc = p.pla_enc and p_hog=p.pla_hog
$$;

alter function dbo.cant_letras(integer, integer) owner to tedede_php;