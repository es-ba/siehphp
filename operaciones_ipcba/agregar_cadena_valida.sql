set search_path = cvp,comun,public;

-- Function: comun.caracteres_invalidos(text, text, text)

-- DROP FUNCTION comun.caracteres_invalidos(text, text, text);

CREATE OR REPLACE FUNCTION comun.caracteres_invalidos(p_cadena text, p_version text DEFAULT NULL::text, p_forma text DEFAULT NULL::text)
  RETURNS text AS
$BODY$DECLARE
  caracteres_invalidos text := '';
  caracteres_permitidos_codigo text:='A-Za-z0-9_';
  caracteres_permitidos_extendido text:='-'||caracteres_permitidos_codigo||' ,/*().+$@!#:%';
  caracteres_permitidos_castellano text:=caracteres_permitidos_extendido||'ÁÉÍÓÚÜÑñáéíóúüçÇ¿¡?!';
  caracteres_permitidos_formula text:=caracteres_permitidos_extendido||'<>=';
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
  caracteres_permitidos_json text:=caracteres_permitidos_formula||'{}"\[\]\\|&^~'';';
  caracteres_permitidos_amplio text:=caracteres_permitidos_castellano_formula||'{}"\[\]\\|&^~'';º';
  caracteres_permitidos text;
  expresion_regular text;
  expresion_regular_codigo text;
  expresion_regular_extendido text;
  expresion_regular_castellano text;
  expresion_regular_formula text;
  expresion_regular_castellano_formula text;
  expresion_regular_json text;
  expresion_regular_amplio text;
  caracter_ascii int;
  largo int;
BEGIN/*
-- Pruebas:
select version, entrada, comun.caracteres_invalidos(entrada,version,forma)
     from (
  select '+?af'::text as entrada, 'codigo'::text as version, null as forma, 1 as caso
  union select '+?af', 'codigo', 'esc', 2 
  union select '+af', 'codigo', null, 3
  union select '+af', 'codigo', 'esc', 4 
  union select '☻☺defg', 'codigo', null, 5 
  union select '☻☺defg', 'codigo', 'esc', 6 
  union select 'defg', 'codigo', null, 7   
  union select 'defg', 'codigo', 'esc', 8 
  union select 'asdjfhasd', 'cualquiera', null, 9 
  union select 'asdjfhasd', 'cualquiera', 'esc', 10 
  union select 'Áñ= u', 'castellano', null, 11 
  union select 'Áñ= u', 'castellano', 'esc', 12
  union select 'á><=¿', 'formula', null, 13 
  union select 'á><=¿', 'formula', 'esc', 14
  union select 'úÑ=☻', 'castellano y formula', null, 15
  union select 'úÑ=☻', 'castellano y formula', null, 16
  union select 'sdfasd☺>Ñ?¿asdfas', null, null, 17
  union select 'sdfasd☺>Ñ?¿asdfas', null, 'esc', 18) casos order by caso;
*/
if (p_version = 'cualquiera') then
   return caracteres_invalidos;
end if;
if (p_version ISNULL) then
   expresion_regular_codigo:='^['||caracteres_permitidos_codigo||']*$';
   expresion_regular_extendido:='^['||caracteres_permitidos_extendido||']*$';
   expresion_regular_castellano:='^['||caracteres_permitidos_castellano||']*$';
   expresion_regular_formula:='^['||caracteres_permitidos_formula||']*$';
   expresion_regular_castellano_formula:='^['||caracteres_permitidos_castellano_formula||']*$';
   expresion_regular_json:='^['||caracteres_permitidos_json||']*$';
   expresion_regular_amplio:='^['||caracteres_permitidos_amplio||']*$';
   largo := char_length(p_cadena);
   for i in 1..largo LOOP
       if ((substr(p_cadena,i,1) !~ expresion_regular_codigo) and (substr(p_cadena,i,1) !~ expresion_regular_extendido) and (substr(p_cadena,i,1) !~ expresion_regular_castellano) and (substr(p_cadena,i,1) !~ expresion_regular_formula) and (substr(p_cadena,i,1) !~ expresion_regular_castellano_formula)) then
          if (p_forma = 'esc') then 
             caracteres_invalidos := caracteres_invalidos||chr(92)||chr(92)||'u'||to_hex(ascii(substr(p_cadena,i,1)));
          else
             caracteres_invalidos := caracteres_invalidos||substr(p_cadena,i,1);
          end if;
       end if;
   end loop;
   return caracteres_invalidos;
