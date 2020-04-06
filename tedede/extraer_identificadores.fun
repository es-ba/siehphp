##FUN
extraer_identificadores
##ESQ
comun
##PARA
produccion
##PUBLICA
no
##PAR
texto donde se deben extraer los identificadores
##TIPO_DEVUELTO
SET OF text
##TIPO_FUNCION
plpgsql
##DESCRIPCION
extrae los identificadores que reconoce utilizando regexp_matches y los patterns definidos en consistencia.php.
Devuelve un identificador por fila. 
##CUERPO
DROP FUNCTION comun.extraer_identificadores(text);
CREATE OR REPLACE FUNCTION comun.extraer_identificadores(p_texto TEXT)
    RETURNS SETOF TEXT AS
$BODY$
DECLARE
    v_operadores_logicos_regexp   text;
    v_pg_identifica_var_regexp    text;             
BEGIN
    v_operadores_logicos_regexp='or|and|is|end|in|not|true|false|null|case|when|else|from|then|contarc|distinct';
    v_pg_identifica_var_regexp='(\m[A-Za-z][A-Za-z_0-9]*\M)(?![(.])';
    return query SELECT distinct x.v_ident  
                        from (select (regexp_matches(p_texto, v_pg_identifica_var_regexp, 'g'))[1] as v_ident) as x
                        where (x.v_ident !~* ('\m('||v_operadores_logicos_regexp||')\M'));
END;
$BODY$
  LANGUAGE plpgsql ;
ALTER FUNCTION comun.extraer_identificadores(p_texto TEXT)
    OWNER TO tedede_php;

-- #pruebas
select * from (
select esperado, string_agg(obtenido, ',' order by obtenido) obtenidos
from (
SELECT comun.extraer_identificadores('t_categ = 1') obtenido, 't_categ' esperado
union select comun.extraer_identificadores('@(contarc@coding@coding=-9 and p4 is distinct from 13)@>0) or (@(contarc@coding@coding=0 and p4 is distinct from 13)@>0 and @(contarc@coding@coding=1 and p4 is distinct from 13)@>0)'), 'coding,p4' as esperado
union select comun.extraer_identificadores('i3_tot < 0 or i3_1x<0 or i3_2x<0 or i3_3x<0 or dbo.t(z) and fun(7)'), 'i3_1x,i3_2x,i3_3x,i3_tot,z' as esperado
union select comun.extraer_identificadores('CASE WHEN v_bool OR v_num>10 THEN v_esta ELSE v_otra END'), 'v_bool,v_esta,v_num,v_otra' as esperado
) x
group by esperado
) x
where esperado is distinct from obtenidos;