ALTER TABLE encu.varcal DROP CONSTRAINT  IF EXISTS  "tipo de variable calculada inválido (normal,externo)";
ALTER TABLE encu.varcal
  ADD CONSTRAINT "tipo de variable calculada inválido (normal,externo,especial)" CHECK (varcal_tipo::text in ('normal', 'externo', 'especial'));

INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo,varcal_baseusuario, varcal_nombrevar_baseusuario, varcal_tipodedato)
    VALUES ('eah2013', 'mie_bu', 'mie',4800 , 'Número de miembro para Base usuarios',null, 1, TRUE, 'especial', TRUE, 'mie_bu','entero');

ALTER TABLE encu.plana_i1_ 
  ADD COLUMN pla_mie_bu integer;
ALTER TABLE his.plana_i1_ 
  ADD COLUMN pla_mie_bu integer;  

-- Function: dbo.recalcular_mie_bu(p_enc)

-- DROP FUNCTION dbo.recalcular_mie_bu(integer);
SET SEARCH_PATH=encu,comun,public;
CREATE OR REPLACE FUNCTION dbo.recalcular_mie_bu(p_enc integer)
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
ALTER FUNCTION dbo.recalcular_mie_bu(integer)
  OWNER TO tedede_php;


-- Function: encu.recalcular_mie_bu_s1_p_trg()

-- DROP FUNCTION encu.recalcular_mie_bu_s1_p_trg();

CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu_s1_p_trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          perform dbo.recalcular_mie_bu(new.pla_enc);
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie or new.pla_p4 is distinct from old.pla_p4 then
          perform dbo.recalcular_mie_bu(new.pla_enc);
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          perform dbo.recalcular_mie_bu(new.pla_enc);
          RETURN new;
    elsif TG_OP='DELETE' then
          perform dbo.recalcular_mie_bu(old.pla_enc);
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
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          perform dbo.recalcular_mie_bu(new.pla_enc);
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie then
          perform dbo.recalcular_mie_bu(new.pla_enc);
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          perform dbo.recalcular_mie_bu(new.pla_enc);
          RETURN new;
    elsif TG_OP='DELETE' then
          perform dbo.recalcular_mie_bu(old.pla_enc);
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

/* para actualizar mie_bu inicialmente 
select dbo.recalcular_mie_bu(x.encuesta) from 
(select distinct(pla_enc) as encuesta from encu.plana_s1_p) x;

select pla_enc, pla_hog, pla_mie,pla_mie_bu
from plana_i1_
order by pla_enc, pla_hog, pla_mie, pla_mie_bu;

--prueba de la función
select pla_enc, pla_hog, pla_mie, pla_mie_bu
from plana_i1_
where pla_mie is distinct from pla_mie_bu;

select i.pla_enc, i.pla_hog, i.pla_mie, pla_mie_bu , pla_p4 from encu.plana_i1_ i inner join plana_s1_p p on 
i.pla_enc = p.pla_enc and i.pla_hog = p.pla_hog and i.pla_mie = p.pla_mie and p.pla_enc=512770
order by pla_enc, pla_hog, pla_mie;
*/
/*
 para probar

update encu.respuestas set res_valor = '0'
 where res_ope ='eah2013' and res_for='TEM' and res_mat = '' and res_enc = 130009 and res_hog = 0 and res_mie = 0 and res_var = 'fin_anacon';
select pla_estado from encu.plana_tem_ where pla_enc = 130009 and pla_hog = 0 and pla_mie = 0;

--cambio parentesco p4 para que el jefe sea otro miembro 
update encu.respuestas set res_valor = 2
 where res_ope ='eah2013' and res_for='S1' and res_mat = 'P' and res_enc = 130009 and res_hog = 1 and res_mie = 1 and res_var = 'p4';
update encu.respuestas set res_valor = 1P
 where res_ope ='eah2013' and res_for='S1' and res_mat = 'P' and res_enc = 130009 and res_hog = 1 and res_mie = 4 and res_var = 'p4';

select pla_p4 from encu.plana_s1_p where pla_enc = 130009 and pla_hog = 1 and pla_mie = 4;
 --
select i.pla_enc, i.pla_hog, i.pla_mie, pla_mie_bu , pla_p4 from encu.plana_i1_ i inner join plana_s1_p p on 
i.pla_enc = p.pla_enc and i.pla_hog = p.pla_hog and i.pla_mie = p.pla_mie
order by pla_enc, pla_hog, pla_mie;

select pla_edad, pla_nombre from encu.plana_s1_p where pla_enc = 130016 and pla_hog = 1 and pla_mie = 3;

--actualiza nro. de miembro. 
update encu.respuestas set res_mie = 4 where res_ope = 'eah2013' and res_for='S1' and res_mat = 'P' and res_enc = 130016 and res_hog = 1 and res_mie = 3;
update encu.respuestas set res_mie = 4 where res_ope = 'eah2013' and res_for='I1' and res_mat = '' and res_enc = 130016 and res_hog = 1 and res_mie = 3;
 
select pla_mie, pla_mie_bu from encu.plana_i1_ where pla_enc = 130009 and pla_hog = 1 order by pla_mie;
select pla_mie,pla_edad, pla_nombre, pla_p4 from encu.plana_s1_p where pla_enc = 130009 and pla_hog = 1;
--insercion de un miembro pruebo desde el sistema
--borrado de un miembro pruebo desde el sistema, solo del I1 o del I1 y del S1p
*/