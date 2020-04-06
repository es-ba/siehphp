-- Function: comun.justificar(integer,integer)

-- DROP FUNCTION comun.justificar(integer, integer);

CREATE OR REPLACE FUNCTION comun.justificar(pvalor integer, plong integer)
  RETURNS text AS
$BODY$  
    select case when length(pvalor::text)=plong then pvalor::text else lpad(pvalor::text, plong , '0') end; 
$BODY$
  LANGUAGE sql IMMUTABLE;
  
ALTER FUNCTION comun.justificar(integer, integer)
  OWNER TO tedede_php;

-- Function: comun.validar_codrama(text,integer,integer)

 --DROP FUNCTION comun.validar_codrama(text,integer, integer);

CREATE OR REPLACE FUNCTION comun.validar_codrama(pvalor text, pinicial integer, plong integer, pvariable text)
  RETURNS text AS
$BODY$  
    select case when (pvalor like '%X%' or pvalor like '%x%') then ''
                when pvalor is null then ''    
                else case when count(*) > 0 then '' 
                          else 'No existe el código de '||pvariable||'' 
                     end 
           end
    from encu.rama
    where substr(comun.justificar(ram_ram,4),pinicial,plong)=pvalor;
$BODY$
  LANGUAGE sql IMMUTABLE;

ALTER FUNCTION comun.validar_codrama(text, integer, integer, text)
  OWNER TO tedede_php;

-- Function: comun.validar_codocupacion(text,integer,integer)

 --DROP FUNCTION comun.validar_codocupacion(text,integer, integer);
  
CREATE OR REPLACE FUNCTION comun.validar_codocupacion(pvalor text, pinicial integer, plong integer, pvariable text)
  RETURNS text AS
$BODY$  
    select case when (pvalor like '%X%' or pvalor like '%x%') then '' 
                when pvalor is null then ''  
                else case when count(*) > 0 then '' 
                          else 'No existe el código de '||pvariable||'' 
                     end 
           end
    from encu.ocupacion
    where substr(comun.justificar(ocu_ocu,5),pinicial,plong)=pvalor;
$BODY$
  LANGUAGE sql IMMUTABLE;
  
ALTER FUNCTION comun.validar_codocupacion(text, integer, integer, text)
  OWNER TO tedede_php;

-- Function: encu.validacion_rama_ocupacion_trg()

-- DROP FUNCTION encu.validacion_rama_ocupacion_trg();

CREATE OR REPLACE FUNCTION encu.validacion_rama_ocupacion_trg()
  RETURNS trigger AS
$BODY$
DECLARE
v_nota text;
v_texto text;
BEGIN
select
case when new.pla_rama1 is distinct from old.pla_rama1 then 
        comun.validar_codrama(new.pla_rama1, 1,2, 'rama1')
     when new.pla_rama2 is distinct from old.pla_rama2 then 
        comun.validar_codrama(new.pla_rama2,3,2,'rama2')||comun.validar_codrama(new.pla_rama1||new.pla_rama2,1,4,'rama') 
     when new.pla_ocu1  is distinct from old.pla_ocu1  then 
        comun.validar_codocupacion(new.pla_ocu1, 1,1,'ocu1')
     when new.pla_ocu2  is distinct from old.pla_ocu2  then
        comun.validar_codocupacion(new.pla_ocu2, 1,1,'ocu2')||     
        comun.validar_codocupacion(new.pla_ocu1||new.pla_ocu2, 1,2,'ocu2-hasta 2 dig')
     when new.pla_ocu3  is distinct from old.pla_ocu3  then 
        comun.validar_codocupacion(new.pla_ocu3, 1,1,'ocu3')||     
        comun.validar_codocupacion(new.pla_ocu1||new.pla_ocu2||new.pla_ocu3, 1,3,'ocu3-hasta 3 dig')
     when new.pla_ocu4  is distinct from old.pla_ocu4  then 
        comun.validar_codocupacion(new.pla_ocu4, 1,1,'ocu4')||     
        comun.validar_codocupacion(new.pla_ocu1||new.pla_ocu2||new.pla_ocu3||new.pla_ocu4, 1,4, 'ocu4-hasta 4 dig')
     when new.pla_ocu5  is distinct from old.pla_ocu5  then 
        comun.validar_codocupacion(new.pla_ocu5, 1,1,'ocu5')||     
        comun.validar_codocupacion(new.pla_ocu1||new.pla_ocu2||new.pla_ocu3||new.pla_ocu4||new.pla_ocu5, 1,5, 'ocupacion')    
     else ''
