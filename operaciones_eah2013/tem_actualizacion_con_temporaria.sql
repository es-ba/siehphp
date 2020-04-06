-- replica 1,2 
update encu.tem_temporaria
    set tem_etiquetas=1
    where tem_replica in (1,2);
    
select count(*) cant, 'respuestas' tabla
    from encu.respuestas a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.res_enc ) 
union    
select count(*) cant, 'tem' tabla
    from encu.tem a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.tem_enc ) 
union    
select count(*)  cant, 'plana_tem' tabla
    from encu.plana_tem_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc ) 
union    
select count(*) cant, 'plana_s1_' tabla
    from encu.plana_s1_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc )
union    
select count(*)cant, 'plana_s1_p' tabla
    from encu.plana_s1_p a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc )
union    
select count(*) cant, 'plana_a1_' tabla 
    from encu.plana_a1_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc )
union    
select count(*) cant, 'plana_a1_x' tabla 
    from encu.plana_a1_x a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc )
union    
select count(*) cant, 'plana_i1_' tabla
    from encu.plana_i1_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc )
union    
select count(*) cant, 'claves' tabla 
    from encu.claves a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.cla_enc ) 
union    
select count(*) cant, 'inconsistencias' tabla 
    from encu.inconsistencias a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.inc_enc )     

4399;"tem"
161;"plana_s1_p"
201059;"respuestas"
148;"plana_i1_"
3633;"claves"
25;"inconsistencias"
3174;"plana_tem"
59;"plana_a1_"
11;"plana_a1_x"
80;"plana_s1_"

--paso 2
delete from encu.respuestas a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.res_enc ) ;    
delete from encu.tem a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.tem_enc ) ;    
delete  from encu.plana_tem_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc ) ;    
delete from encu.plana_s1_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc );    
delete from encu.plana_s1_p a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc );    
delete from encu.plana_a1_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc );    
delete from encu.plana_a1_x a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc );    
delete from encu.plana_i1_ a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.pla_enc );    
delete from encu.claves a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.cla_enc ) ;    
delete from encu.inconsistencias a
    where not exists (select * from encu.tem_temporaria b  where b.tem_enc=a.inc_enc ) ;   
 
--paso3
    SELECT count(*)
         FROM encu.tem_temporaria a 
         where not exists (SELECT tem_enc from encu.tem b where b.tem_enc=a.tem_enc);
INSERT INTO encu.tem (tem_enc, tem_id_marco, tem_comuna, tem_replica, tem_up, tem_lote, tem_clado, tem_ccodigo, tem_cnombre, tem_hn, tem_hp, tem_hd, tem_hab, tem_h4, tem_usp, tem_barrio, tem_ident_edif, tem_obs, tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_marco, tem_titular, tem_zona, tem_para_asignar, tem_tlg, tem_dominio, tem_lote2011, tem_participacion, tem_etiquetas, tem_codpos, tem_tipounidad, tem_tot_hab, tem_estrato)
    SELECT a.tem_enc, a.tem_id_marco, a.tem_comuna, a.tem_replica, a.tem_up, a.tem_lote, a.tem_clado, a.tem_ccodigo, a.tem_cnombre, a.tem_hn, a.tem_hp, a.tem_hd, a.tem_hab, a.tem_h4, a.tem_usp, a.tem_barrio, a.tem_ident_edif, a.tem_obs, a.tem_frac_comun, a.tem_radio_comu, a.tem_mza_comuna, a.tem_marco, a.tem_titular, a.tem_zona, a.tem_para_asignar, a.tem_tlg, a.tem_dominio, a.tem_lote2011, a.tem_participacion, a.tem_etiquetas, a.tem_codpos, a.tem_tipounidad, a.tem_tot_hab, a.tem_estrato
         FROM encu.tem_temporaria a 
         where not exists (SELECT tem_enc from encu.tem b where b.tem_enc=a.tem_enc);

-- ANTES MODIFICAR EL TRIGGER DE CLAVES

select count(*)
    FROM encu.tem_temporaria a
    WHERE NOT EXISTS (SELECT cla_enc from encu.claves b where b.cla_enc=a.tem_enc)
        
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
(select 'eah2013', 'TEM','', a.tem_enc, 0, 0, 0, 1 
    FROM encu.tem_temporaria a
    WHERE NOT EXISTS (SELECT cla_enc from encu.claves b where b.cla_enc=a.tem_enc));        