else
    case p_version
       when 'codigo' then caracteres_permitidos := caracteres_permitidos_codigo;
       when 'extendido' then caracteres_permitidos :=caracteres_permitidos_extendido;
       when 'castellano' then caracteres_permitidos := caracteres_permitidos_castellano;
       when 'formula' then caracteres_permitidos := caracteres_permitidos_formula;
       when 'castellano y formula' then caracteres_permitidos := caracteres_permitidos_castellano_formula;
       when 'json' then caracteres_permitidos := caracteres_permitidos_json;
       when 'amplio' then caracteres_permitidos := caracteres_permitidos_amplio;
       else raise exception 'Parametro invalido para "version" "%"',"p_version";
    end case;
    expresion_regular:='^['||caracteres_permitidos||']*$';
    largo := char_length(p_cadena);
    for i in 1..largo LOOP
        if (substr(p_cadena,i,1) !~ expresion_regular) then
           if (p_forma = 'esc') then 
              caracteres_invalidos := caracteres_invalidos||chr(92)||chr(92)||'u'||to_hex(ascii(substr(p_cadena,i,1)));
           else
              caracteres_invalidos := caracteres_invalidos||substr(p_cadena,i,1);
           end if;
        end if;
    end loop;
    return caracteres_invalidos;
end if;
end;$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.caracteres_invalidos(text, text, text)
  OWNER TO cvpowner;

-- Function: comun.cadena_valida(text, text)

-- DROP FUNCTION comun.cadena_valida(text, text);

CREATE OR REPLACE FUNCTION comun.cadena_valida(p_cadena text, p_version text)
  RETURNS boolean AS
$BODY$
DECLARE
  /*
  select comun.cadena_valida(entrada, version)=resultado as ok, entrada, version, resultado as esperado, comun.cadena_valida(entrada, version) as recibido
    from (
	  select 'Mauro01' as entrada, 'codigo' as version, true as resultado
	  union select '/xñz1', 'codigo', false
	  union select '/xñz1', 'castellano', true
	  union select '/xñz1', 'formula', false
	  union select '{"pepe":"\\esto;",[]}', 'formula', false
	  union select '{"pepe":"\\esto;",[]}', 'json', true
	  union select 'a<99-', 'formula', true
	  union select 'a<99-', 'codigo', false) x
    where comun.cadena_valida(entrada, version) is distinct from resultado 
  
  */
  caracteres_permitidos_codigo text:='A-Za-z0-9_';
  caracteres_permitidos_extendido text:='-'||caracteres_permitidos_codigo||' ,/*+().$@!#:%';
  caracteres_permitidos_castellano text:=caracteres_permitidos_extendido||'ÁÉÍÓÚÜÑñáéíóúüçÇ¿¡?!';
  caracteres_permitidos_formula text:=caracteres_permitidos_extendido||'<>=';
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
  caracteres_permitidos_json text:=caracteres_permitidos_formula||'{}"\[\]\\|&^~'';';
  caracteres_permitidos_amplio text:=caracteres_permitidos_castellano_formula||'{}"\[\]\\|&^~'';º';
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
    when 'codigo' then caracteres_permitidos_codigo
    when 'extendido' then caracteres_permitidos_extendido
    when 'castellano' then caracteres_permitidos_castellano
    when 'formula' then caracteres_permitidos_formula
    when 'json' then caracteres_permitidos_json
    when 'castellano y formula' then caracteres_permitidos_castellano_formula
    when 'amplio' then caracteres_permitidos_amplio
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
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.cadena_valida(text, text)
  OWNER TO cvpowner;

drop table if exists tmp_relatr;

create table tmp_relatr as select caracteres_invalidos(valor,'amplio'), *
  from cvp.relatr
  where periodo in ('a2013m12','a2014m01')
    and valor is not null and length(valor)>0
    and length(caracteres_invalidos(valor,'amplio'))>0;

alter table cvp.relatr disable trigger relatr_act_datos_trg;
alter table cvp.relatr disable trigger relatr_abi_trg;
alter table cvp.relatr disable trigger relatr_actualizar_valor_trg;
alter table cvp.relatr disable trigger relatr_normaliza_precio_trg;
UPDATE cvp.relatr set valor=translate(replace(replace(replace(valor,'…','...'),'BLACK ¬ DECKER','BLACK & DECKER'),'S`RITE','SPRITE'),'ÀÈÌÒÙàèìòù`´','ÁÉÍÓÚáéíóú''''')
  where periodo in ('a2013m12','a2014m01')
    and valor is not null and length(valor)>0
    and valor<>translate(replace(replace(replace(valor,'…','...'),'BLACK ¬ DECKER','BLACK & DECKER'),'S`RITE','SPRITE'),'ÀÈÌÒÙàèìòù`´','ÁÉÍÓÚáéíóú''''');
    
alter table cvp.relatr enable trigger relatr_normaliza_precio_trg;
alter table cvp.relatr enable trigger relatr_act_datos_trg;
alter table cvp.relatr enable trigger relatr_actualizar_valor_trg;
alter table cvp.relatr enable trigger relatr_abi_trg;

alter table cvp.relatr add CONSTRAINT "texto invalido en valor de tabla relatr" CHECK (periodo<'a2013m12' or comun.cadena_valida(valor, 'amplio'));

select caracteres_invalidos(valor,'amplio'), *
  from cvp.relatr
  where not (periodo<'a2013m12' or comun.cadena_valida(valor, 'amplio'));



/*
select *
  from cvp.relatr 
  where producto='P0122214'
    and visita=1
    and informante=2068	
    and atributo=13
*/