end into v_nota;

if (new.pla_ocu1 is distinct from old.pla_ocu1 or new.pla_ocu2  is distinct from old.pla_ocu2 or new.pla_ocu3 is distinct from old.pla_ocu3  or new.pla_ocu4 is distinct from old.pla_ocu4 or new.pla_ocu5 is distinct from old.pla_ocu5) then  
    if length(new.pla_ocu1||new.pla_ocu2||new.pla_ocu3||new.pla_ocu4||new.pla_ocu5)=5 then
        v_texto:=comun.validar_codocupacion(new.pla_ocu1||new.pla_ocu2||new.pla_ocu3||new.pla_ocu4||new.pla_ocu5, 1,5, 'total ocupacion');         
        if v_texto <> '' then
            v_nota:=v_nota||v_texto;   
        end if;
    end if;        
end if;    
if (new.pla_rama1 is distinct from old.pla_rama1 or new.pla_rama2 is distinct from old.pla_rama2) then  
    if length(new.pla_rama1||new.pla_rama2)=4 then
        v_texto:= comun.validar_codrama(new.pla_rama1||new.pla_rama2,1,4,'total rama') ;         
        if v_texto <> '' then
            v_nota:=v_nota||v_texto;   
        end if;
    end if;        
end if;  
  
if v_nota <> '' then
    raise ' %', v_nota;
end if;    
return new;

END
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION encu.validacion_rama_ocupacion_trg()
  OWNER TO tedede_php;  
  
-- Trigger: validacion_rama_ocupacion_i1_trg on encu.plana_i1_

 DROP TRIGGER validacion_rama_ocupacion_i1_trg ON encu.plana_i1_;

CREATE TRIGGER validacion_rama_ocupacion_i1_trg
  BEFORE UPDATE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.validacion_rama_ocupacion_trg(); 

-----------

create or replace function comun.digitos(p_valor text, p_digitos integer default 1) returns text
  language sql CALLED ON NULL INPUT
as $$
  select rpad(coalesce(p_valor,''),p_digitos,' ');
$$;

create or replace function encu.reemplazar_espacios_por_x_o_blanco_total(p_texto text) returns text
  language sql 
as $$
  -- select case when trim(p_texto)='' then null else replace(p_texto,' ', 'X') end
  select case when comun.es_numero(replace(rtrim(p_texto),' ','X')) then p_texto else null end;
$$;

  
 
-- Function: encu.unir_rama_ocupacion_trg()

-- DROP FUNCTION encu.unir_rama_ocupacion_trg();

CREATE OR REPLACE FUNCTION encu.unir_rama_ocupacion_trg()
  RETURNS trigger AS
$BODY$
BEGIN
  if (new.pla_ocu1 is distinct from old.pla_ocu1 or new.pla_ocu2  is distinct from old.pla_ocu2 or new.pla_ocu3 is distinct from old.pla_ocu3  or new.pla_ocu4 is distinct from old.pla_ocu4 or new.pla_ocu5 is distinct from old.pla_ocu5) then  
    if length(new.pla_ocu1||new.pla_ocu2||new.pla_ocu3||new.pla_ocu4||new.pla_ocu5)=5 then 
         new.pla_t41_cod2:=reemplazar_espacios_por_x_o_blanco_total(digitos(new.pla_ocu1)||digitos(new.pla_ocu2)||digitos(new.pla_ocu3)||digitos(new.pla_ocu4)||digitos(new.pla_ocu5));
    else
      new.pla_t41_cod2:=null;  
    end if; 
  end if;   

  if (new.pla_rama1 is distinct from old.pla_rama1 or new.pla_rama2 is distinct from old.pla_rama2) then  
    if length(new.pla_rama1||new.pla_rama2)=4 then 
         new.pla_t37_cod2:=reemplazar_espacios_por_x_o_blanco_total(digitos(new.pla_rama1,2)||digitos(new.pla_rama2,2));
    else
      new.pla_t37_cod2:=null;  
    end if; 
  end if;   
 
  return new;
END
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION encu.unir_rama_ocupacion_trg()
  OWNER TO tedede_php;


/*
CREATE TRIGGER xunir_rama_ocupacion_i1_trg
  BEFORE UPDATE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.unir_rama_ocupacion_trg();   
*/