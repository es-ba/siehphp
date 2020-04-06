create or replace function dbo.fam_serv_dom(p_enc integer, p_hog integer, p_mie integer) returns boolean
  language sql as
$$
  select pla_p4=13
    from encu.plana_s1_p 
    where pla_enc=p_enc  
      and pla_hog=p_hog
      and pla_mie=p_mie;
$$;

-- Function: dbo.tipo_hogar(integer, integer, integer)

-- DROP FUNCTION dbo.tipo_hogar(integer, integer, integer);

CREATE OR REPLACE FUNCTION dbo.tipo_hogar(p_enc integer, p_hog integer, p_variante integer)
  RETURNS integer AS
$BODY$
select case when p_variante=7 then split_part(tipo_hogar_7, ' ', 1)::integer else -5 end
from (
select 
   case when miembros<>jefes+parejas+hijos+otros_familiares+no_familiares+serv_dom then 'Miembros ' else '' end 
    || case when hijos<>hijos_solteros+hijos_no_solteros then 'Hijos ' else '' end 
    || case when hijos_solteros<>hijos_solteros_sin_hijos+hijos_solteros_con_hijos then 'HSolteros ' else '' end 
    || case when hijos<>hijos_solteros_sin_hijos+otros_hijos then 'OHijos' else '' end as controles
   , case when miembros-serv_dom=1 then '1 No Fam Unipersonal' 
          when miembros-serv_dom-no_familiares=1 then '2 No Fam Multipersonal'
          when parejas>0 and otros_familiares=0 and no_familiares=0 and otros_hijos=0 then '3 Fam Nuclear de Nucleo completo'
          when parejas=0 and hijos_solteros_sin_hijos>0 and otros_familiares=0 and no_familiares=0 and otros_hijos=0 then '4 Fam Nuclear de Nucleo incompleto'
          when parejas>0 and otros_familiares+no_familiares+otros_hijos>0 then '5 Fam Extendido y Complejo de Nucleo completo'
          when parejas=0 and hijos_solteros_sin_hijos>0 and otros_familiares+no_familiares+otros_hijos>0 then '6 Fam Extendido y Complejo de Nucleo incompleto'
          when parejas=0 and hijos_solteros_sin_hijos=0 and otros_familiares+otros_hijos>0 then '7 Fam Extendido y Complejo sin Nucleo'
          else '-5 error' end as tipo_hogar_7 
   , *
from (
select pla_enc, pla_hog
       , sum(1) as miembros
       , sum(case when pla_p4=1 then 1 else 0 end) as jefes
       , sum(case when pla_p4=2 then 1 else 0 end) as parejas
       , sum(case when pla_p4 in (3,4) then 1 else 0 end) as hijos
       , sum(case when pla_p4 in (3,4) and (pla_p5=6 or pla_p5 is null) then 1 else 0 end) as hijos_solteros
       , sum(case when pla_p4 in (3,4) and (pla_p5=6 or pla_p5 is null) and cantidad_hijos is null then 1 else 0 end) as hijos_solteros_sin_hijos
       , sum(case when pla_p4 in (3,4) and (pla_p5=6 or pla_p5 is null) and cantidad_hijos>0 then 1 else 0 end) as hijos_solteros_con_hijos
       , sum(case when pla_p4 in (3,4) and (pla_p5<>6) then 1 else 0 end) as hijos_no_solteros
       , sum(case when pla_p4 in (3,4) and ((pla_p5<>6) or cantidad_hijos>0) then 1 else 0 end) as otros_hijos
       , sum(case when pla_p4 in (5,6,7,8,9,10,11,12) then 1 else 0 end) as otros_familiares
       , sum(case when pla_p4 in (14) and not dbo.fam_serv_dom(pla_enc, pla_hog, pla_mie) then 1 else 0 end) as no_familiares
       , sum(case when dbo.fam_serv_dom(pla_enc, pla_hog, pla_mie) then 1 else 0 end) as serv_dom
  from (
         select m.*, (select sum(1) from encu.plana_s1_p h where h.pla_enc=m.pla_enc and h.pla_hog=m.pla_hog and (h.pla_p6_a=m.pla_mie or h.pla_p6_b=m.pla_mie)) cantidad_hijos
           from encu.plana_s1_p m inner join encu.plana_i1_ i on m.pla_enc=i.pla_enc and m.pla_hog=i.pla_hog and m.pla_mie=i.pla_mie
	   -- where m.pla_enc<=130100 
	   where m.pla_enc=p_enc and m.pla_hog=p_hog
	   order by 1,2,3
        ) x
  group by pla_enc,pla_hog
) y
) z
--else -5 end
-- where controles<>'' or tipo_hogar='-5 error'
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION dbo.tipo_hogar(integer, integer, integer)
  OWNER TO tedede_php;