select count(*)
from encu.plana_tem_

--PASO4
SELECT COUNT(*)
 from encu.tem t join encu.tem_temporaria n on t.tem_enc=n.tem_enc
 where
        t.tem_id_marco is distinct from n.tem_id_marco OR
       t.tem_comuna is distinct from n.tem_comuna OR
       t.tem_replica is distinct from n.tem_replica OR
       t.tem_up is distinct from n.tem_up OR  
       t.tem_lote is distinct from n.tem_lote OR
       t.tem_clado is distinct from n.tem_clado OR
       t.tem_ccodigo is distinct from n.tem_ccodigo OR
       t.tem_cnombre is distinct from n.tem_cnombre OR
       t.tem_hn is distinct from n.tem_hn OR  
       t.tem_hp is distinct from n.tem_hp OR
       t.tem_hd is distinct from n.tem_hd OR
       t.tem_hab is distinct from n.tem_hab OR  
       t.tem_h4 is distinct from n.tem_h4 OR
       t.tem_usp is distinct from n.tem_usp OR
       t.tem_barrio is distinct from n.tem_barrio OR
       t.tem_ident_edif is distinct from n.tem_ident_edif OR
       t.tem_obs is distinct from n.tem_obs OR  
       t.tem_frac_comun is distinct from n.tem_frac_comun OR
       t.tem_radio_comu is distinct from n.tem_radio_comu OR 
       t.tem_mza_comuna is distinct from n.tem_mza_comuna OR
       t.tem_dominio is distinct from n.tem_dominio OR 
       t.tem_marco is distinct from n.tem_marco OR
       t.tem_titular is distinct from n.tem_titular OR
       t.tem_zona is distinct from n.tem_zona OR
       t.tem_lote2011 is distinct from n.tem_lote2011 OR 
       t.tem_para_asignar is distinct from n.tem_para_asignar OR  
       t.tem_participacion is distinct from n.tem_participacion OR  
       t.tem_codpos is distinct from n.tem_codpos OR
       t.tem_etiquetas is distinct from n.tem_etiquetas OR
       t.tem_tipounidad is distinct from n.tem_tipounidad OR
       t.tem_tot_hab is distinct from n.tem_tot_hab OR
       t.tem_estrato is distinct from n.tem_estrato
 
