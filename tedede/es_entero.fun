##FUN
es_entero
##ESQ
comun
##PARA
produccion
##PUBLICA
Sí
##PAR
p_valor TEXT
##TIPO_DEVUELTO
boolean
##TIPO_FUNCION
immutable plpgsql
##CUERPO
DECLARE
  valor_numerico integer;
BEGIN
  valor_numerico:=p_valor::integer;
  RETURN true;
EXCEPTION
  WHEN invalid_text_representation or numeric_value_out_of_range THEN
    RETURN false;  
  -- WHEN others THEN     return false;
END;
##NOMBRE
Indica que si el parametro en un numero entero
##DESCRIPCION
Devuelve true  si es entero , false si no se puede representar como entero porque tiene letras o esta fuera de rango, cualquier otro error  envia una excepcion. 
##CASOS
select '123456789123456789' txt, comun.es_entero('123456789123456789') es_entero, 'numeric_value_out_of_range' obs
union
select '123456789' txt, comun.es_entero('123456789'), 'OK'
union
select '12345abc' txt, comun.es_entero('12345abc'), 'invalid_text_representation'
union
select '123.50' txt, comun.es_entero('123.50'), 'invalid_text_representation'
union
select '-123' txt, comun.es_entero('-123'), 'OK'

/*
CREATE OR REPLACE FUNCTION comun.es_entero(p_valor text)
  RETURNS boolean AS
$BODY$
DECLARE
  valor_numerico integer;
BEGIN
  valor_numerico:=p_valor::integer;
  RETURN true;
EXCEPTION
  WHEN invalid_text_representation OR
       numeric_value_out_of_range THEN
    RETURN false;  
  -- WHEN others THEN     return false;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.es_entero(text)
  OWNER TO tedede_owner;
*/
