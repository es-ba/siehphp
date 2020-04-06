--pla_hog_aleatorio
--pla_mie_aleatorio
ALTER TABLE encu.plana_s1_ ADD COLUMN pla_hog_aleatorio numeric;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_mie_aleatorio numeric;
ALTER TABLE his.plana_s1_  ADD COLUMN pla_hog_aleatorio numeric;
ALTER TABLE his.plana_i1_  ADD COLUMN pla_mie_aleatorio numeric;

ALTER TABLE encu.plana_s1_ ADD CONSTRAINT hog_aleatorio_uk UNIQUE(pla_hog_aleatorio);
ALTER TABLE encu.plana_i1_ ADD CONSTRAINT mie_aleatorio_uk UNIQUE(pla_mie_aleatorio);

----
--DROP FUNCTION comun.obtener_numero_aleatorio(integer, integer); 
CREATE OR REPLACE FUNCTION comun.obtener_numero_aleatorio_hog_mie(limite_inf  integer, limite_sup integer, divisor integer) 
RETURNS numeric AS 
$BODY$
    select (trunc(random()*(limite_sup-limite_inf) + limite_inf)/divisor)::numeric;
$BODY$    
LANGUAGE 'sql' VOLATILE;
ALTER FUNCTION  comun.obtener_numero_aleatorio_hog_mie(integer, integer, integer)
  OWNER TO tedede_php;


----
CREATE OR REPLACE FUNCTION encu.calcular_idhog_idmie_aleatorio_trg()
  RETURNS trigger AS
$BODY$
DECLARE
v_limite_superior integer;
v_aleatorio numeric;
v_condicion text;
v_sentencia text;
v_campo text;
v_existe   integer;
v_divisor  integer;
BEGIN
  CASE TG_TABLE_NAME 
    WHEN 'plana_s1_' THEN
        v_limite_superior:=999999;
        v_divisor:=1000000;
        v_campo:='pla_hog_aleatorio';
    WHEN 'plana_i1_' THEN
        v_limite_superior:=9999999;
        v_divisor:=10000000;
        v_campo:='pla_mie_aleatorio';
    ELSE
        raise exception 'Tabla no considerada: %', TG_TABLE_NAME;
  END CASE;
  LOOP 
    v_aleatorio:=comun.obtener_numero_aleatorio_hog_mie(0, v_limite_superior, v_divisor);
    v_condicion:='  where '||v_campo||'= ';
    v_sentencia:='select  1  from '||TG_TABLE_NAME||v_condicion||v_aleatorio;
    execute v_sentencia into v_existe;
    EXIT WHEN v_existe is distinct from 1;
  END LOOP;
  IF  TG_TABLE_NAME= 'plana_s1_'  THEN
    new.pla_hog_aleatorio:=v_aleatorio;
  ELSE
    new.pla_mie_aleatorio:=v_aleatorio;
  END IF;
  raise notice 'Valores: %, %, % ', new.pla_enc, new.pla_hog,v_aleatorio;
  return new;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.calcular_idhog_idmie_aleatorio_trg()
  OWNER TO tedede_php;
----
CREATE TRIGGER calcular_idhog_aleatorio_trg
  BEFORE INSERT OR UPDATE
  ON encu.plana_s1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calcular_idhog_idmie_aleatorio_trg();  
----
CREATE TRIGGER calcular_idmie_aleatorio_trg
  BEFORE INSERT OR UPDATE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calcular_idhog_idmie_aleatorio_trg();  
  
