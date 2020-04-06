##FUN
esta_palabra_en_texto_despues_de_salta
##ESQ
comun
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION comun.esta_palabra_en_texto_despues_de_salta(p_palabra text, p_texto TEXT)
RETURNS BOOLEAN AS
$BODY$
select case when p_palabra = any (regexp_split_to_array(substr(coalesce(substring( p_texto from '\m[sS][aA][lL][tT][aA] .*'),''),7),E'\\s+')) then TRUE else FALSE end ;
$BODY$
LANGUAGE sql IMMUTABLE;
ALTER FUNCTION comun.esta_palabra_en_texto_despues_de_salta(p_palabra text, p_texto TEXT)
OWNER TO tedede_php;

select '456' pal, ' wqz abs salta 123 456 y>3' texto, comun.esta_palabra_en_texto_despues_de_salta('456',' wqz abs salta 123 456 y>3') union
select 'wqz' pal,' wqz abs salta 123 456 y>3' texto, comun.esta_palabra_en_texto_despues_de_salta('wqz',' wqz abs salta 123 456 y>3') union
select 'wqz' pal, ' wqz abs 123 456 y>3' texto, comun.esta_palabra_en_texto_despues_de_salta('wqz',' wqz abs 123 456 y>3' ) union
select 'wqz' pal, ' wqz abs Salta' texto, comun.esta_palabra_en_texto_despues_de_salta('wqz',' wqz abs Salta' ) union
select '3+5' pal, ' wqz abs SALTA 3+5 3__4' texto, comun.esta_palabra_en_texto_despues_de_salta('3+5',' wqz abs Salta 3+5 3__4' ) union
select '3+5' pal, ' wqz abs sSALTA 3+5 3__4' texto, comun.esta_palabra_en_texto_despues_de_salta('3+5',' wqz abs sSalta 3+5 3__4' ) union
select 'bbbb' pal, ' wqz abs Salta qqqqq bbbb eee' texto, comun.esta_palabra_en_texto_despues_de_salta('bbbb',' wqz abs Salta qqqqq bbbb eee' )