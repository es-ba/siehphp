--1. agregar mie_bu a plana_i1_ y su his
ALTER TABLE encu.plana_i1_
  DROP COLUMN IF EXISTS pla_mie_bu;
/*OTRA*/
ALTER TABLE encu.plana_i1_ 
  ADD COLUMN pla_mie_bu integer;
/*OTRA*/
ALTER TABLE his.plana_i1_ 
  DROP COLUMN IF EXISTS pla_mie_bu;
/*OTRA*/
ALTER TABLE his.plana_i1_ 
  ADD COLUMN pla_mie_bu integer;
/*OTRA*/
--2. funciones y triggers para calculo de mie_bu
--DROP FUNCTION IF EXISTS encu.recalcular_mie_bu(integer);
CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu(p_enc integer)
  RETURNS void AS
  $BODY$
      update plana_i1_ i
          set pla_mie_bu = x.mie_bu
          from 
            (select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_p4, rank() OVER (PARTITION BY s.pla_enc, s.pla_hog ORDER BY s.pla_p4 = 1 DESC, s.pla_mie) AS mie_bu
              from encu.plana_s1_p s
              inner join encu.plana_i1_ i on i.pla_enc=s.pla_enc and i.pla_hog=s.pla_hog and i.pla_mie=s.pla_mie where s.pla_enc = p_enc) x
          where i.pla_enc = x.pla_enc and i.pla_hog = x.pla_hog and i.pla_mie = x.pla_mie
  $BODY$
  LANGUAGE sql;
/*OTRA*/
ALTER FUNCTION encu.recalcular_mie_bu(integer)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu_s1_p_trg()
  RETURNS trigger AS
$BODY$
    DECLARE
     v_val text;
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          select recalcular_mie_bu(old.pla_enc) into v_val;
          select recalcular_mie_bu(new.pla_enc) into v_val;
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie or new.pla_p4 is distinct from old.pla_p4 then
          select recalcular_mie_bu(new.pla_enc) into v_val;
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          select recalcular_mie_bu(new.pla_enc) into v_val;
          RETURN new;
    elsif TG_OP='DELETE' then
          select recalcular_mie_bu(old.pla_enc) into v_val;
          RETURN old;
    end if;
    END
  $BODY$
  LANGUAGE plpgsql;
/*OTRA*/
ALTER FUNCTION encu.recalcular_mie_bu_s1_p_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu_i1_trg()
  RETURNS trigger AS
  $BODY$
    DECLARE
     v_val text;
    BEGIN
    if TG_OP='UPDATE' then
        if new.pla_enc is distinct from old.pla_enc then
          select  recalcular_mie_bu_i1_trg(old.pla_enc) into v_val;
          select  recalcular_mie_bu(new.pla_enc) into v_val;
        elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie then
          select  recalcular_mie_bu(new.pla_enc) into v_val;
        end if;
        RETURN new;
    elsif TG_OP='INSERT' then
        select   recalcular_mie_bu(new.pla_enc) into v_val;
        RETURN new;
    elsif TG_OP='DELETE' then
        select   recalcular_mie_bu(old.pla_enc) into v_val;
        RETURN old;
    end if;
    END
  $BODY$
  LANGUAGE plpgsql;
/*OTRA*/
ALTER FUNCTION encu.recalcular_mie_bu_i1_trg()
  OWNER TO tedede_php; 
/*OTRA*/
DROP TRIGGER IF EXISTS recalcular_mie_bu_s1_p_trg  ON encu.plana_s1_p;
/*OTRA*/
CREATE TRIGGER recalcular_mie_bu_s1_p_trg
  AFTER UPDATE OR INSERT OR DELETE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.recalcular_mie_bu_s1_p_trg();
/*OTRA*/
-- Trigger: recalcular_mie_bu_i1_trg on encu.plana_i1_
DROP TRIGGER IF EXISTS recalcular_mie_bu_i1_trg ON encu.plana_i1_;
/*OTRA*/
CREATE TRIGGER recalcular_mie_bu_i1_trg
  AFTER UPDATE OR INSERT OR DELETE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.recalcular_mie_bu_i1_trg();
-- FUNCION dbo.mie_bu, se supone que ya está, no agrego el codigo
/*OTRA*/
--3 para actualizar mie_bu inicialmente 
select encu.recalcular_mie_bu(x.encuesta) from 
(select distinct(pla_enc) as encuesta from encu.plana_s1_p) x;
