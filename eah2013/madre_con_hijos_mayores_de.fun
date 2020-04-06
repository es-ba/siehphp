##FUN
madre_con_hijos_mayor_de
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION dbo.madre_con_hijos_mayor_de(p_enc integer, p_hog integer, p_mie integer, p_edad integer, p_unidad_tiempo integer)
  RETURNS boolean AS
$BODY$
DECLARE
 v_respuesta boolean;
BEGIN 
  case p_unidad_tiempo
     when 1 then
	  select case when count(pla_mie)>0 then true else false end into v_respuesta from encu.plana_s1_p where pla_enc = p_enc and pla_hog = p_hog and pla_p6_b = p_mie and pla_edad > p_edad;
     when 2 then
	  select case when count(p.pla_mie)>0 then true else false end into v_respuesta from encu.plana_s1_p p
                                                                                           inner join encu.plana_s1_ s on p.pla_enc = s.pla_enc and p.pla_hog = s.pla_hog
                                                                                           where p.pla_enc = p_enc and p.pla_hog = p_hog and p.pla_p6_b = p_mie 
                                                                                           and dbo.meses_a_la_fecha(pla_f_nac_o, pla_f_realiz_o) > p_edad;
     else
	v_respuesta:=false;
  end case;
  return v_respuesta;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*OTRA*/
ALTER FUNCTION dbo.madre_con_hijos_mayor_de(integer, integer, integer, integer, integer)
  OWNER TO tedede_php;
