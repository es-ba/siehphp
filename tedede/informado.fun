##FUN
negado
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
create or replace function comun.negado(pBoolONull boolean) returns boolean
language sql CALLED ON NULL INPUT immutable
as $$select pBoolONull is not true $$;
##NOMBRE
Devuelve el negado incluso del NULL de modo que negado NULL sea TRUE
##DESCRIPCION
Devuelve el negado incluso del NULL de modo que negado NULL sea TRUE
##CASOS
      select 1,comun.negado(true ),false
union select 2,comun.negado(false),true
union select 3,comun.negado(null ),true;