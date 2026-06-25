##FUN
cant_mascotas_pyg2
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun;
CREATE OR REPLACE FUNCTION dbo.cant_mascotas_pyg2(p_enc integer, p_hog integer, p_pyg2 integer)
  RETURNS integer AS
$BODY$
  with aux as(
    select count(*) cant
      from encu.plana_pg1_m 
      where pla_enc=p_enc and pla_hog=p_hog and pla_pyg2=p_pyg2
  )  
  select coalesce(cant,0)
    from aux;
$BODY$
LANGUAGE sql ;
ALTER FUNCTION dbo.cant_mascotas_pyg2(integer, integer, integer)
  OWNER TO tedede_php;

CREATE OR REPLACE FUNCTION dbo.cant_perro(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
  select  dbo.cant_mascotas_pyg2(p_enc, p_hog, 1);
$BODY$
LANGUAGE sql ;
ALTER FUNCTION dbo.cant_perro(integer, integer)
  OWNER TO tedede_php;
CREATE OR REPLACE FUNCTION dbo.cant_gato(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
  select  dbo.cant_mascotas_pyg2(p_enc, p_hog, 2);
$BODY$
LANGUAGE sql ;
ALTER FUNCTION dbo.cant_gato(integer, integer)
  OWNER TO tedede_php;


##CASOS_SQL