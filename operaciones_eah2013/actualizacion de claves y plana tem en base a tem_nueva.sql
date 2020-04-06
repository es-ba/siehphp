UPDATE encu.tem t
   SET tem_id_marco=n.tem_id_marco ,  tem_comuna=n.tem_comuna ,  tem_replica=n.tem_replica ,  tem_up=n.tem_up ,  
       tem_lote=n.tem_lote ,  tem_clado=n.tem_clado ,  tem_ccodigo=n.tem_ccodigo ,  tem_cnombre=n.tem_cnombre ,  tem_hn=n.tem_hn ,  
       tem_hp=n.tem_hp ,  tem_hd=n.tem_hd ,  tem_hab=n.tem_hab ,  tem_h4=n.tem_h4 ,  tem_usp=n.tem_usp ,  tem_barrio=n.tem_barrio ,  
       tem_ident_edif=n.tem_ident_edif ,  tem_obs=n.tem_obs ,  tem_frac_comun=n.tem_frac_comun ,  tem_radio_comu=n.tem_radio_comu , 
       tem_mza_comuna=n.tem_mza_comuna ,  tem_dominio=n.tem_dominio ,  tem_marco=n.tem_marco ,  tem_titular=n.tem_titular , 
       tem_zona=n.tem_zona ,  tem_lote2011=n.tem_lote2011 ,  tem_para_asignar=n.tem_para_asignar ,  
       tem_participacion=n.tem_participacion,  tem_tlg=1
from encu.tem_nueva n
where n.tem_enc=t.tem_enc;

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


delete from encu.respuestas where res_ope='eah2013' and res_enc in 
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

delete from encu.plana_tem_ where pla_enc in 
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

delete from encu.plana_s1_ where pla_enc in 
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

delete from encu.plana_s1_p where pla_enc in 
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

delete from encu.plana_i1_ where pla_enc in 
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

delete from encu.plana_a1_ where pla_enc in 
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

delete from encu.plana_a1_x where pla_enc in 
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

delete from encu.claves where cla_ope='eah2013' and cla_enc in
(select tem_enc from encu.tem_nueva inner join encu.claves on cla_enc=tem_enc where cla_for ='TEM');

alter table encu.plana_tem_ alter column pla_hn type text;

insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
(select 'eah2013', 'TEM','', tem_enc, 0, 0, 0, 1 FROM encu.tem_nueva);



       select *
from encu.plana_tem_ t inner JOIN encu.tem_nueva n ON t.pla_enc=n.tem_enc
where t.pla_id_marco is not distinct from n.tem_id_marco 
and  t.pla_comuna is not distinct from n.tem_comuna and  t.pla_replica is not distinct from n.tem_replica and  t.pla_up is not distinct from n.tem_up and  
       t.pla_lote is not distinct from n.tem_lote and  t.pla_clado is not distinct from n.tem_clado and  t.pla_ccodigo is not distinct from n.tem_ccodigo and  t.pla_cnombre is not distinct from n.tem_cnombre and  t.pla_hn is not distinct from n.tem_hn and  
       t.pla_hp is not distinct from n.tem_hp and  t.pla_hd is not distinct from n.tem_hd and  t.pla_hab is not distinct from n.tem_hab and  
       t.pla_h4 is not distinct from n.tem_h4 and  t.pla_usp is not distinct from n.tem_usp and  t.pla_barrio is not distinct from n.tem_barrio 
       and  t.pla_ident_edif is not distinct from n.tem_ident_edif and  t.pla_obs is not distinct from n.tem_obs and  
       t.pla_frac_comun is not distinct from n.tem_frac_comun and  t.pla_radio_comu is not distinct from n.tem_radio_comu and 
       t.pla_mza_comuna is not distinct from n.tem_mza_comuna and  t.pla_dominio is not distinct from n.tem_dominio 
       and  t.pla_marco is not distinct from n.tem_marco and  t.pla_titular is not distinct from n.tem_titular and t.pla_zona is not distinct 
       from n.tem_zona and  t.pla_lote2011 is not distinct from n.tem_lote2011 and  t.pla_para_asignar is not distinct from n.tem_para_asignar and  
       t.pla_participacion is not distinct from n.tem_participacion


       select t.pla_enc, t.pla_lote2011
from encu.plana_tem_ t inner JOIN encu.tem_nueva n ON t.pla_enc=n.tem_enc
where   t.pla_lote2011 is not distinct from n.tem_lote2011 


              
       select *
from encu.plana_tem_ t inner JOIN encu.tem_nueva n ON t.pla_enc=n.tem_enc
where t.pla_id_marco is distinct from n.tem_id_marco 
and  t.pla_comuna is distinct from n.tem_comuna and  t.pla_replica is distinct from n.tem_replica and  t.pla_up is distinct from n.tem_up and  
       t.pla_lote is distinct from n.tem_lote and  t.pla_clado is distinct from n.tem_clado and  t.pla_ccodigo is distinct from n.tem_ccodigo and  t.pla_cnombre is distinct from n.tem_cnombre and  t.pla_hn is distinct from n.tem_hn and  
       t.pla_hp is distinct from n.tem_hp and  t.pla_hd is distinct from n.tem_hd and  t.pla_hab is distinct from n.tem_hab and  
       t.pla_h4 is distinct from n.tem_h4 and  t.pla_usp is distinct from n.tem_usp and  t.pla_barrio is distinct from n.tem_barrio 
       and  t.pla_ident_edif is distinct from n.tem_ident_edif and  t.pla_obs is distinct from n.tem_obs and  
       t.pla_frac_comun is distinct from n.tem_frac_comun and  t.pla_radio_comu is distinct from n.tem_radio_comu and 
       t.pla_mza_comuna is distinct from n.tem_mza_comuna and  t.pla_dominio is distinct from n.tem_dominio 
       and  t.pla_marco is distinct from n.tem_marco and  t.pla_titular is distinct from n.tem_titular and t.pla_zona is distinct 
       from n.tem_zona and  t.pla_lote2011 is distinct from n.tem_lote2011 and  t.pla_para_asignar is distinct from n.tem_para_asignar and  
       t.pla_participacion is distinct from n.tem_participacion