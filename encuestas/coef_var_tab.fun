##FUN
coef_var_tab
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

delete from tab_coef_var where tabcoefvar_dato is null;

create or replace function dbo.coef_var_tab(p_tabla text, p_grzona text, p_zona integer, p_poblacion numeric) returns numeric 
  language sql stable
as
$$
select tabcoefvar_dato::numeric
  from (
    select *,
           coalesce(lead(tabcoefvar_poblacion)over(partition by tabcoefvar_tabla, tabcoefvar_grzona, tabcoefvar_zona),-99999999999999999) as anterior,
           coalesce(lag(tabcoefvar_poblacion)over(partition by tabcoefvar_tabla, tabcoefvar_grzona, tabcoefvar_zona),99999999999999999) as siguiente
      from tab_coef_var 
      where tabcoefvar_tabla=p_tabla and tabcoefvar_grzona=p_grzona and tabcoefvar_zona=p_zona
      -- where tabcoefvar_tabla='personas' and tabcoefvar_grzona='C' and tabcoefvar_zona=3 
      ) x
  where p_poblacion between (tabcoefvar_poblacion+anterior)/2 and (tabcoefvar_poblacion+siguiente)/2
$$;

ALTER FUNCTION dbo.coef_var_tab(text, text, integer, numeric) OWNER TO tedede_owner;
##CASOS_SQL

      select coef_var_tab('personas', 'C', 3, 210001), 3.5676
union select coef_var_tab('personas', 'C', 3, 159999), 4.0182
union select coef_var_tab('personas', 'C', 3, 140001), 4.2658
union select coef_var_tab('personas', 'C', 3,   2000), 30.3432