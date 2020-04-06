-- Function: encu.claves_ins_trg()

-- DROP FUNCTION encu.claves_ins_trg();

CREATE OR REPLACE FUNCTION encu.claves_ins_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_sentencia text;
BEGIN
  -- GENERADO POR: generacion_trigger_respuestas.php
  INSERT INTO encu.respuestas (res_ope,res_for,res_mat,res_enc,res_hog,res_mie,res_exm, res_var, res_tlg)
    SELECT new.cla_ope,new.cla_for,new.cla_mat,new.cla_enc,new.cla_hog,new.cla_mie,new.cla_exm, var_var, new.cla_tlg
      FROM encu.variables 
      WHERE var_ope=new.cla_ope AND var_mat=new.cla_mat AND var_for=new.cla_for;
if new.cla_ope = 'eah2013' then
  IF new.cla_for='TEM' and new.cla_mat='' THEN
    v_sentencia:='INSERT INTO encu.plana_tem_ (pla_enc,pla_hog,pla_mie,pla_exm, 
    pla_id_marco,pla_comuna,pla_replica,pla_up,pla_lote,pla_clado,pla_ccodigo,pla_cnombre,pla_hn,pla_hp,
    pla_hd,pla_hab,pla_h4,pla_usp,pla_barrio,pla_ident_edif,pla_obs,pla_frac_comun,pla_radio_comu,pla_mza_comuna,
    pla_marco,pla_titular,pla_zona,pla_para_asignar,pla_participacion, pla_tlg, pla_dominio, pla_lote2011, pla_codpos) 
    (SELECT $3, $4, $5, $6,  tem_id_marco,tem_comuna,tem_replica,tem_up,tem_lote,tem_clado,tem_ccodigo,tem_cnombre,tem_hn,tem_hp,
    tem_hd,tem_hab,tem_h4,tem_usp,tem_barrio,tem_ident_edif,tem_obs,tem_frac_comun,tem_radio_comu,tem_mza_comuna,
    tem_marco,tem_titular,tem_zona,tem_para_asignar,tem_participacion, $2, tem_dominio, tem_lote2011, tem_codpos FROM encu.tem  WHERE tem_enc=$1)';
    EXECUTE v_sentencia USING new.cla_enc, new.cla_tlg , new.cla_enc, new.cla_hog, new.cla_mie, new.cla_exm;
  ELSE
    v_sentencia:='INSERT INTO encu.plana_'||new.cla_for||'_'||new.cla_mat||' (pla_tlg, pla_enc, pla_hog, pla_mie, pla_exm) values ($1 , $2, $3, $4, $5)';
    EXECUTE v_sentencia USING new.cla_tlg , new.cla_enc, new.cla_hog, new.cla_mie, new.cla_exm;
  END IF;
end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.claves_ins_trg()
  OWNER TO tedede_php;
