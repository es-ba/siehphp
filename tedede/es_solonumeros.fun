##FUN
es_solonumeros
##ESQ
comun
##PARA
produccion
##PUBLICA
Sí
##PAR
p_valor TEXT
##TIPO_DEVUELTO
BOOLEAN
##CUERPO
CREATE OR REPLACE FUNCTION comun.es_solonumeros(p_valor text)
  RETURNS boolean AS
'select p_valor  ~ ''^\d+'''
  LANGUAGE sql IMMUTABLE;
ALTER FUNCTION comun.es_solonumeros(text)
  OWNER TO tedede_php;
##NOMBRE

##DESCRIPCION
Devuelve el True si p_valor es un string compuesto por numeros, false en otro caso.   
