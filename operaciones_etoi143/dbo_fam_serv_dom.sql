set search_path = encu, comun, public;

CREATE OR REPLACE FUNCTION  dbo.fam_serv_dom(p_enc integer, p_hog integer, p_mie integer)
  RETURNS boolean 
  LANGUAGE SQL
  AS
$BODY$
SELECT case when m.pla_p4=13 then true when m.pla_p4=14 then
          (
           SELECT true
             FROM encu.plana_s1_p p -- pariente
             WHERE p.pla_enc=m.pla_enc
               AND p.pla_hog=m.pla_hog
               AND p.pla_p4 = 13 
               AND (p.pla_mie = m.pla_p5b OR p.pla_mie = m.pla_p6_a OR p.pla_mie = m.pla_p6_b
                   OR m.pla_mie = p.pla_p5b OR m.pla_mie = p.pla_p6_a OR m.pla_mie = p.pla_p6_b)
           LIMIT 1
          ) is true
       else false end
  FROM encu.plana_s1_p m
  WHERE m.pla_enc=p_enc
    AND m.pla_hog=p_hog
    AND m.pla_mie=p_mie;
$BODY$;
    
ALTER FUNCTION dbo.fam_serv_dom(integer, integer, integer)
  OWNER TO tedede_php;

CREATE OR REPLACE FUNCTION  dbo.fam_serv_dom_pl(p_enc integer, p_hog integer, p_mie integer)
  RETURNS boolean AS
$BODY$
DECLARE
  p4 integer;
  p5b integer;
  p6_a integer;
  p6_b integer;
  existe integer;
BEGIN
SELECT pla_p4, pla_p5b, pla_p6_a, pla_p6_b INTO p4, p5b, p6_a, p6_b
  FROM encu.plana_s1_p
  WHERE pla_enc=p_enc
    AND pla_hog=p_hog
    AND pla_mie=p_mie;
IF p4 = 13 THEN 
  RETURN true;
ELSE
  IF p4 = 14 THEN
    IF (p5b<>95) is true OR (p6_a<>95) is true OR (p6_b<>95) is true THEN 
      SELECT 1 INTO existe
        FROM encu.plana_s1_p
        WHERE pla_enc=p_enc
          AND pla_hog=p_hog
          AND pla_p4 = 13 
          AND (pla_mie = p5b or pla_mie = p6_a or pla_mie = p6_b);
      IF existe = 1 THEN
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;
    ELSE
      SELECT 1 INTO existe
        FROM encu.plana_s1_p
        WHERE pla_enc=p_enc
          AND pla_hog=p_hog
          AND pla_p4 = 13 
          AND (pla_p5b = p_mie or pla_p6_a = p_mie or pla_p6_b = p_mie);
      IF existe = 1 THEN
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;
   END IF;
  ELSE
    RETURN FALSE;
  END IF;
END IF;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION dbo.fam_serv_dom_pl(integer, integer, integer)
  OWNER TO tedede_php;

-- CASOS DE PRUEBA 
-- /* 

DELETE FROM encu.plana_s1_p WHERE pla_enc=130001 AND pla_hog=1 AND pla_mie>=3;
INSERT INTO encu.plana_s1_p (pla_enc, pla_hog, pla_mie, pla_exm, pla_tlg, pla_nombre,pla_p4, pla_p5b,pla_p6_a,pla_p6_b) values 
  (130001,1,3,0,1,'es 13'               ,13,null,null,7),
  (130001,1,4,0,1,'es conyuge'          ,14,3   ,null,null),
  (130001,1,5,0,1,'es hijo'             ,14,null,3   ,null),
  (130001,1,6,0,1,'es madre'            ,14,null,null,3),
  (130001,1,7,0,1,'es madre de un 13'   ,14,null,null,null),
  (130001,1,8,0,1,'no, es 12'           ,12,null,null,3),
  (130001,1,9,0,1,'no, es conyuge de un 14' ,14,7,null,null),
  (130001,1,10,0,1,'no, es padre de un 14'  ,14,null,7,null),
  (130001,1,11,0,1,'es madre de un 13'  ,13,null,3,NULL),
  (130001,1,12,0,1,'es conyuge de un 13',13,3,null,NULL);
  

SELECT dbo.fam_serv_dom(pla_enc, pla_hog, pla_mie),dbo.fam_serv_dom_pl(pla_enc, pla_hog, pla_mie), *, (pla_p5b<>95) is true ,(pla_p6_a<>95) is true , (pla_p6_b<>95) is true
--(m.pla_p4 = 13) is true , 
--   (m.pla_p4 = 14) is true,(m.pla_p5b<>95) is true,(p.pla_p6_a<>95) is true,(a.pla_p6_b<>95) is true , *
  FROM encu.plana_s1_p
  -- WHERE dbo.fam_serv_dom(pla_enc, pla_hog, pla_mie) is distinct from dbo.fam_serv_dom_pl(pla_enc, pla_hog, pla_mie)
  WHERE pla_enc=130001 AND pla_hog=1 AND pla_mie>=3;
-- */