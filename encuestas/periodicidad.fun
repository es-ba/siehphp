##FUN
periodicidad(p_rotacion_etoi)
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
-- calcula perioricidad a partir de rotaci_n_etoi, dominio, anio_operativo y nombre operativo actual
set search_path = encu, dbo, comun, public;

--drop function dbo.periodicidad(integer, integer);
CREATE OR REPLACE FUNCTION dbo.periodicidad(p_rotacion_etoi integer, p_dominio integer)
  RETURNS character varying(1) AS
$BODY$
    select case when p_dominio= 3 then
      case substr(dbo.ope_actual(),1,3) 
        when 'eah' then 
            case when (dbo.anio()>='2014') then
                case when(p_rotacion_etoi= 4)then 'A'
                    else 'T'
                    end
                else null
            end
        when 'eto' then
            'T'
        else   
            null
        end
      else null end  ;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.periodicidad(p_rotacion_etoi integer, p_dominio integer)
  OWNER TO tedede_php;
##CASOS_SQL  
select pla_enc, pla_rotaci_n_etoi, dbo.ope_actual, dbo.anio(), dbo.periodicidad(pla_rotaci_n_etoi, pla_dominio) --200606,404703
  from encu.plana_tem_
limit 100  ;



