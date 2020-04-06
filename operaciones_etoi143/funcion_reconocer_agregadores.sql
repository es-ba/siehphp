
CREATE OR REPLACE FUNCTION encu.reconocer_agregadores(p_cual text, p_funcion OUT text, p_expresion OUT text, p_filtro OUT text) RETURNS RECORD 
LANGUAGE sql IMMUTABLE AS
$BODY$
  SELECT trim(v_obtenido[1]), trim(v_obtenido[2]), trim(v_obtenido[4]) from regexp_matches(p_cual,'@\(([^@]*)@([^@]*)(@([^@]*))?\)@') as v_obtenido;
/*
  SELECT entrada, funcion, expresion, filtro, encu.reconocer_agregadores(entrada)
    FROM (SELECT 't55>@(sumap@ i3_x + i3_t @ edad>14)@' as entrada, 'sumap' as funcion, 'i3_x + i3_t' as expresion, 'edad>14' as filtro
         UNION SELECT 't55>@( sumap @X25)@ + 44' as entrada, 'sumap' as funcion, 'X25' as expresion, null as filtro
         UNION SELECT 't55 + 1 ' as entrada, 'sumap' as funcion, 'X25' as expresion, null as filtro
         UNION SELECT '@( sumap @ sarasa sasa )@' as entrada, 'sumap' as funcion, 'sarasa sasa' as expresion, null as filtro) x
    WHERE (funcion, expresion, filtro) is distinct from encu.reconocer_agregadores(entrada);
--*/
$BODY$;
ALTER FUNCTION encu.reconocer_agregadores(text)
  OWNER TO tedede_php;

