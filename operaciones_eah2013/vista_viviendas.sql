-- View: encu.viviendas

-- DROP VIEW encu.viviendas;

CREATE OR REPLACE VIEW encu.viviendas AS 
 SELECT t.pla_enc AS encues, 
    t.pla_id_marco AS id_marco, 
    t.pla_comuna AS comuna, 
    t.pla_replica AS replica, 
    t.pla_up AS up, 
        CASE
            WHEN t.pla_rea = ANY (ARRAY[2, 3]) THEN t.pla_rea - 2
            ELSE t.pla_rea
        END AS rea, 
    t.pla_norea AS norea, 
    max(
        CASE a.pla_h2
            WHEN 6 THEN 1
            ELSE 0
        END) AS h2_6, 
    t.pla_hog_pre AS hog_pre, 
    t.pla_hog_tot AS hog_tot, 
    t.pla_pob_pre AS pob_pre, 
    t.pla_cnombre AS cnombre, 
    t.pla_hn AS hn, 
    t.pla_hp AS hp, 
    t.pla_hd AS hd, 
    t.pla_obs AS obs, 
    t.pla_estrato AS estrato, 
    t.pla_tot_hab AS habitaciones, 
    t.pla_inq_ocu_flia AS inq_ocu_flia, 
    t.pla_inq_tot_hab AS inq_tot_hab
   FROM encu.plana_tem_ t
   LEFT JOIN encu.plana_a1_ a ON t.pla_enc = a.pla_enc
  WHERE t.pla_estado >= 70 AND t.pla_estado <> 98
  GROUP BY t.pla_enc, t.pla_id_marco, t.pla_comuna, t.pla_replica, t.pla_up, t.pla_rea, t.pla_norea, t.pla_hog_pre, t.pla_hog_tot, t.pla_pob_pre, t.pla_cnombre, t.pla_hn, t.pla_hp, t.pla_hd, t.pla_obs, t.pla_estrato, t.pla_tot_hab, t.pla_inq_ocu_flia, t.pla_inq_tot_hab
  ORDER BY t.pla_enc;

ALTER TABLE encu.viviendas
  OWNER TO postgres;