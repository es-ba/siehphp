##FUN
positivo
##ESQ
comun
##PARA
revisar 
##DETALLE
##PROVISORIO

CREATE OR REPLACE FUNCTION comun.positivo(p_valor integer)
  RETURNS integer AS
/*
--prueba
select numero, valor, valor_esperado, caso, case when valor=valor_esperado then 'Correcto' else 'falla' end resultado
from 
      (  select 3 as numero, comun.positivo(3) valor, 3 valor_esperado, 1 caso union
        select -1, comun.positivo(-1), 0, 2 union
        select null, comun.positivo(null::integer), 0,3 union
        select -5, comun.positivo(-5), 0 , 4union
        select 10, comun.positivo(10), 10, 5 
       ) as x 
order by caso       
*/
  
'SELECT CASE WHEN ($1>=0) THEN $1 ELSE 0 END'
  LANGUAGE sql IMMUTABLE;
ALTER FUNCTION comun.positivo(integer)
  OWNER TO tedede_owner;
