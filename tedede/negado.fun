##FUN
informado
##ESQ
comun
##PARA
produccion
##PUBLICA
Sí
##PAR
p_valor TEXT ó INTEGER
##TIPO_DEVUELTO
boolean
##TIPO_FUNCION
immutable plpgsql
##CUERPO
CREATE OR REPLACE FUNCTION comun.informado("P_valor" integer)
  RETURNS boolean AS
$$SELECT $1 IS NOT NULL$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.informado(integer)
  OWNER TO tedede_php;
CREATE OR REPLACE FUNCTION comun.informado("P_valor" text)
  RETURNS boolean AS
$$SELECT $1 !~ '^\s*$' AND $1 IS NOT NULL$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.informado(integer)
  OWNER TO tedede_php;
##NOMBRE
Devuelve el negado incluso del NULL de modo que negado NULL sea TRUE
##DESCRIPCION
Devuelve el negado incluso del NULL de modo que negado NULL sea TRUE
##CASOS
      select 1,comun.negado(true ),false
union select 2,comun.negado(false),true
union select 3,comun.negado(null ),true;