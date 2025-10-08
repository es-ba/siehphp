##FUN
trimestre_operativo_base
##ESQ
dbo
##PARA
revisar 
##DETALLE
si hubiera otro operativo nuevo a considerar debería ser incluido en el código de la función 
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION dbo.trimestre_operativo_base()
  RETURNS integer AS
  $BODY$
    select case when substr(dbo.ope_actual(),1,4)='etoi' then substr(dbo.ope_actual(),7,1)::integer 
                when substr(dbo.ope_actual(),1,3)='eah' then
                    case when dbo.anio()>=2024 then 3 -- a partir de 2024, eah cambia trimestre
                         else 4
                    end
                when dbo.ope_actual() ='prp_acj2025' then 4   
                else null
           end
  $BODY$           
  LANGUAGE sql IMMUTABLE;
ALTER FUNCTION dbo.trimestre_operativo_base()
  OWNER TO tedede_php;
##CASOS_SQL
##Por ejemplo para: eah2014 select dbo.trimestre_operativo_base da 4 ;
                    etoi143 select dbo.trimestre_operativo_base da 3 ;
                    etoi151 select dbo.trimestre_operativo_base da 1 ;
                    same2014 select dbo.trimestre_operativo_base da null;
