##FUN
coef_var_tab_tasa
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

create or replace function dbo.coef_var_tab_tasa(p_tabla text, p_grzona_n text, p_zona_n integer, p_numerador numeric, p_grzona_d text, p_zona_d integer, p_denominador numeric) returns numeric 
  language sql stable
as
$$
  select sqrt(v_n*v_n-v_d*v_d)
    from (select round(dbo.coef_var_tab(p_tabla, p_grzona_n, p_zona_n, p_numerador),1) as v_n,
                 round(dbo.coef_var_tab(p_tabla, p_grzona_d, p_zona_d, p_denominador),1) as v_d) x;
$$;

ALTER FUNCTION dbo.coef_var_tab_tasa(text, text, integer, numeric, text, integer, numeric) OWNER TO tedede_owner;
##CASOS_SQL
select coef_var_tab_tasa('personas', 'C', 1, 55667, 'T', 0, 76072), 3.38
