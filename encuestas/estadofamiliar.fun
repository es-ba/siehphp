##FUN
estadofamiliar
##ESQ
dbo
##PARA
produccion
##PUBLICA
Sí
##PAR
p_enc INTEGER
p_hog INTEGER
p_mie INTEGER
##TIPO_DEVUELTO
valor de p5b
##CUERPO
CREATE OR REPLACE FUNCTION dbo.estadofamiliar(
    p_enc integer,
    p_hog integer,
    p_mie integer)
  RETURNS integer AS
$BODY$
DECLARE v_estado integer;
BEGIN
    v_estado := 0;
    select res_valor 
      from encu.respuestas
      where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and
        res_hog = p_hog and res_mie = p_mie and res_var = 'p5b' into v_estado;
    return v_estado;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION dbo.estadofamiliar(integer, integer, integer)
  OWNER TO tedede_php;
##NOMBRE

##DESCRIPCION
Devuelve el valor de la variable p5b que indica el estado conyugal  
