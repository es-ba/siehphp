##FUN
tiene_hijo
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
boolean
##CUERPO
DECLARE
 v_cantidad integer; 
BEGIN 
  select count(*) into v_cantidad
    from encu.plana_s1_p s1p 
    where pla_enc=p_enc and pla_hog=p_hog  and (pla_p6_a=p_mie or pla_p6_b=p_mie);
  if v_cantidad>0 then
     return TRUE;
  else
     return FALSE;
  end if;
END;

##NOMBRE
Tiene hijo
##DESCRIPCION
Si el miembro tiene hijo declarado en el hogar.

Esto solo aplica a menores de 24 años que contestan las preguntas P6a y P6b

