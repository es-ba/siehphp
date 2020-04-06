-- Function: dbo.fecha_30junio()

-- DROP FUNCTION dbo.fecha_30junio();

CREATE OR REPLACE FUNCTION dbo.fecha_30junio()
  RETURNS text AS
$BODY$
begin
	return '30/06/'||dbo.anio()::text;
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION dbo.fecha_30junio()
  OWNER TO tedede_php;

--select dbo.fecha_30junio();
--select dbo.edad_a_la_fecha('31/5/1991',dbo.fecha_30junio());

select regexp_split_to_array('31/7/1991', '/');	

-- Function: comun.es_fecha_parcial(text)
-- DROP FUNCTION comun.es_fecha_parcial(text);

CREATE OR REPLACE FUNCTION comun.es_fecha_parcial(p_fecha text)
  RETURNS boolean AS
$BODY$
DECLARE
  v_fecha_construida text;
  v_array_fecha text[];
begin
     if(comun.es_fecha(p_fecha)) then
        return true;
     else
       v_array_fecha:=regexp_split_to_array(p_fecha, '/');
       if array_length(v_array_fecha, 1) < 2 then
          return false;
       else
          v_fecha_construida:='15/'||v_array_fecha[array_length(v_array_fecha, 1)-1]||'/'||v_array_fecha[array_length(v_array_fecha, 1)];
          if(comun.es_fecha(v_fecha_construida)) then
	      return true;
	  else
	      return false;
	  end if;
       end if;
     end if;	
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.es_fecha_parcial(text)
  OWNER TO tedede_php;

/*
select z.mi_fecha, z.z_array, comun.es_fecha_parcial(z.mi_fecha), z.f_nac from
(select '15/'||y.el_array[y.cant-1]||'/'||y.el_array[y.cant] as mi_fecha, y.el_array as z_array, y.f_nac as f_nac from
(select array_length(x.mi_array, 1) as cant, x.mi_array as el_array, x.f_nac as f_nac from
(select regexp_split_to_array(pla_f_nac_o, '/') as mi_array, pla_f_nac_o as f_nac
from encu.plana_s1_p p inner join encu.plana_tem_ t on p.pla_enc= t.pla_enc where not(comun.es_fecha(pla_f_nac_o)) ) as x) as y) as z where comun.es_fecha_parcial(z.mi_fecha);
*/

-- Function: comun.es_fecha_parcial(text)
-- DROP FUNCTION comun.es_fecha_parcial(text);

CREATE OR REPLACE FUNCTION comun.completar_fecha(p_fecha text)
  RETURNS text AS
$BODY$
DECLARE
  v_fecha_construida text;
  v_array_fecha text[];
begin
     if(comun.es_fecha(p_fecha)) then
        return p_fecha;
     else
       v_array_fecha:=regexp_split_to_array(p_fecha, '/');
       v_fecha_construida:='15/'||v_array_fecha[array_length(v_array_fecha, 1)-1]||'/'||v_array_fecha[array_length(v_array_fecha, 1)];
       return v_fecha_construida;
     end if;	
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.completar_fecha(text)
  OWNER TO tedede_php;

/*select comun.completar_fecha(pla_f_nac_o)
from encu.plana_s1_p p inner join encu.plana_tem_ t on p.pla_enc= t.pla_enc where not(comun.es_fecha(pla_f_nac_o)) and comun.es_fecha_parcial(pla_f_nac_o);*/
