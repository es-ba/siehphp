##FUN
anionac
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path=encu, comun, public;
CREATE OR REPLACE FUNCTION dbo.anionac(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer 
  LANGUAGE sql STABLE
AS  
$BODY$
    select pla_f_nac_a 
      from plana_s1_p
      where pla_enc = p_enc and pla_hog = p_hog and pla_mie = p_mie;
$BODY$;
