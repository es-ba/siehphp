##FUN
sd_valor_hora
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO

-- calcula el valor de hora de trabajo de servicio domestico

set search_path = encu, dbo, comun, public;

-- Function: dbo.sd_valor_hora(p_enc ,p_hog,...)

/* 
DROP FUNCTION if exists dbo.sd_valor_hora(p_enc integer,p_hog integer,
    p_sd3 integer,
    p_sd4 integer,
    p_sd5 integer,
    p_sd6 integer,
    p_sd7 integer,
    p_sd7_1 integer,
    p_sd7_2 integer,
    p_sd7_3 integer,
    p_sd7_4 integer
);
DROP FUNCTION if exists dbo.sd_valor_hora(p_enc integer,p_hog integer,
    p_sd1 integer,
    p_sd2 integer,
    p_sd3 integer,
    p_sd4 integer,
    p_sd5 integer,
    p_sd6 integer,
    p_sd7 integer,
    p_sd7_1 integer,
    p_sd7_2 integer,
    p_sd7_3 integer,
    p_sd7_4 integer
);
*/

CREATE OR REPLACE FUNCTION dbo.sd_valor_hora(p_enc integer,p_hog integer,
    p_sd1 integer,
    p_sd2 integer,
    p_sd3 integer,
    p_sd4 integer,
    p_sd5 integer,
    p_sd6 integer,
    p_sd7 integer,
    p_sd7_1 integer,
    p_sd7_2 integer,
    p_sd7_3 integer,
    p_sd7_4 integer
)
  RETURNS decimal AS
$BODY$  
DECLARE
    vfactorsem integer;
    vmonto integer; 
    vmontoxhora integer;
BEGIN
    vmontoxhora=null;
    if p_sd1=1 and p_sd2= 1 then
        vfactorsem=1; 
        if p_sd3>= 0 then
           vmontoxhora=p_sd3;
        else   
            if p_sd6>0 THEN
                CASE WHEN p_sd7=1 THEN
                    vmonto=p_sd7_1;
                    WHEN p_sd7=2 THEN
                        vmonto=p_sd7_2;
                    WHEN p_sd7=3 THEN
                        vmonto=p_sd7_3;
                        vfactorsem=2.0;
                    WHEN p_sd7=4 THEN
                        vmonto=p_sd7_4;
                        vfactorsem=4.0;
                    ELSE
                        vmonto=-9;        
                END CASE;  
                CASE WHEN vmonto<0 THEN vmontoxhora=-9; 
                    WHEN p_sd4=1 or p_sd4=2 and (p_sd7=1 or p_sd7=3) or p_sd4=3 and p_sd7=1 THEN
                        vmontoxhora=round((vmonto/p_sd6::numeric)::numeric)::numeric;
                    WHEN p_sd4=2 and p_sd7=4 THEN
                        vmontoxhora=round((vmonto/(2.0*p_sd6)::numeric)::numeric)::numeric;
                    WHEN p_sd4=3 and p_sd7>=2 and p_sd5>=0 THEN
                        vmontoxhora=round((vmonto/(vfactorsem*p_sd5*p_sd6)::numeric)::numeric)::numeric;
                        --raise notice 'sd4=3 sd7>=2 vmonto % vfactorsem % sd5 % sd6 % hd %', vmonto,vfactorsem ,p_sd5, p_sd6, vmontoxhora; 
                    ELSE    
                        vmontoxhora=-9;
                END CASE;
            ELSE 
                vmontoxhora=-9; 
            END if; 
        end if;
    end if;
    RETURN vmontoxhora;
END;
$BODY$  
  LANGUAGE plpgsql STABLE;

ALTER FUNCTION dbo.sd_valor_hora(p_enc integer,p_hog integer,
    p_sd1 integer,
    p_sd2 integer,
    p_sd3 integer,
    p_sd4 integer,
    p_sd5 integer,
    p_sd6 integer,
    p_sd7 integer,
    p_sd7_1 integer,
    p_sd7_2 integer,
    p_sd7_3 integer,
    p_sd7_4 integer)
  OWNER TO tedede_php;
  
/*
SELECT  dbo.sd_valor_hora(g.pla_enc, g.pla_hog,  
        g.pla_sd1, g.pla_sd2,g.pla_sd3, g.pla_sd4, g.pla_sd5, g.pla_sd6, g.pla_sd7, 
       g.pla_sd7_1, g.pla_sd7_2, g.pla_sd7_3, pla_sd7_4) valhora,g.pla_sd1, g.pla_sd2,g.pla_sd3, g.pla_sd4, g.pla_sd5, g.pla_sd6, g.pla_sd7, 
       g.pla_sd7_1, g.pla_sd7_2, g.pla_sd7_3, pla_sd7_4, g.pla_al1, pla_rea, pla_gh_tot
from encu.plana_gh_ g join encu.plana_tem_ t on t.pla_enc=g.pla_enc and informado(g.pla_sd4) 
--where g.pla_enc=194105 and g.pla_hog=1
order by g.pla_enc, g.pla_hog
limit 100;

*/