UPDATE encu.tem t
SET tem_id_marco=n.tem_id_marco ,
    tem_comuna=n.tem_comuna ,
    tem_replica=n.tem_replica ,
    tem_up=n.tem_up ,
    tem_lote=n.tem_lote ,
    tem_clado=n.tem_clado ,
    tem_ccodigo=n.tem_ccodigo ,
    tem_cnombre=n.tem_cnombre ,
    tem_hn=n.tem_hn ,
    tem_hp=n.tem_hp ,
    tem_hd=n.tem_hd ,
    tem_hab=n.tem_hab ,
    tem_h4=n.tem_h4 ,
    tem_usp=n.tem_usp ,
    tem_barrio=n.tem_barrio ,
    tem_ident_edif=n.tem_ident_edif ,
    tem_obs=n.tem_obs ,
    tem_frac_comun=n.tem_frac_comun ,
    tem_radio_comu=n.tem_radio_comu ,
    tem_mza_comuna=n.tem_mza_comuna ,
    tem_dominio=n.tem_dominio ,
    tem_marco=n.tem_marco ,
    tem_titular=n.tem_titular ,
    tem_zona=n.tem_zona ,
    tem_lote2011=n.tem_lote2011 ,
    tem_para_asignar=n.tem_para_asignar ,
    tem_participacion=n.tem_participacion,
    tem_tlg=1,
    tem_etiquetas=n.tem_etiquetas,
    tem_codpos=n.tem_codpos,
    tem_tipounidad=n.tem_tipounidad,
    tem_tot_hab=n.tem_tot_hab,
    tem_estrato=n.tem_estrato
  FROM encu.tem_temporaria n
  WHERE t.tem_enc=n.tem_enc and ( 
       t.tem_id_marco is distinct from n.tem_id_marco OR
       t.tem_comuna is distinct from n.tem_comuna OR
       t.tem_replica is distinct from n.tem_replica OR
       t.tem_up is distinct from n.tem_up OR  
       t.tem_lote is distinct from n.tem_lote OR
       t.tem_clado is distinct from n.tem_clado OR
       t.tem_ccodigo is distinct from n.tem_ccodigo OR
       t.tem_cnombre is distinct from n.tem_cnombre OR
       t.tem_hn is distinct from n.tem_hn OR  
       t.tem_hp is distinct from n.tem_hp OR
       t.tem_hd is distinct from n.tem_hd OR
       t.tem_hab is distinct from n.tem_hab OR  
       t.tem_h4 is distinct from n.tem_h4 OR
       t.tem_usp is distinct from n.tem_usp OR
       t.tem_barrio is distinct from n.tem_barrio OR
       t.tem_ident_edif is distinct from n.tem_ident_edif OR
       t.tem_obs is distinct from n.tem_obs OR  
       t.tem_frac_comun is distinct from n.tem_frac_comun OR
       t.tem_radio_comu is distinct from n.tem_radio_comu OR 
       t.tem_mza_comuna is distinct from n.tem_mza_comuna OR
       t.tem_dominio is distinct from n.tem_dominio OR 
       t.tem_marco is distinct from n.tem_marco OR
       t.tem_titular is distinct from n.tem_titular OR
       t.tem_zona is distinct from n.tem_zona OR
       t.tem_lote2011 is distinct from n.tem_lote2011 OR 
       t.tem_para_asignar is distinct from n.tem_para_asignar OR  
       t.tem_participacion is distinct from n.tem_participacion OR  
       t.tem_codpos is distinct from n.tem_codpos OR
       t.tem_etiquetas is distinct from n.tem_etiquetas OR
       t.tem_tipounidad is distinct from n.tem_tipounidad OR
       t.tem_tot_hab is distinct from n.tem_tot_hab OR
       t.tem_estrato is distinct from n.tem_estrato)
  
UPDATE encu.plana_tem_ t
SET pla_id_marco=n.tem_id_marco ,
    pla_comuna=n.tem_comuna ,
    pla_replica=n.tem_replica ,
    pla_up=n.tem_up ,
    pla_lote=n.tem_lote ,
    pla_clado=n.tem_clado ,
    pla_ccodigo=n.tem_ccodigo ,
    pla_cnombre=n.tem_cnombre ,
    pla_hn=n.tem_hn ,
    pla_hp=n.tem_hp ,
    pla_hd=n.tem_hd ,
    pla_hab=n.tem_hab ,
    pla_h4=n.tem_h4 ,
    pla_usp=n.tem_usp ,
    pla_barrio=n.tem_barrio ,
    pla_ident_edif=n.tem_ident_edif ,
    pla_obs=n.tem_obs ,
    pla_frac_comun=n.tem_frac_comun ,
    pla_radio_comu=n.tem_radio_comu ,
    pla_mza_comuna=n.tem_mza_comuna ,
    pla_dominio=n.tem_dominio ,
    pla_marco=n.tem_marco ,
    pla_titular=n.tem_titular ,
    pla_zona=n.tem_zona ,
    pla_lote2011=n.tem_lote2011 ,
    pla_para_asignar=n.tem_para_asignar ,
    pla_participacion=n.tem_participacion,
    pla_tlg=1,
    pla_etiquetas=n.tem_etiquetas,
    pla_codpos=n.tem_codpos,
    pla_tipounidad=n.tem_tipounidad,
    pla_tot_hab=n.tem_tot_hab,
    pla_estrato=n.tem_estrato
  FROM encu.tem_temporaria n
  WHERE t.pla_enc=n.tem_enc
  
  -- NO ES MEJOR HACER EL UPDATE ANTES DEL INSERT?

    
--VER REPLICA=1,2 TIENE QUE TENER ETIQUETAS=1 
-- corregir trigger control_pk
-- ver tem_ident_edif y obs
select * from encu.tem
where tem_ident_edif like '%ｺ CUERPO%'

-- borro los datos de las encuestas respuestas y planas e inconsistencias
    
