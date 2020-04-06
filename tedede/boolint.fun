##FUN
boolint
##ESQ
comun
##PARA
produccion
##PUBLICA
Sí
##PAR
p_valor BOOLEAN
p_valor_por_falso INTEGER
p_valor_por_true INTEGER
##TIPO_DEVUELTO
boolean
##TIPO_FUNCION
immutable plpgsql
##CUERPO
BEGIN
  IF p_valor THEN
    RETURN p_valor_por_true;
  ELSE 
    RETURN p_valor_por_falso;
  END IF;
END;
##NOMBRE
Pasa de bool a int
##DESCRIPCION
Devuelve 1 si es true y 0 si es false. 

Se puede usar para contar casos sumando. Ej: boolint(t1a)+boolint(t1b)+boolint(t1c)>1
##CASOS
1; true
0; false
2; false 2
3; true  2 3
