set search_path = encu, comun, public;

CREATE OR REPLACE FUNCTION dbo.no_coin_c(p_enc integer, p_hog integer, p_mie integer)
  RETURNS boolean
  LANGUAGE SQL STABLE AS
$BODY$
    SELECT m.pla_p5 in (1,2) is true <> (m.pla_p5b<>95) is true  
        OR m.pla_p5 in (1,2) is true AND c.pla_p5b is distinct from m.pla_mie 
        OR m.pla_p5 in (1,2) is true AND m.pla_p5 is distinct from c.pla_p5 
      FROM encu.plana_s1_p m 
        LEFT JOIN encu.plana_s1_p c 
          ON m.pla_enc=c.pla_enc 
            AND m.pla_hog=c.pla_hog 
            AND m.pla_p5b=c.pla_mie 
            AND m.pla_exm=c.pla_exm -- !PK verificada
      WHERE m.pla_enc=p_enc
        AND m.pla_hog=p_hog
        AND m.pla_mie=p_mie;
$BODY$;
ALTER FUNCTION dbo.no_coin_c(integer, integer, integer)
  OWNER TO tedede_php;

-- CASOS DE PRUEBA 
/* 
DELETE FROM encu.plana_s1_p WHERE pla_enc=130001 AND pla_hog=1 AND pla_mie>=3;
INSERT INTO encu.plana_s1_p (pla_enc, pla_hog, pla_mie, pla_exm, pla_tlg, pla_nombre,pla_p5,pla_p5b) values 
  (130001,1,3,0,1,'casado sin conyuge null',1,null),
  (130001,1,4,0,1,'casado sin conyuge 95',1,95),
  (130001,1,5,0,1,'con conyuge y viudo',4,2),
  (130001,1,6,0,1,'con conyuge que no declara que lo es',1,7),
  (130001,1,7,0,1,'ok',4,95),
  (130001,1,8,0,1,'ok',1,9),
  (130001,1,9,0,1,'ok',1,8),
  (130001,1,10,0,1,'no declara el mismo estado',1,11),
  (130001,1,11,0,1,'no declara el mismo estado',2,10);
  

SELECT dbo.no_coin_c(pla_enc, pla_hog, pla_mie), pla_p5 in (1,2) , (pla_p5b<>95) is true, *
  FROM encu.plana_s1_p
  WHERE pla_enc=130001 AND pla_hog=1 AND pla_mie>=3;

-- */
