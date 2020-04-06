##FUN
formato_variable
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
DROP FUNCTION if exists encu.formato_variable(text,text);
/*otra*/
CREATE OR REPLACE FUNCTION encu.formato_variable(p_var text, p_baspro text)
  RETURNS text AS
$BODY$
DECLARE
   v_maximo_largo integer;
   v_sentencia text;
   v_tabla text;
   v_columna text;
   v_tipo text;
   v_letra text;
   v_cantdec integer;
   v_formato text;
BEGIN
    select encu.tabla_variable(p_var) into v_tabla;
    v_columna:='pla_'||p_var;
    v_sentencia:= 'select length(comun.maxlen(pla_'||p_var||')::text) from encu.'||v_tabla||' ;'; 
    --raise notice 'sentencia %', v_sentencia;
    select data_type into v_tipo from information_schema.columns where table_schema = 'encu' and table_name = v_tabla and column_name = v_columna;
    case v_tipo
         when 'text' then 
              v_letra:='A';
              v_sentencia:= 'select length(comun.maxlen(pla_'||p_var||')::text)+10 from encu.'||v_tabla; 
         when 'character varying' then
              v_letra:='A';
              v_sentencia:= 'select length(comun.maxlen(pla_'||p_var||')::text)+10 from encu.'||v_tabla; 
         when 'timestamp without time zone' then 
              v_letra:='A';
         when 'bigint' then 
              v_letra:='F';
         when 'integer' then
              v_letra:='F';
         when 'numeric' then
              v_letra:='F';
         else v_letra:='A';
    end case;
    IF v_sentencia IS NULL THEN
      RAISE 'No se pudo construir la variable %', p_var;
    END IF;
    EXECUTE v_sentencia INTO v_maximo_largo;   
    v_formato:=v_letra||coalesce(v_maximo_largo,'1')::text;
    if v_letra ='F' then
       v_formato:=v_formato||'.';
       select basprovar_cantdecimales into v_cantdec from encu.baspro_var where basprovar_ope = dbo.ope_actual() and basprovar_baspro = p_baspro and basprovar_var = p_var;
       if v_cantdec > 0 then 
          v_formato:=v_formato||v_cantdec::text;
       else
          v_formato:=v_formato||'0';
       end if;
    end if;
    RETURN v_formato;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
ALTER FUNCTION encu.formato_variable(text, text)
  OWNER TO tedede_php;
