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
##TIPO_DEVUELTO
mes de la fecha de realizacion del s1 f_realiz_o
stable sql
##CUERPO
CREATE OR REPLACE FUNCTION dbo.f_realiz_mes(
    p_enc integer,
    p_hog integer)
  RETURNS integer AS
$BODY$
  select date_part('month', to_date(pla_f_realiz_o, 'dd/mm/yyyy')) ::integer
    from encu.plana_s1_ 
    where pla_enc=p_enc and pla_hog=$2
$BODY$
  LANGUAGE sql ;
ALTER FUNCTION dbo.f_realiz_mes(integer, integer)
  OWNER TO tedede_php;
