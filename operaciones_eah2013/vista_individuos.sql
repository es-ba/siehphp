-- DROP VIEW encu.individuos;

CREATE OR REPLACE VIEW encu.individuos AS 
 SELECT 
    t.pla_enc AS encues,
    s.pla_hog AS nhogar, 
    rank() OVER (PARTITION BY s.pla_enc, s.pla_hog ORDER BY s.pla_p4 = 1 DESC, s.pla_mie) AS mie_bu,
    t.pla_comuna AS comuna, 
    t.pla_replica AS replica, 
    t.pla_up AS up, 
    s.pla_edad AS edad, 
    s.pla_sexo AS sexo
   FROM encu.plana_tem_ t
   JOIN encu.plana_s1_p s ON t.pla_enc = s.pla_enc
   JOIN encu.plana_i1_ i ON i.pla_enc = s.pla_enc AND i.pla_hog = s.pla_hog AND i.pla_mie = s.pla_mie
  WHERE t.pla_estado >= 70 AND t.pla_estado <> 98
  ORDER BY t.pla_enc, s.pla_hog, s.pla_p4 = 1 DESC, s.pla_mie;

ALTER TABLE encu.individuos
  OWNER TO postgres;