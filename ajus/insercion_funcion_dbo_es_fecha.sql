CREATE OR REPLACE FUNCTION dbo.es_fecha(valor text)
  RETURNS integer AS
$BODY$

DECLARE v_fecha date;
DECLARE bisiesto boolean;
DECLARE v_fechas_array integer[];
DECLARE v_anio_extraido integer;
DECLARE v_mes_extraido integer;
DECLARE v_dia_extraido integer;
DECLARE v_anio_actual integer;
DECLARE dias_mes integer[12]:= array[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
BEGIN
  if valor is null then
    return 0;
  end if;
  
  v_fecha:=to_date(valor,'DD/MM/YYYY');

  v_anio_actual :=  dbo.anio();

  v_fechas_array := regexp_split_to_array(valor,'/');
  
  v_anio_extraido := v_fechas_array[3];
  v_mes_extraido := v_fechas_array[2];
  v_dia_extraido := v_fechas_array[1];

  if v_anio_extraido is null then
    v_anio_extraido := v_anio_actual;
  end if;
  
  if v_anio_extraido%4=0 then
	if v_anio_extraido%100=0 then
		if v_anio_extraido%400=0 then
			bisiesto = true;
		else
			bisiesto = false;
		end if;
	else
		bisiesto = true;
	end if;
  else
	bisiesto = false;
  end if;
  if v_anio_extraido is null or v_mes_extraido is null or v_dia_extraido is null then
	return 0;
  end if;
  if v_anio_extraido < 1890 or v_anio_extraido > v_anio_actual then
	return 0;
  end if;
  if v_mes_extraido <= 0 or v_mes_extraido > 12 or v_dia_extraido <=0 then
	return 0;
  end if;
  if v_mes_extraido <> 2 or bisiesto = false then
	if v_dia_extraido>dias_mes[v_mes_extraido] then
		return 0;
	end if;
  else
	if v_dia_extraido>dias_mes[2]+1 then
		return 0;
	end if;
  end if;

  return 1;
  
EXCEPTION
  WHEN invalid_text_representation THEN
    return 0;
  WHEN invalid_datetime_format THEN
    return 0;
  WHEN datetime_field_overflow THEN
    return 0; 
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;