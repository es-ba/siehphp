CREATE OR REPLACE FUNCTION dbo.tem_estado(v_fin_campo varchar(255),v_estado_procesamiento varchar(255),v_devolucion_campo varchar(255),v_devolucion_tematico varchar(255),v_verificado integer,v_var varchar(255), v_bolsa integer)
 RETURNS varchar(255) AS
 $BODY$
DECLARE
  v_estado_procesamiento_int integer;
  v_estado varchar(255);
  v_estado_int integer;
BEGIN
  v_estado='0';
   if v_verificado=2 then
      v_estado:='98';
  end if;
  if v_estado='0' and comun.es_numero(v_estado_procesamiento) and (v_estado_procesamiento is not null) then
      v_estado_procesamiento_int:=v_estado_procesamiento::integer;
      if v_var='estado_procesamiento' and v_fin_campo is null and v_bolsa is null then
          raise exception 'No se puede cambiar estado de procesamiento si no tiene fin campo';
      end if;
      if (v_estado_procesamiento_int<70) or (v_estado_procesamiento_int>90) or (v_estado_procesamiento_int in (80,84)) then
          raise exception 'El campo estado_procesamiento se encuentra fuera de rango o tiene un valor no asignado a procesamiento';
      end if;
      if v_var='devolucion_campo' and v_estado_procesamiento_int<>78 then
          raise exception 'Campo solo puede contestar con estado_procesamiento=78';
      end if;
      if v_var='devolucion_tematico' and v_estado_procesamiento_int<>82 then
          raise exception 'Tematica solo puede contestar con estado_procesamiento=82';
      end if;
      if (v_devolucion_campo is not null) or (trim(v_devolucion_campo) <> '') or (v_devolucion_campo <> '0') then
          v_estado:='80';
      end if;
      if (v_devolucion_tematico is not null) or (trim(v_devolucion_tematico) <> '') or (v_devolucion_tematico <> '0') then
          v_estado:='84';
      end if;     
      v_estado_int:=v_estado::integer;
      if v_estado_procesamiento_int >v_estado_int then
          v_estado:=v_estado_procesamiento;
      end if;
  end if;
  if v_estado='0' and v_fin_campo is not null then
      v_estado='70';
  end if;
  if v_estado='0' and v_fin_campo is not null then
      v_estado='70';
  end if;
  return v_estado;
END;
 $BODY$
LANGUAGE plpgsql