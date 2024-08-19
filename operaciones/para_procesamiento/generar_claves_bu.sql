set search_path= encu, dbo, comun;
--listar varcal relacionadas a claves bu
select * from varcal
  where varcal_grupo~*'claves bu';

------------------------------------------
-- mie_bu
------------------------------------------

--controlar que esta mie_be en tabla
select pla_enc,pla_mie_bu from plana_i1_ limit 2;

--1 agregar mie_bu a plana_i1_ y su his
ALTER TABLE encu.plana_i1_ 
  ADD COLUMN pla_mie_bu integer;
ALTER TABLE his.plana_i1_ 
  ADD COLUMN pla_mie_bu integer;  

--2 funciones y triggers para calculo de mie_bu
DROP FUNCTION IF EXISTS dbo.recalcular_mie_bu(integer);

SET SEARCH_PATH=encu,comun,public;
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
  LANGUAGE sql VOLATILE;
ALTER FUNCTION encu.recalcular_mie_bu(integer)
  OWNER TO tedede_php;


-- Function: encu.recalcular_mie_bu_s1_p_trg()
-- DROP FUNCTION encu.recalcular_mie_bu_s1_p_trg();

CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu_s1_p_trg()
  RETURNS trigger AS
$BODY$
    DECLARE
     v_val text;
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          select /*perform*/  recalcular_mie_bu(old.pla_enc) into v_val;
          select /*perform*/  recalcular_mie_bu(new.pla_enc) into v_val;
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie or new.pla_p4 is distinct from old.pla_p4 then
          select /*perform*/  recalcular_mie_bu(new.pla_enc) into v_val;
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          select /*perform*/  recalcular_mie_bu(new.pla_enc) into v_val;
          RETURN new;
    elsif TG_OP='DELETE' then
          select /*perform*/  recalcular_mie_bu(old.pla_enc) into v_val;
          RETURN old;
    end if;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.recalcular_mie_bu_s1_p_trg()
  OWNER TO tedede_php;

-- Function: encu.recalcular_mie_bu_i1_trg()
-- DROP FUNCTION encu.recalcular_mie_bu_i1_trg();

CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu_i1_trg()
  RETURNS trigger AS
  $BODY$
    DECLARE
     v_val text;
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          select /*perform*/  recalcular_mie_bu(old.pla_enc) into v_val;
          select /*perform*/  recalcular_mie_bu(new.pla_enc) into v_val;
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie then
          select /*perform*/  recalcular_mie_bu(new.pla_enc) into v_val;
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          select /*perform*/  recalcular_mie_bu(new.pla_enc) into v_val;
          RETURN new;
    elsif TG_OP='DELETE' then
          select /*perform*/  recalcular_mie_bu(old.pla_enc) into v_val;
          RETURN old;
    end if;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.recalcular_mie_bu_i1_trg()
  OWNER TO tedede_php; 

-- Trigger: recalcular_mie_bu_s1_p_trg on encu.plana_s1_p
-- DROP TRIGGER recalcular_mie_bu_s1_p_trg ON encu.plana_s1_p;
CREATE TRIGGER recalcular_mie_bu_s1_p_trg
  AFTER UPDATE OR INSERT OR DELETE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.recalcular_mie_bu_s1_p_trg();
  
 -- Trigger: recalcular_mie_bu_i1_trg on encu.plana_i1_
 -- DROP TRIGGER recalcular_mie_bu_i1_trg ON encu.plana_i1_;
CREATE TRIGGER recalcular_mie_bu_i1_trg
  AFTER UPDATE OR INSERT OR DELETE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.recalcular_mie_bu_i1_trg();

--3 para actualizar mie_bu inicialmente 
select encu.recalcular_mie_bu(x.encuesta) from 
(select distinct(pla_enc) as encuesta from encu.plana_s1_p) x;

--4 funcion mie_bue
CREATE OR REPLACE FUNCTION dbo.mie_bu(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer 
  LANGUAGE SQL STABLE
  AS
$BODY$
  SELECT CASE WHEN p_mie=95 THEN 95 WHEN p_mie is null THEN null WHEN p_mie=99 THEN 99 WHEN p_mie=-1 THEN -1 WHEN p_mie=-9 THEN -9
    ELSE (SELECT pla_mie_bu 
            FROM encu.plana_i1_
            WHERE pla_enc=p_enc and pla_hog=p_hog and pla_mie=p_mie) END;
$BODY$;
ALTER FUNCTION dbo.mie_bu(integer, integer, integer)
  OWNER TO tedede_php;

------------------------------------------
-- enc_bu
------------------------------------------

-- 5. agregar columna enc_bu
  alter table encu.tem
    add column tem_enc_bu integer;
  alter table encu.plana_tem_
    add column pla_enc_bu integer;

-- 6. Agregar  variable enc_bu como variable calculada
    --(generalmente esta en tabla)
    /*
   INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, 
            varcal_nsnc_atipico, varcal_grupo)
      VALUES (dbo.ope_actual(),'enc_bu','tem',200,
             'Encuesta Base Usuario',null,1,TRUE,
             'externo',TRUE,'enc_bu','entero',null,null,'claves bu');
   */
--7. tabla auxiliar para reordenar y numerar 
  create table operaciones.para_numerar_base_usuario as 
      select  row_number() over (order by pla_edad, pla_e2, pla_e6, pla_e12, substr(i.pla_enc::text,4,2) desc, i.pla_enc) as serial_number,
        pla_edad, pla_e2, pla_e6, pla_e12, substr(i.pla_enc::text,4,2), 
        i.pla_enc, i.pla_hog, i.pla_mie, pla_mie_bu
     from encu.plana_i1_ i
       inner join encu.plana_s1_p p on p.pla_mie = i.pla_mie and p.pla_hog = i.pla_hog and   i.pla_enc = p.pla_enc
     where pla_mie_bu =1 and i.pla_hog = 1;

  alter table operaciones.para_numerar_base_usuario add primary key (pla_enc);
  alter table operaciones.para_numerar_base_usuario add unique (serial_number);

-- 8. Seteo de valor a enc_bu

  update encu.plana_tem_ t
    set pla_enc_bu = serial_number 
    from operaciones.para_numerar_base_usuario x
    where t.pla_enc = x.pla_enc;

  update encu.tem t
    set tem_enc_bu = serial_number 
    from operaciones.para_numerar_base_usuario x
    where t.tem_enc = x.pla_enc;

  select pla_enc_bu, pla_enc,pla_estado, pla_rea, pla_norea,*
    from encu.plana_tem_
    order by 1,2,3,4
  -- limit 200 
  --quedan sin valor en enc_bu las norea.  

----------------/*
--9. Desde la app
  9.1 Varcal : 
      1 activar todas las variables de grupo claves_bu
      2 Correr el calculo

  9.2 Actualizar instalacion desde el programa        
----------------*/
---fin -----------
