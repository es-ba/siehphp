/*
*672696 - comuna 8/R6/Up79/L784/Mariano Acosta 3664/dto Fondo (VIENE DE LA ENCUESTA 612696 FTE)
*371054 – comuna 8/R3/Up209/L332/Saladillo 3333/dto Fondo (VIENE DE LA ENCUESTA 311054 FTE)
*572878 – comuna 10/R5/Up60/L659/ Pergamino 290/dto A (VIENE DE LA ENCUESTA 512878  A) 
*371627 – comuna 12/R3/Up502/L390/ Miller 2871/dto PB (VIENE DE LA ENCUESTA 311627 Piso PA)
*370529- comuna 4/R3/Up484/L387/Atuel 269/Piso 1º dto “2” (VIENE DE LA ENCUESTA 310529 PB 1)
*/

insert into encu.tem 
SELECT 672696, tem_id_marco, tem_comuna, tem_replica, tem_up, tem_lote, 
       tem_clado, tem_ccodigo, tem_cnombre, tem_hn, tem_hp, 'FONDO', 
       tem_hab, tem_h4, tem_usp, tem_barrio, tem_ident_edif, tem_obs, 
       tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_dominio, 
       tem_marco, tem_titular, tem_zona, tem_lote2011, tem_para_asignar, 
       tem_participacion, tem_tlg, tem_codpos, tem_etiquetas, tem_tipounidad, 
       tem_tot_hab, tem_estrato
FROM encu.tem where tem_enc=612696;

insert into encu.tem 
SELECT 371054, tem_id_marco, tem_comuna, tem_replica, tem_up, tem_lote, 
       tem_clado, tem_ccodigo, tem_cnombre, tem_hn, tem_hp, 'FONDO', 
       tem_hab, tem_h4, tem_usp, tem_barrio, tem_ident_edif, tem_obs, 
       tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_dominio, 
       tem_marco, tem_titular, tem_zona, tem_lote2011, tem_para_asignar, 
       tem_participacion, tem_tlg, tem_codpos, tem_etiquetas, tem_tipounidad, 
       tem_tot_hab, tem_estrato
FROM encu.tem where tem_enc=311054;

insert into encu.tem 
SELECT 572878, tem_id_marco, tem_comuna, tem_replica, tem_up, tem_lote, 
       tem_clado, tem_ccodigo, tem_cnombre, tem_hn, tem_hp, 'A', 
       tem_hab, tem_h4, tem_usp, tem_barrio, tem_ident_edif, tem_obs, 
       tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_dominio, 
       tem_marco, tem_titular, tem_zona, tem_lote2011, tem_para_asignar, 
       tem_participacion, tem_tlg, tem_codpos, tem_etiquetas, tem_tipounidad, 
       tem_tot_hab, tem_estrato
  FROM encu.tem where tem_enc=512878;

insert into encu.tem 
SELECT 371627, tem_id_marco, tem_comuna, tem_replica, tem_up, tem_lote, 
       tem_clado, tem_ccodigo, tem_cnombre, tem_hn, tem_hp, 'PB', 
       tem_hab, tem_h4, tem_usp, tem_barrio, tem_ident_edif, tem_obs, 
       tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_dominio, 
       tem_marco, tem_titular, tem_zona, tem_lote2011, tem_para_asignar, 
       tem_participacion, tem_tlg, tem_codpos, tem_etiquetas, tem_tipounidad, 
       tem_tot_hab, tem_estrato
FROM encu.tem where tem_enc=311627;

insert into encu.tem 
SELECT 370529, tem_id_marco, tem_comuna, tem_replica, tem_up, tem_lote, 
       tem_clado, tem_ccodigo, tem_cnombre, tem_hn, '1', '2', 
       tem_hab, tem_h4, tem_usp, tem_barrio, tem_ident_edif, tem_obs, 
       tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_dominio, 
       tem_marco, tem_titular, tem_zona, tem_lote2011, tem_para_asignar, 
       tem_participacion, tem_tlg, tem_codpos, tem_etiquetas, tem_tipounidad, 
       tem_tot_hab, tem_estrato
FROM encu.tem where tem_enc=310529;

insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
values
('eah2013', 'TEM','', 672696, 0, 0, 0, 1),
('eah2013', 'TEM','', 371054, 0, 0, 0, 1),
('eah2013', 'TEM','', 572878, 0, 0, 0, 1),
('eah2013', 'TEM','', 371627, 0, 0, 0, 1),
('eah2013', 'TEM','', 370529, 0, 0, 0, 1);

update encu.respuestas
  set res_valor=null
  where res_ope='eah2013' and res_for='TEM' and res_mat='' and res_var='estado' and  res_enc in (
            672696,
            371054,
            572878,
            371627,
            370529);