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
if new.cla_ope = 'eah2012' then
  IF new.cla_for='TEM' and new.cla_mat='' THEN
    v_sentencia:='INSERT INTO encu.plana_tem_ (pla_enc,pla_hog,pla_mie,pla_exm, 
    pla_id_marco,pla_comuna,pla_replica,pla_up,pla_lote,pla_clado,pla_ccodigo,pla_cnombre,pla_hn,pla_hp,
    pla_hd,pla_hab,pla_h4,pla_usp,pla_barrio,pla_ident_edif,pla_obs,pla_frac_comun,pla_radio_comu,pla_mza_comuna,
    pla_marco,pla_titular,pla_zona,pla_para_asignar,pla_participacion, pla_tlg, pla_dominio) 
    (SELECT $3, $4, $5, $6,  tem_id_marco,tem_comuna,tem_replica,tem_up,tem_lote,tem_clado,tem_ccodigo,tem_cnombre,tem_hn,tem_hp,
    tem_hd,tem_hab,tem_h4,tem_usp,tem_barrio,tem_ident_edif,tem_obs,tem_frac_comun,tem_radio_comu,tem_mza_comuna,
    tem_marco,tem_titular,tem_zona,tem_para_asignar,tem_participacion, $2, tem_dominio FROM encu.tem  WHERE tem_enc=$1)';
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

/* Así lo probamos
select *
from encu.plana_tem_
where pla_enc in (370686);

insert into encu.tem
select 
destino as tem_enc, tem_id_marco, tem_comuna, tem_replica, tem_up, tem_lote, 
tem_clado, tem_ccodigo, tem_cnombre, tem_hn, tem_hp, departamento as tem_hd, 
tem_hab, tem_h4, tem_usp, tem_barrio, tem_ident_edif, tem_obs, 
tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_marco, tem_titular, 
tem_zona, tem_para_asignar, tem_tlg, tem_dominio, tem_lote2011, 
tem_participacion
from encu.tem t inner join 
(select 310686 as origen, 370686 as destino, 'A IZQUIERDA' as departamento) x
on t.tem_enc=x.origen;

insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
cla_tlg)
select 'eah2012' as cla_ope, 'TEM' as cla_for, '' as cla_mat, destino as cla_enc, 0 as cla_hog, 0 as cla_mie, 0 as cla_exm, 

1 as cla_tlg
from (select 310686 as origen, 370686 as destino, 'A IZQUIERDA' as departamento) x;

select tem_dominio, pla_dominio, * from encu.tem inner join encu.plana_tem_ on tem_enc = pla_enc where tem_dominio is distinct from pla_dominio;*/