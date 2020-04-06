##FUN
cant_personas_sexo
##ESQ
dbo
##PARA
produccion
##PUBLICA
Sí
##PAR
p_enc integer
p_hog INTEGER
p_mie INTEGER
p_sexo integer
##TIPO_DEVUELTO
cantidad de miembros del hogar de sexo p_sexo
##TIPO_FUNCION
stable plpgsql
##CUERPO
CREATE OR REPLACE FUNCTION dbo.cant_personas_sexo(
    p_enc integer,
    p_hog integer,
    p_sexo integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
  from encu.plana_s1_p where pla_enc=p_enc and pla_hog=p_hog and pla_sexo=p_sexo;
  return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION dbo.cant_personas_sexo(integer, integer, integer)
  OWNER TO tedede_php;
