##FUN
cadena_valida
##ESQ
comun
##PARA
revisar 
##DETALLE
##PROVISORIO

CREATE OR REPLACE FUNCTION comun.cadena_valida(p_cadena text, p_version text)
  RETURNS boolean AS
$BODY$
DECLARE
  /*
  select comun.cadena_valida(entrada, version)=resultado as ok, entrada, version, resultado as esperado, comun.cadena_valida(entrada, version) as recibido
    from (
      select 'Mauro01' as entrada, 'codigo' as version, true as resultado
      union select '/xñz1', 'codigo', false
      union select 'base1', 'identificador', true
      union select 'M1_re', 'identificador', false
      union select '/xñz1', 'castellano', true
      union select '/xñz1', 'formula', false
      union select '{"pepe":"\\esto;",[]}', 'formula', false
      union select '{"pepe":"\\esto;",[]}', 'json', true
      union select 'a<99-', 'formula', true
      union select 'a<99-', 'codigo', false) x
    where comun.cadena_valida(entrada, version) is distinct from resultado 
  
  */
  caracteres_permitidos_identificador text:='a-z0-9_';
  caracteres_permitidos_codigo text:='A-Za-z0-9_';
  caracteres_permitidos_extendido text:='-'||caracteres_permitidos_codigo||' ,/*+().$@!#:';
  caracteres_permitidos_castellano text:=caracteres_permitidos_extendido||'ÁÉÍÓÚÜÑñáéíóúüçÇ¿¡';
  caracteres_permitidos_formula text:=caracteres_permitidos_extendido||'<>=';
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
  caracteres_permitidos_json text:=caracteres_permitidos_formula||'{}"\[\]\\|&^~'';';
  caracteres_permitidos text;
  explicar boolean:=false;
  largo integer;
  expresion_regular text;
  v_juego_caracteres text:=p_version;
BEGIN
  if p_version like 'explicar%' then
    explicar:=true;
    v_juego_caracteres:=substr(p_version,length('explicar ')+1);
  end if;
  if v_juego_caracteres='cualquiera' then
    return true;
  end if;
  caracteres_permitidos:=case v_juego_caracteres
    when 'identificador' then caracteres_permitidos_identificador
    when 'codigo' then caracteres_permitidos_codigo
    when 'extendido' then caracteres_permitidos_extendido
    when 'castellano' then caracteres_permitidos_castellano
    when 'formula' then caracteres_permitidos_formula
    when 'json' then caracteres_permitidos_json
    when 'castellano y formula' then caracteres_permitidos_castellano_formula
  end;
  if caracteres_permitidos is null then
    raise exception 'Parametro invalido para p_version "%"',p_version;
  end if;
  expresion_regular:='^['||caracteres_permitidos||']*$';
  if explicar then
    largo := char_length(p_cadena);
    for i IN 1..largo LOOP
      if not (substr(p_cadena,i,1) ~ expresion_regular) THEN
        raise exception 'El caracter % es invalido (%)', substr(p_cadena,i,1), ascii(substr(p_cadena,i,1));
      END IF;
    END LOOP;
  end if;
  return p_cadena ~ expresion_regular;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.cadena_valida(text, text)
  OWNER TO tedede_php;