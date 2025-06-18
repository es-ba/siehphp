##FUN
inghort53bis
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
-- Calculo de ingreso por horas trabajadas
set search_path = encu, dbo, comun, public;
-- Function: dbo.inghort53bis(p_enc ,p_hog, p_mie)

-- DROP FUNCTION dbo.inghort53bis(p_enc integer,p_hog integer, p_mie integer);
CREATE OR REPLACE FUNCTION dbo.inghort53bis(p_enc integer,p_hog integer, p_mie integer)
  RETURNS integer AS
'select 
    case 
        when nulo_a_neutro(v_meshort::integer)<0 or nulo_a_neutro(pla_i7a)<0 or nulo_a_neutro(pla_i11)<0 or
            nulo_a_neutro(pla_i12)<0 or nulo_a_neutro(pla_i13)<0 or nulo_a_neutro(pla_i14)<0 then  -9
        when v_meshort>0 and pla_i7a>0 then (pla_i7a/v_meshort)::integer
        when v_meshort>0 and pla_i14>0 then (pla_i14/v_meshort)::integer
        when v_meshort>0 and pla_i11=1 and pla_i12>=0 and pla_i13>=0 then ((pla_i12+pla_i13)/v_meshort)::integer
        when v_meshort>0 and pla_i11=2 and pla_i13>0 then (pla_i13/v_meshort)::integer
        else null::integer
    end  
  from (select *, dbo.meshort53bis(p_enc, p_hog, p_mie) as v_meshort 
            from encu.plana_i1_ 
            where pla_enc=p_enc and pla_hog=p_hog and pla_mie= p_mie
        ) as x'
LANGUAGE sql STABLE;    

ALTER FUNCTION dbo.inghort53bis(p_enc integer,p_hog integer, p_mie integer)
  OWNER TO tedede_php;


set search_path= encu, dbo, comun;

CREATE OR REPLACE FUNCTION dbo.inghort53bis_v2(
    p_enc integer,
    p_hog integer,
    p_mie integer)
    RETURNS integer
    LANGUAGE 'sql'
    COST 100
    STABLE PARALLEL UNSAFE
AS $BODY$
select 
    case 
        when nulo_a_neutro(v_meshort::integer)<0 or nulo_a_neutro(pla_i7a)<0 or nulo_a_neutro(pla_i11)<0 or
            nulo_a_neutro(pla_i12)<0 or nulo_a_neutro(pla_i13)<0 or nulo_a_neutro(pla_i14)<0 then  -9
        when v_meshort>0 and pla_i7a>0 then (pla_i7a/v_meshort)::integer
        when v_meshort>0 and pla_i14>0 then (pla_i14/v_meshort)::integer
        when v_meshort>0 and pla_i11=1 and pla_i12>=0 and pla_i13>=0 then ((pla_i12+pla_i13)/v_meshort)::integer
        when v_meshort>0 and pla_i11=2 and pla_i13>0 then (pla_i13/v_meshort)::integer
        else null::integer
    end  
  from (select *, dbo.meshort53bis_v2(p_enc, p_hog, p_mie) as v_meshort 
            from encu.plana_i1_ 
            where pla_enc=p_enc and pla_hog=p_hog and pla_mie= p_mie
        ) as x
$BODY$;

ALTER FUNCTION dbo.inghort53bis_v2(integer, integer, integer)
    OWNER TO tedede_php;
