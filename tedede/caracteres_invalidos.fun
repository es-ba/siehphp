##FUN
caracteres_invalidos
##ESQ
comun
##PARA
revisar 
##DETALLE
##PROVISORIO

CREATE OR REPLACE FUNCTION comun.caracteres_invalidos(p_cadena text, p_version text DEFAULT NULL::text, p_forma text DEFAULT NULL::text)
  RETURNS text AS
$BODY$
DECLARE
  caracteres_invalidos text := '';
  caracteres_permitidos_identificador text:='a-z0-9_';
  caracteres_permitidos_codigo text:='A-Za-z0-9_';
  caracteres_permitidos_extendido text:='-'||caracteres_permitidos_codigo||' ,/*().+$@!#:';
  caracteres_permitidos_castellano text:=caracteres_permitidos_extendido||'ÁÉÍÓÚÜÑñáéíóúüçÇ¿¡';
  caracteres_permitidos_formula text:=caracteres_permitidos_extendido||'<>=';
  caracteres_permitidos_json text:=caracteres_permitidos_formula||'{}"\[\]\\|&^~'';';
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
  caracteres_permitidos text;
  expresion_regular text;
  expresion_regular_identificador text;
  expresion_regular_codigo text;
  expresion_regular_extendido text;
  expresion_regular_castellano text;
  expresion_regular_formula text;
  expresion_regular_json text;
  expresion_regular_castellano_formula text;
  caracter_ascii int;
  largo int;
BEGIN
/*
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
      union select 'sdfasd☺>Ñ?¿asdfas', null, 'esc', 18
      union select 'Nsdfasd☺>Ñ?¿asdfas', 'identificador', null, 0
      union select 'sdfas', 'identificador', 'esc', 0
    ) casos order by caso;
*/
if (p_version = 'cualquiera') then
   return caracteres_invalidos;
end if;
if (p_version ISNULL) then
   expresion_regular_identificador:='^['||caracteres_permitidos_identificador||']*$';
   expresion_regular_codigo:='^['||caracteres_permitidos_codigo||']*$';
   expresion_regular_extendido:='^['||caracteres_permitidos_extendido||']*$';
   expresion_regular_castellano:='^['||caracteres_permitidos_castellano||']*$';
   expresion_regular_formula:='^['||caracteres_permitidos_formula||']*$';
   expresion_regular_json:='^['||caracteres_permitidos_json||']*$';
   expresion_regular_castellano_formula:='^['||caracteres_permitidos_castellano_formula||']*$';
/*   caracteres_permitidos :=caracteres_permitidos_castellano_formula;
   expresion_regular:='^['||caracteres_permitidos||']*$';*/
   largo := char_length(p_cadena);
   for i in 1..largo LOOP
       if ((substr(p_cadena,i,1) !~ expresion_regular_codigo) and (substr(p_cadena,i,1) !~ expresion_regular_extendido) and (substr(p_cadena,i,1) !~ expresion_regular_castellano) and (substr(p_cadena,i,1) !~ expresion_regular_formula) and (substr(p_cadena,i,1) !~ expresion_regular_castellano_formula)) then
/*       if (substr(p_cadena,i,1) !~ expresion_regular) then*/
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
       when 'identificador' then caracteres_permitidos := caracteres_permitidos_identificador;
       when 'codigo' then caracteres_permitidos := caracteres_permitidos_codigo;
       when 'extendido' then caracteres_permitidos :=caracteres_permitidos_extendido;
       when 'castellano' then caracteres_permitidos := caracteres_permitidos_castellano;
       when 'formula' then caracteres_permitidos := caracteres_permitidos_formula;
       when 'json' then caracteres_permitidos := caracteres_permitidos_json;
       when 'castellano y formula' then caracteres_permitidos := caracteres_permitidos_castellano_formula;
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
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.caracteres_invalidos(text, text, text)
  OWNER TO tedede_php;