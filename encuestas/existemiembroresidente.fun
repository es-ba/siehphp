##FUN
existemiembroresidente
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION dbo.existemiembroresidente(
    p_enc integer,
    p_hog integer,
    p_mie integer)
    RETURNS bigint
    LANGUAGE 'sql'
    STABLE 
AS $BODY$
    select count(distinct (res_mie)) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var='r0' and res_valor='1';
$BODY$;

ALTER FUNCTION dbo.existemiembroresidente(integer, integer, integer)
    OWNER TO tedede_php;
