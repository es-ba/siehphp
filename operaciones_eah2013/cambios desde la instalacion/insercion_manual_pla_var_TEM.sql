insert into encu.planillas(planilla_planilla, planilla_nombre, planilla_tlg) values  ('MON_TEM','Planilla de Monitoreo de la TEM', 1);
insert into encu.pla_var values ('REC_REC', 'eah2013', 'con_dato_recu',440,1);
--delete from encu.pla_var where plavar_planilla = 'MON_TEM';
insert into encu.pla_var select 'MON_TEM', 'eah2013', var_var, 0, 1 from encu.variables where var_var in (select distinct(plavar_var) from encu.pla_var 
where plavar_planilla in ('CAR_ENC', 'REC_ENC', 'CAR_REC', 'REC_REC', 'CAR_SUP_ENC', 'CAR_SUP_REC', 'REC_SUP_ENC', 'REC_SUP_REC') and plavar_ope = 'eah2013');

update encu.pla_var set plavar_orden = 10  where plavar_var = 'asignable';
update encu.pla_var set plavar_orden = 20  where plavar_var = 'recepcionista';
update encu.pla_var set plavar_orden = 30  where plavar_var = 'rea';
update encu.pla_var set plavar_orden = 40  where plavar_var = 'norea';
update encu.pla_var set plavar_orden = 50  where plavar_var = 'estado';
update encu.pla_var set plavar_orden = 60  where plavar_var = 'cod_enc';
update encu.pla_var set plavar_orden = 70  where plavar_var = 'dispositivo_enc';
update encu.pla_var set plavar_orden = 80  where plavar_var = 'fecha_carga_enc';
update encu.pla_var set plavar_orden = 90  where plavar_var = 'fecha_primcarga_enc';
update encu.pla_var set plavar_orden = 100 where plavar_var = 'fecha_descarga_enc';
update encu.pla_var set plavar_orden = 110 where plavar_var = 'comenzo_ingreso';
update encu.pla_var set plavar_orden = 120 where plavar_var = 'a_ingreso_enc';
update encu.pla_var set plavar_orden = 130 where plavar_var = 'con_dato_enc';
update encu.pla_var set plavar_orden = 140 where plavar_var = 'volver_a_cargar_enc';
update encu.pla_var set plavar_orden = 150 where plavar_var = 'fin_ingreso_enc';
update encu.pla_var set plavar_orden = 160 where plavar_var = 'rea_enc';
update encu.pla_var set plavar_orden = 170 where plavar_var = 'norea_enc';
update encu.pla_var set plavar_orden = 180 where plavar_var = 'pob_tot';
update encu.pla_var set plavar_orden = 190 where plavar_var = 'pob_pre';
update encu.pla_var set plavar_orden = 200 where plavar_var = 'hog_tot';
update encu.pla_var set plavar_orden = 210 where plavar_var = 'hog_pre';
update encu.pla_var set plavar_orden = 220 where plavar_var = 'verificado_enc';
update encu.pla_var set plavar_orden = 230 where plavar_var = 'cod_recu';
update encu.pla_var set plavar_orden = 240 where plavar_var = 'dispositivo_recu';
update encu.pla_var set plavar_orden = 250 where plavar_var = 'fecha_carga_recu';
update encu.pla_var set plavar_orden = 260 where plavar_var = 'fecha_primcarga_recu';
update encu.pla_var set plavar_orden = 270 where plavar_var = 'fecha_descarga_recu';
update encu.pla_var set plavar_orden = 280 where plavar_var = 'a_ingreso_recu';
update encu.pla_var set plavar_orden = 290 where plavar_var = 'con_dato_recu';
update encu.pla_var set plavar_orden = 300 where plavar_var = 'volver_a_cargar_recu';
update encu.pla_var set plavar_orden = 310 where plavar_var = 'fin_ingreso_recu';
update encu.pla_var set plavar_orden = 320 where plavar_var = 'rea_recu';
update encu.pla_var set plavar_orden = 330 where plavar_var = 'norea_recu';
update encu.pla_var set plavar_orden = 340 where plavar_var = 'verificado_recu';
update encu.pla_var set plavar_orden = 350 where plavar_var = 'sup_dirigida_enc';
update encu.pla_var set plavar_orden = 360 where plavar_var = 'sup_aleat_enc';
update encu.pla_var set plavar_orden = 370 where plavar_var = 'cod_supe';
update encu.pla_var set plavar_orden = 380 where plavar_var = 'fecha_carga_supe';
update encu.pla_var set plavar_orden = 390 where plavar_var = 'verificado_supe';
update encu.pla_var set plavar_orden = 400 where plavar_var = 'result_supe';
update encu.pla_var set plavar_orden = 410 where plavar_var = 'sup_dirigida_recu';
update encu.pla_var set plavar_orden = 420 where plavar_var = 'sup_aleat_recu';
update encu.pla_var set plavar_orden = 430 where plavar_var = 'cod_supr';
update encu.pla_var set plavar_orden = 440 where plavar_var = 'fecha_carga_supr';
update encu.pla_var set plavar_orden = 450 where plavar_var = 'verificado_supr';
update encu.pla_var set plavar_orden = 460 where plavar_var = 'result_supr';

















